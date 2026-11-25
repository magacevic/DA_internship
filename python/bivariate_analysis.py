import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

cities = pd.read_csv("../files/cities.csv")
people = pd.read_csv("../files/people.csv")
restaurants = pd.read_csv("../files/restaurants.csv")
orders = pd.read_csv("../files/orders_with_nulls.csv")
dishes = pd.read_csv("../files/dishes.csv")
order_items = pd.read_csv("../files/order_items.csv")
city_market_metrics = pd.read_csv("../files/city_market_metrics_with_nulls.csv")

#Correlation matrix for restaurants and its numeric features

restaurant_analysis = restaurants[['cuisine_category_id', 'total_orders_count', 'number_of_dishes', 'average_rating']]
correlation_matrix_r = restaurant_analysis.corr()

plt.figure(figsize=(6,4))
sns.heatmap(correlation_matrix_r, annot = True, cmap="seismic", vmax=1, vmin=-1)
plt.title("Restaurant features correlation matrix")
plt.tight_layout()
plt.show()

#Correlaion matrix for numeric features within City Market Metrics table

city_mm_analysis = city_market_metrics[['avg_order_value_eur', 'total_orders_count', 'inflation_rate_percent', 'avg_delivery_time_minutes', 'delivery_cost_per_km_eur']]
correlation_matrix_cmm = city_mm_analysis.corr()

plt.figure(figsize=(6,4))
sns.heatmap(correlation_matrix_cmm, annot = True, cmap="coolwarm", vmax=1, vmin=-1)
plt.title("City market metrics features correlation matrix")
plt.tight_layout()
plt.show()

#Correlation matrix for numeric features for ordes

orders_analysis = orders[['order_amount_eur', 'delivery_fee_eur', 'discount_eur', 'delivery_time_minutes', 'customer_rating']]
correlation_matrix_o = orders_analysis.corr()

plt.figure(figsize=(6,4))
sns.heatmap(correlation_matrix_o, annot = True, cmap="PiYG", vmax=1, vmin=-1)
plt.title("Order features correlation matrix")
plt.tight_layout()
plt.show()

#Correlation matrix for numeric features for dishes

dishes_analysis = dishes[['cuisine_category_id', 'popularity_score', 'price_eur']]
correlation_matrix_d = dishes_analysis.corr()

plt.figure(figsize=(6,4))
sns.heatmap(correlation_matrix_d, annot = True, cmap="seismic", vmax=1, vmin=-1)
plt.title("Dish features correlation matrix")
plt.tight_layout()
plt.show()

#Merging table Cities with City Market Metrics to showcase further correlation within atributes

merged_df = pd.merge(cities, city_market_metrics, on='city_id', how='left')
#print(merged_df.columns)
useful_features = merged_df[['population', 'avg_order_value_eur', 'inflation_rate_percent', 'unemployment_rate_percent']]
correlation_matrix_merged = useful_features.corr()
plt.figure(figsize=(6,4))
sns.heatmap(correlation_matrix_merged, annot = True, cmap="seismic", vmax=1, vmin=-1)
plt.title("Merged cities and city market metrics correlation")
plt.tight_layout()
plt.show()

#Scatterplot regarding population and unemployment rate

plt.figure(figsize=(9,6))
sns.scatterplot(data = merged_df, x='population', y='unemployment_rate_percent')
plt.title('Population vs Unemployment Rate')
plt.xlabel('Population')
plt.ylabel('Unemployment Rate (%)')
plt.show()

#Scatter plot regarding dish prices and popularity

plt.figure(figsize=(9,6))
sns.scatterplot(data = dishes, x='price_eur', y='popularity_score')
plt.title('Popularity and prices')
plt.xlabel('Popularity')
plt.ylabel('Prices in eur')
plt.show()