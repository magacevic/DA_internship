USE FoodMarket;
GO

create or alter procedure silver.load_all
as
begin
    set nocount on;

    exec silver.load_cities;
    exec silver.load_cuisine_categories;
    exec silver.load_dishes;
    exec silver.load_people;
    exec silver.load_restaurants;
    exec silver.load_order_items;
	exec silver.load_city_market_metrics;
	exec silver.load_orders;
end;
go