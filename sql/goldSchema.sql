USE FoodMarket;
GO

create table DimCuisineCategory(
	cuisine_category_id int primary key not null,
	cuisine_name varchar(255)
);

ALTER SCHEMA gold
TRANSFER dbo.DimCuisineCategory;

create table gold.DimRestaurant(
	restaurant_id int primary key not null,
	owner_id int,
	city_id int not null,
	restaurant_name varchar(255),
	cuisine_category_id int not null,
	total_orders_count int,
	number_of_dishes int,
	is_active char,
	opening_year int
);

ALTER TABLE gold.DimRestaurant
ADD CONSTRAINT FK_DimRestaurant_DimCuisineCategory
FOREIGN KEY (cuisine_category_id)
REFERENCES gold.DimCuisineCategory(cuisine_category_id);

create table gold.DimCities(
	city_id int primary key not null,
	city_name varchar(255),
	country varchar(255),
	region varchar(255),
	population int,
	size_category varchar(255)
);

create table gold.DimDate(
	date_id date primary key not null,
	year int, 
	month int,
	day int,
	quarter int, 
	is_weekend char
);

create table gold.DimDish(
	dish_id int primary key not null,
	dish_name varchar(255),
	cuisine_category_id int not null,
	price_eur decimal(10,2),
	is_vegeterian char,
	is_spicy char,
	popularity_score float
);

create table gold.FactCityMarketMetrics(
	city_id int not null,
	month_date varchar(10) not null,
	avg_order_value_eur decimal(10, 2),
	inflation_rate_percent float,
	unemployment_rate_percent float,
	avg_delivery_time_minutes int,
	active_customers_count int,
	active_restaurants_count int,
	delivery_cost_per_km_eur decimal(10,2),

	constraint PK_FactCityMarketMetrics primary key (city_id, month_date)
);

create table gold.FactOrder_item(
	order_item_id int primary key not null,
	order_id int not null,
	dish_id int not null,
	subtotal_eur decimal(10,2),
	quantity int,
	price_per_item_eur decimal(10,2)
);

alter table gold.FactOrder_item
add constraint FK_FactOrder_item_DimDish
foreign key (dish_id)
references gold.DimDish(dish_id);

create table gold.FactOrder(
	order_id int primary key not null,
	restaurant_id int not null,
	customer_id int not null,
	driver_id int not null,
	city_id int not null,
	owner_id int not null,
	customer_rating float,
	order_datetime date,
	total_orders_count int,
	total_transactions int,
	order_amount_eur decimal(10,2),
	delivery_fee_eur decimal(10,2),
	discount_eur decimal(10,2),
	delivery_time_minutes int,
	average_rating float
);

alter table gold.FactOrder
add constraint FK_FactOrder_DimRestaurant
foreign key (restaurant_id)
references gold.DimRestaurant(restaurant_id);

create table gold.DimPeople(
	person_id int primary key not null,
	person_name varchar(255),
	person_type varchar(255) not null,
	city_id int not null,
	age_group varchar(255),
	phone varchar(255),
	registration_date date,
	account_status char
);

alter table gold.FactOrder
add constraint FK_FactOrder_DimPeopleCustomer
foreign key (customer_id)
references gold.DimPeople(person_id);

alter table gold.FactOrder
add constraint FK_FactOrder_DimPeopleDriver
foreign key (customer_id)
references gold.DimPeople(person_id);

alter table gold.FactOrder
add constraint FK_FactOrder_DimPeopleOwner
foreign key (customer_id)
references gold.DimPeople(person_id);

alter table gold.FactOrder
add constraint FK_FactOrder_DimCities
foreign key (city_id)
references gold.DimCities;

alter table gold.FactOrder
add constraint FK_FactOrder_DimDate
foreign key (order_datetime)
references gold.DimDate(date_id);

alter table gold.DimPeople
add constraint FK_DimPeople_DimCities
foreign key (city_id)
references gold.DimCities(city_id);