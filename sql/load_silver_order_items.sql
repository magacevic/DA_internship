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