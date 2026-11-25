create table silver.city_market_metrics(
	city_id tinyint not null,
	month_date varchar(10) not null,
	avg_order_value_eur decimal(10,2),
	total_orders_count smallint,
	inflation_rate_percent float,
	unemployment_rate_percent float,
	avg_delivery_time_minutes smallint,
	active_customers_count smallint,
	active_restaurants_count smallint,
	delivery_cost_per_km_eur decimal(10,2)
);

alter table silver.city_market_metrics
add constraint PK_City_marketM
primary key (city_id, month_date);

create table silver.cities(
	city_id tinyint primary key not null,
	city_name varchar(255),
	country varchar(255),
	region varchar(255),
	population int,
	size_category varchar(255)
);

alter table silver.cities
alter column city_name nvarchar(255);

alter table silver.cities
alter column country nvarchar(255);

alter table silver.cities
alter column region nvarchar(255);

alter table silver.cities
alter column size_category nvarchar(255);

create table silver.cuisine_categories(
	cuisine_category_id tinyint primary key not null,
	cuisine_name varchar(255)
);

alter table silver.cuisine_categories
alter column cuisine_name nvarchar(255);

create table silver.people(
	person_id int primary key not null,
	person_name varchar(255),
	person_type varchar(255),
	city_id int,
	age_group varchar(255),
	gender varchar(10),
	phone varchar(255),
	registration_date date,
	account_status varchar(15),
	total_transactions smallint
);

alter table silver.people
alter column person_name nvarchar(255);

alter table silver.people
alter column person_type nvarchar(255);

alter table silver.people
alter column age_group nvarchar(255);

alter table silver.people
alter column gender nvarchar(255);

alter table silver.people
alter column phone nvarchar(255);

alter table silver.people
alter column account_status nvarchar(255);

create table silver.order_items(
	order_item_id int primary key not null,
	order_id int,
	dish_id smallint,
	quantity tinyint,
	price_per_item_eur decimal(10,2),
	subtotal_eur decimal(10,2)
);

truncate table silver.order_items;

create table silver.dishes(
	dish_id smallint primary key not null,
	dish_name varchar(255),
	cuisine_category_id tinyint,
	price_eur decimal(10,2),
	is_vegetarian char,
	is_spicy char,
	popularity_score float
);

alter table silver.dishes
alter column is_vegetarian BIT;

alter table silver.dishes
alter column dish_name nvarchar(255);

alter table silver.dishes
alter column is_spicy BIT;

truncate table silver.dishes;

create table silver.restaurants(
	restaurant_id smallint primary key not null,
	restaurant_name varchar(255),
	owner_id int,
	city_id tinyint,
	cuisine_category_id tinyint,
	opening_year smallint,
	total_orders_count int,
	average_rating float,
	number_of_dishes int,
	is_active bit
);

alter table silver.restaurants
alter column restaurant_name nvarchar(255);

create table silver.orders(
	order_id int primary key not null,
	customer_id int,
	restaurant_id smallint,
	driver_id int,
	order_datetime varchar(255),
	delivery_datetime varchar(255),
	order_amount_eur decimal(10,2),
	delivery_fee_eur decimal(10,2),
	discount_eur decimal(10,2),
	delivery_time_minutes smallint,
	customer_rating float
);