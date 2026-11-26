
use foodmarket;
go

create or alter procedure gold.load_all
as
begin
    set nocount on;

    --------------------------------------------------
    -- 1. brisanje fact tabela
    --------------------------------------------------

    delete from gold.FactOrder_item;
    delete from gold.FactOrder;
    delete from gold.FactCityMarketMetrics;


    --------------------------------------------------
    -- 2. brisanje dimenzija
    --------------------------------------------------

    delete from gold.DimRestaurant;
    delete from gold.DimPeople;
    delete from gold.DimDish;
    delete from gold.DimDate;
    delete from gold.DimCities;
    delete from gold.DimCuisineCategory;


    --------------------------------------------------
    -- 3. punjenje dimenzija bez zavisnosti
    --------------------------------------------------

    -- dimcuisinecategory
    insert into gold.DimCuisineCategory(
        cuisine_category_id,
        cuisine_name
    )
    select
        cuisine_category_id,
        cuisine_name
    from silver.cuisine_categories;


    -- dimcities
    insert into gold.DimCities(
        city_id,
        city_name,
        country,
        region,
        population,
        size_category
    )
    select
        city_id,
        city_name,
        country,
        region,
        population,
        size_category
    from silver.cities;


    -- dimdate
    set datefirst 1;

    insert into gold.DimDate(
        date_id,
        year,
        month,
        day,
        is_weekend,
        quarter
    )
    select
        d,
        year(d),
        month(d),
        day(d),
        case
            when datepart(weekday, d) in (6, 7) then 1
            else 0
        end,
        datepart(quarter, d)
    from generate_series(
        0,
        datediff(day, '20200101', '20240101')
    ) as gs
    cross apply (
        select dateadd(day, gs.value, cast('20200101' as date)) as d
    ) as dates;


    --------------------------------------------------
    -- 4. punjenje dimenzija koje zavise od drugih
    --------------------------------------------------

    -- dimrestaurant
    insert into gold.DimRestaurant(
        restaurant_id,
        owner_id,
        city_id,
        restaurant_name,
        cuisine_category_id,
        total_orders_count,
        number_of_dishes,
        is_active,
        opening_year
    )
    select
        restaurant_id,
        owner_id,
        city_id,
        restaurant_name,
        cuisine_category_id,
        total_orders_count,
        number_of_dishes,
        is_active,
        opening_year
    from silver.restaurants;


    -- dimdish
    insert into gold.DimDish(
        dish_id,
        dish_name,
        cuisine_category_id,
        price_eur,
        is_vegetarian,
        is_spicy,
        popularity_score
    )
    select
        dish_id,
        dish_name,
        cuisine_category_id,
        price_eur,
        is_vegetarian,
        is_spicy,
        popularity_score
    from silver.dishes;


    -- dimpeople
    insert into gold.DimPeople(
        person_id,
        person_name,
        person_type,
        city_id,
        age_group,
        phone,
        registration_date,
        account_status,
        gender
    )
    select
        person_id,
        person_name,
        person_type,
        city_id,
        age_group,
        phone,
        registration_date,
        account_status,
        gender
    from silver.people;


    --------------------------------------------------
    -- 5. punjenje fact tabela
    --------------------------------------------------

    -- factcitymarketmetrics
    insert into gold.FactCityMarketMetrics(
        city_id,
        month_date,
        avg_order_value_eur,
        inflation_rate_percent,
        unemployment_rate_percent,
        avg_delivery_time_minutes,
        active_customers_count,
        active_restaurants_count,
        delivery_cost_per_km_eur
    )
    select
        city_id,
        month_date,
        avg_order_value_eur,
        inflation_rate_percent,
        unemployment_rate_percent,
        avg_delivery_time_minutes,
        active_customers_count,
        active_restaurants_count,
        delivery_cost_per_km_eur
    from silver.city_market_metrics;


    -- factorder
    insert into gold.FactOrder(
        order_id,
        restaurant_id,
        customer_id,
        driver_id,
        city_id,
        owner_id,
        customer_rating,
        order_datetime,
        total_orders_count,
        order_amount_eur,
        delivery_fee_eur,
        discount_eur,
        delivery_time_minutes,
        average_rating,
        customer_total_transactions,
        driver_total_transactions,
        owner_total_transactions
    )
    select
        o.order_id,
        o.restaurant_id,
        o.customer_id,
        o.driver_id,
        r.city_id,
        r.owner_id,
        o.customer_rating,
        o.order_datetime,
        r.total_orders_count,
        o.order_amount_eur,
        o.delivery_fee_eur,
        o.discount_eur,
        o.delivery_time_minutes,
        r.average_rating,
        p_customer.total_transactions,
        p_driver.total_transactions,
        p_owner.total_transactions
    from silver.orders o
    join silver.restaurants r
        on o.restaurant_id = r.restaurant_id
    join silver.people p_customer
        on o.customer_id = p_customer.person_id
        and p_customer.person_type = 'Customer'
    join silver.people p_driver
        on o.driver_id = p_driver.person_id
        and p_driver.person_type = 'Driver'
    join silver.people p_owner
        on r.owner_id = p_owner.person_id
        and p_owner.person_type = 'Restaurant Owner';


    -- factorder_item
    insert into gold.FactOrder_item(
        order_id,
        order_item_id,
        dish_id,
        subtotal_eur,
        price_per_item_eur,
        quantity
    )
    select
        oi.order_id,
        oi.order_item_id,
        oi.dish_id,
        oi.subtotal_eur,
        oi.price_per_item_eur,
        oi.quantity
    from silver.order_items oi
    inner join gold.factorder fo
        on oi.order_id = fo.order_id;

end;
go