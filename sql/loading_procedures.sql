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
		cast(city_id as tinyint),
		trim(city_name),
		trim(country),
		trim(region),
		cast(population as int),
		trim(size_category)
	from bronze.cities;
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
		cast(city_id as tinyint),
		trim(city_name),
		trim(country),
		trim(region),
		cast(population as int),
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
		cast(cuisine_category_id as tinyint),
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
		cast(dish_id as smallint),
		trim(dish_name),
		cast(cuisine_category_id as tinyint),
		cast(price_eur as decimal(10,2)),
		cast(is_vegetarian as bit),
		cast(is_spicy as bit),
		cast(popularity_score as float)
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
		cast(order_item_id as int),
		cast(order_id as int),
		cast(dish_id as smallint),
		cast(quantity as tinyint),
		cast(price_per_item_eur as decimal(10,2)),
		cast(subtotal_eur as decimal(10,2))
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
		cast(person_id as int),
		trim(person_name),
		trim(person_type),
		cast(city_id as int),
		trim(age_group),
		trim(gender),
		trim(phone),
		cast(registration_date as date),
		trim(account_status),
		cast(total_transactions as smallint)
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
		cast(restaurant_id as smallint),
		trim(restaurant_name),
		cast(owner_id as int),
		cast(city_id as tinyint),
		cast(cuisine_category_id as tinyint),
		cast(opening_year as smallint),
		cast(total_orders_count as int),
		cast(average_rating as float),
		cast(number_of_dishes as int),
		cast(is_active as bit)
	from bronze.restaurants;
end;
go