create or alter procedure silver.load_city_market_metrics
as
begin
	set nocount on;

	truncate table silver.city_market_metrics;

	insert into silver.city_market_metrics(
		city_id,
		month_date,
		avg_order_value_eur,
		total_orders_count,
		inflation_rate_percent,
		unemployment_rate_percent,
		avg_delivery_time_minutes,
		active_customers_count,
		active_restaurants_count,
		delivery_cost_per_km_eur
	)
	select
		cast(city_id as tinyint),
		trim(month_date),
		cast(avg_order_value_eur as decimal(10,2)),
		cast(total_orders_count as smallint),
		cast(inflation_rate_percent as float),
		cast(unemployment_rate_percent as float),
		cast(avg_delivery_time_minutes as smallint),
		cast(active_customers_count as smallint),
		cast(active_restaurants_count as smallint),
		cast(delivery_cost_per_km_eur as decimal(10,2))
	from bronze.city_market_metrics
	where avg_order_value_eur IS NOT NULL
		AND total_orders_count IS NOT NULL
		AND inflation_rate_percent IS NOT NULL
		AND unemployment_rate_percent IS NOT NULL
		AND avg_delivery_time_minutes IS NOT NULL
		AND active_customers_count IS NOT NULL
		AND active_restaurants_count IS NOT NULL
		AND delivery_cost_per_km_eur IS NOT NULL;
end;
go