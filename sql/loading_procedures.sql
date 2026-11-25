USE FoodMarket;
GO

create or alter procedure silver.load_city_market_metrics
as
begin
	set nocount on;

	truncate table silver.city_market_metrics;

	insert into silver.city_market_metrics(
		city_id,
		month_date,
		avg_order_value_eur,
		total_orders_count,
		inflation_rate_percent,
		unemployment_rate_percent,
		avg_delivery_time_minutes,
		active_customers_count,
		active_restaurants_count,
		delivery_cost_per_km_eur
	)
	select
		try_cast(city_id as tinyint),
		try_cast(trim(month_date) + '-01' as date),
		try_cast(avg_order_value_eur as decimal(10,2)),
		try_cast(total_orders_count as smallint),
		try_cast(inflation_rate_percent as float),
		try_cast(unemployment_rate_percent as float),
		try_cast(avg_delivery_time_minutes as smallint),
		try_cast(active_customers_count as smallint),
		try_cast(active_restaurants_count as smallint),
		try_cast(delivery_cost_per_km_eur as decimal(10,2))
	from bronze.city_market_metrics
	where avg_order_value_eur is not null and
		  total_orders_count is not null and
		  inflation_rate_percent is not null and
		  unemployment_rate_percent is not null and
		  avg_delivery_time_minutes is not null and
		  active_customers_count is not null and
		  active_restaurants_count is not null and
		  delivery_cost_per_km_eur is not null;
end;
go


create or alter procedure silver.load_cities
as
begin
	set nocount on;

	truncate table silver.cities;

	insert into silver.cities(
		city_id,
		city_name,
		country,
		region,
		population,
		size_category
	)
	select
		try_cast(city_id as tinyint),
		trim(city_name),
		trim(country),
		trim(region),
		try_cast(population as int),
		trim(size_category)
	from bronze.cities;
end;
go


create or alter procedure silver.load_cuisine_categories
as
begin
	set nocount on;

	truncate table silver.cuisine_categories;

	insert into silver.cuisine_categories(
		cuisine_category_id,
		cuisine_name
	)
	select
		try_cast(cuisine_category_id as tinyint),
		trim(cuisine_name)
	from bronze.cuisine_categories;
end;
go

create or alter procedure silver.load_dishes
as
begin
	set nocount on;

	truncate table silver.dishes;

	insert into silver.dishes(
		dish_id,
		dish_name,
		cuisine_category_id,
		price_eur,
		is_vegetarian,
		is_spicy,
		popularity_score
	)
	select
		try_cast(dish_id as smallint),
		trim(dish_name),
		try_cast(cuisine_category_id as tinyint),
		try_cast(price_eur as decimal(10,2)),
		try_cast(is_vegetarian as bit),
		try_cast(is_spicy as bit),
		try_cast(popularity_score as float)
	from bronze.dishes;
end;
go

create or alter procedure silver.load_order_items
as
begin
	set nocount on;

	truncate table silver.order_items;

	insert into silver.order_items(
		order_item_id,
		order_id,
		dish_id,
		quantity,
		price_per_item_eur,
		subtotal_eur
	)
	select
		try_cast(order_item_id as int),
		try_cast(order_id as int),
		try_cast(dish_id as smallint),
		try_cast(quantity as tinyint),
		try_cast(price_per_item_eur as decimal(10,2)),
		try_cast(subtotal_eur as decimal(10,2))
	from bronze.order_items;
end;
go

create or alter procedure silver.load_people
as
begin
	set nocount on;

	truncate table silver.people;

	insert into silver.people(
		person_id,
		person_name,
		person_type,
		city_id,
		age_group,
		gender,
		phone,
		registration_date,
		account_status,
		total_transactions
	)
	select
		try_cast(person_id as int),
		trim(person_name),
		trim(person_type),
		try_cast(city_id as int),
		trim(age_group),
		trim(gender),
		trim(phone),
		try_cast(registration_date as date),
		trim(account_status),
		try_cast(total_transactions as smallint)
	from bronze.people;
end;
go

create or alter procedure silver.load_restaurants
as
begin
	set nocount on;

	truncate table silver.restaurants;

	insert into silver.restaurants(
		restaurant_id,
		restaurant_name,
		owner_id,
		city_id,
		cuisine_category_id,
		opening_year,
		total_orders_count,
		average_rating,
		number_of_dishes,
		is_active
	)
	select
		try_cast(restaurant_id as smallint),
		trim(restaurant_name),
		try_cast(owner_id as int),
		try_cast(city_id as tinyint),
		try_cast(cuisine_category_id as tinyint),
		try_cast(opening_year as smallint),
		try_cast(total_orders_count as int),
		try_cast(average_rating as float),
		try_cast(number_of_dishes as int),
		try_cast(is_active as bit)
	from bronze.restaurants;
end;
go

create or alter procedure silver.load_orders
as
begin
	set nocount on;

	truncate table silver.orders;

	with ranked_orders as (
        select
            *,
            row_number() over (
                partition by order_id
                order by delivery_datetime desc, order_amount_eur desc
            ) as rn
        from bronze.orders
        where delivery_fee_eur IS NOT NULL
    ),
    grouped_orders as (
        select
            *,
            percentile_cont(0.5) within group (
                order by customer_rating
            ) over (
                partition by
                    discount_eur,
                    order_amount_eur,
                    delivery_time_minutes
            ) as group_median
        from ranked_orders
        where rn = 1
    ),
    median_orders as (
        select
            *,
            percentile_cont(0.5) within group(
                order by customer_rating
            ) over () as overall_median
        from grouped_orders
    )
	insert into silver.orders(
		order_id,
		customer_id,
		restaurant_id,
		driver_id,
		order_datetime,
		delivery_datetime,
		order_amount_eur,
		delivery_fee_eur,
		discount_eur,
		delivery_time_minutes,
		customer_rating
	)
	select
		try_cast(order_id as int),
		try_cast(customer_id as int),
		try_cast(restaurant_id as smallint),
		try_cast(driver_id as int),
		try_cast(order_datetime as date),
		try_cast(delivery_datetime as date),
		try_cast(order_amount_eur as decimal(10,2)),
		try_cast(delivery_fee_eur as decimal(10,2)),
		try_cast(discount_eur as decimal(10,2)),
		try_cast(delivery_time_minutes as smallint),
		try_cast(coalesce(customer_rating, group_median, overall_median) as decimal(5, 1))
	from median_orders;
end;
go