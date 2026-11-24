USE FoodMarket;
GO

create or alter procedure bronze.load_all
as
begin	
	set nocount on;

	truncate table bronze.cities;
	truncate table bronze.city_market_metrics;
	truncate table bronze.cuisine_categories;
	truncate table bronze.dishes;
	truncate table bronze.order_items;
	truncate table bronze.orders;
	truncate table bronze.people;
	truncate table bronze.restaurants;

	--load csv files
	bulk insert bronze.people
    from 'C:\Users\masa.gacevic\Desktop\DA_intern\people.csv'
    with
    (
        firstrow = 2,
        fieldterminator = ',',
        rowterminator = '0x0a',
        codepage = '65001',
        tablock
    );

	bulk insert bronze.dishes
    from 'C:\Users\masa.gacevic\Desktop\DA_intern\dishes.csv'
    with
    (
        firstrow = 2,
        fieldterminator = ',',
        rowterminator = '0x0a',
        codepage = '1252',
        tablock
    );

	bulk insert bronze.restaurants
    from 'C:\Users\masa.gacevic\Desktop\DA_intern\restaurants.csv'
    with
    (
        firstrow = 2,
        fieldterminator = ',',
        rowterminator = '0x0a',
        codepage = '65001',
        tablock
    );

	bulk insert bronze.orders
    from 'C:\Users\masa.gacevic\Desktop\DA_intern\orders.csv'
    with
    (
        firstrow = 2,
        fieldterminator = ',',
        rowterminator = '0x0a',
        codepage = '65001',
        tablock
    );

	bulk insert bronze.order_items
    from 'C:\Users\masa.gacevic\Desktop\DA_intern\order_items.csv'
    with
    (
        firstrow = 2,
        fieldterminator = ',',
        rowterminator = '0x0a',
        codepage = '65001',
        tablock
    );

	bulk insert bronze.city_market_metrics
    from 'C:\Users\masa.gacevic\Desktop\DA_intern\city_market_metrics.csv'
    with
    (
        firstrow = 2,
        fieldterminator = ',',
        rowterminator = '0x0a',
        codepage = '65001',
        tablock
    );

	bulk insert bronze.cuisine_categories
    from 'C:\Users\masa.gacevic\Desktop\DA_intern\cuisine_categories.csv'
    with
    (
        firstrow = 2,
        fieldterminator = ',',
        rowterminator = '0x0a',
        codepage = '65001',
        tablock
    );

	bulk insert bronze.cities
    from 'C:\Users\masa.gacevic\Desktop\DA_intern\cities.csv'
    with
    (
        firstrow = 2,
        fieldterminator = ',',
        rowterminator = '0x0a',
        codepage = '65001',
        tablock
    );

end;
go

exec bronze.load_all;

select *
from bronze.people;

select *
from bronze.cities;

select *
from bronze.city_market_metrics;

select *
from bronze.cuisine_categories;

select *
from bronze.order_items;

select *
from bronze.restaurants;

select *
from bronze.dishes;

select *
from bronze.orders;