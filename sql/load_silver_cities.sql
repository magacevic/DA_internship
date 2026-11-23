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
