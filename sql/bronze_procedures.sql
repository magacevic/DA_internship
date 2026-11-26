USE FoodMarket;
GO

create or alter procedure bronze.load_all
	@folder_path nvarchar(500)
as
begin	
	set nocount on;

	declare @sql nvarchar(max);

	truncate table bronze.cities;
	truncate table bronze.city_market_metrics;
	truncate table bronze.cuisine_categories;
	truncate table bronze.dishes;
	truncate table bronze.order_items;
	truncate table bronze.orders;
	truncate table bronze.people;
	truncate table bronze.restaurants;

	--load csv files
	
	set @sql = '
		bulk insert bronze.people
		from ''' + concat(@folder_path, '\people.csv') + '''
		with
		(
			firstrow = 2,
			fieldterminator = '','',
			rowterminator = ''0x0a'',
			codepage = ''65001'',
			tablock
		);';
	exec sp_executesql @sql;

	set @sql = '
		bulk insert bronze.dishes
		from ''' + concat(@folder_path, '\dishes.csv') + '''
		with
		(
			firstrow = 2,
			fieldterminator = '','',
			rowterminator = ''0x0a'',
			codepage = ''65001'',
			tablock
		);';
	exec sp_executesql @sql;

	set @sql = '
		bulk insert bronze.restaurants
		from ''' + concat(@folder_path, '\restaurants.csv') + '''
		with
		(
			firstrow = 2,
			fieldterminator = '','',
			rowterminator = ''0x0a'',
			codepage = ''65001'',
			tablock
		);';
	exec sp_executesql @sql;

	set @sql = '
		bulk insert bronze.orders
		from ''' + concat(@folder_path, '\orders.csv') + '''
		with
		(
			firstrow = 2,
			fieldterminator = '','',
			rowterminator = ''0x0a'',
			codepage = ''65001'',
			tablock
		);';
	exec sp_executesql @sql;

	set @sql = '
		bulk insert bronze.order_items
		from ''' + concat(@folder_path, '\order_items.csv') + '''
		with
		(
			firstrow = 2,
			fieldterminator = '','',
			rowterminator = ''0x0a'',
			codepage = ''65001'',
			tablock
		);';
	exec sp_executesql @sql;

	set @sql = '
		bulk insert bronze.city_market_metrics
		from ''' + concat(@folder_path, '\city_market_metrics.csv') + '''
		with
		(
			firstrow = 2,
			fieldterminator = '','',
			rowterminator = ''0x0a'',
			codepage = ''65001'',
			tablock
		);';
	exec sp_executesql @sql;

	set @sql = '
		bulk insert bronze.cuisine_categories
		from ''' + concat(@folder_path, '\cuisine_categories.csv') + '''
		with
		(
			firstrow = 2,
			fieldterminator = '','',
			rowterminator = ''0x0a'',
			codepage = ''65001'',
			tablock
		);';
	exec sp_executesql @sql;

	set @sql = '
		bulk insert bronze.cities
		from ''' + concat(@folder_path, '\cities.csv') + '''
		with
		(
			firstrow = 2,
			fieldterminator = '','',
			rowterminator = ''0x0a'',
			codepage = ''65001'',
			tablock
		);';
	exec sp_executesql @sql;

end;
go

exec bronze.load_all
    @folder_path = 'C:\Users\masa.gacevic\Desktop\DA_intern';
go