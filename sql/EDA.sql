USE FoodMarket;
GO

--bronze.cities i bronze.cuisine_category nemaju promjena iz bronze u silver
select count(*) as total_rows
from bronze.cities;

select *
from bronze.cities
where city_id is null
	or city_name is null
	or country is null
	or region is null
	or size_category is null;

select city_id, count(*)
from bronze.cities
group by city_id
having count(*) > 1;

select size_category, COUNT(*)
from bronze.cities
group by size_category;

select min(population) as minimal_population, max(population) as maximal_population, avg(population) as average_population
from bronze.cities

select *
from bronze.cuisine_categories;

select cuisine_category_id, count(*)
from bronze.cuisine_categories
group by cuisine_category_id
having count(*) > 1;

select count(*) as rows
from bronze.people;

select person_id, count(*) as duplicates
from bronze.people
group by person_id
having count(*) > 1;

select
    count(*) AS total_rows,
    count(person_id) AS person_id_count,
    count(person_name) AS person_name_count,
    count(person_type) AS person_type_count,
    count(city_id) AS city_id_count,
    count(age_group) AS age_group_count,
    count(gender) AS gender_count,
    count(phone) AS phone_count,
    count(registration_date) AS registration_date_count,
    count(account_status) AS account_status_count,
    count(total_transactions) AS total_transactions_count
from bronze.people;

select *
from bronze.people
where total_transactions < 0;

select *
from bronze.people
where person_type not in ('Customer', 'Driver', 'Restaurant Owner');

select p.person_id 
from bronze.people p left join bronze.cities c
	 on p.city_id = c.city_id
where c.city_id is null;

select count(*) as null_rows
from bronze.city_market_metrics
where avg_order_value_eur is null and total_orders_count is null
	and inflation_rate_percent is null and unemployment_rate_percent is null
	and avg_delivery_time_minutes is null and active_customers_count is null
	and active_restaurants_count is null and delivery_cost_per_km_eur is null;

select *
from bronze.city_market_metrics;

select city_id,
	   (case when month_date is null then 1 else 0 end + 
	    case when avg_order_value_eur is null then 1 else 0 end +
		case when total_orders_count is null then 1 else 0 end +
		case when inflation_rate_percent is null then 1 else 0 end +
		case when unemployment_rate_percent is null then 1 else 0 end +
		case when avg_delivery_time_minutes is null then 1 else 0 end +
		case when active_customers_count is null then 1 else 0 end +
		case when active_restaurants_count is null then 1 else 0 end + 
		case when delivery_cost_per_km_eur is null then 1 else 0 end)
from bronze.city_market_metrics;

select count(distinct(dish_id))
from bronze.dishes;	

select cuisine_category_id, popularity_score, count(*) as num_of_dishes
from bronze.dishes
group by cuisine_category_id, popularity_score;

select count(distinct(dish_name))
from bronze.dishes;

select count(distinct(order_item_id)) as unique_items, count(distinct(order_id)) as unique_orders, count(distinct(dish_id)) as unique_dishes
from bronze.order_items;

select *
from bronze.order_items
where order_item_id is null or
	  order_id is null or
	  dish_id is null or
	  quantity is null or
	  price_per_item_eur is null or
	  subtotal_eur is null;

select order_item_id, count(*) as duplicated_rows
from bronze.order_items
group by order_item_id
having count(*) > 1;

select
    order_id,
    dish_id,
    quantity,
    price_per_item_eur,
    subtotal_eur,
    count(*) as occurrences
from bronze.order_items
group by
    order_id,
    dish_id,
    quantity,
    price_per_item_eur,
    subtotal_eur
having count(*) > 1;