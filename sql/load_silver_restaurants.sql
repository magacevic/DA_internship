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