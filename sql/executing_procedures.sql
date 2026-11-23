USE FoodMarket;
GO

exec silver.load_cities;

select *
from silver.cities;

exec silver.load_city_market_metrics;

select *
from silver.city_market_metrics;

exec silver.load_cuisine_categories;

select *
from silver.cuisine_categories;

exec silver.load_dishes;

select *
from silver.dishes;

exec silver.load_order_items;

select *
from silver.order_items;

exec silver.load_people

select *
from silver.people;

exec silver.load_restaurants;

select *
from silver.restaurants;