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