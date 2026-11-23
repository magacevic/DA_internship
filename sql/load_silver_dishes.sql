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