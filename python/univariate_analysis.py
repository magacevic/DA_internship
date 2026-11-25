import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
import seaborn as sns

cities = pd.read_csv(r"C:\Users\masa.gacevic\Desktop\druga_sedmica\files\cities.csv")
people = pd.read_csv(r"C:\Users\masa.gacevic\Desktop\druga_sedmica\files\people.csv")
restaurants = pd.read_csv(r"C:\Users\masa.gacevic\Desktop\druga_sedmica\files\restaurants.csv")
orders = pd.read_csv(r"C:\Users\masa.gacevic\Desktop\druga_sedmica\files\orders_with_nulls.csv")
dishes = pd.read_csv(r"C:\Users\masa.gacevic\Desktop\druga_sedmica\files\dishes.csv")
order_items = pd.read_csv(r"C:\Users\masa.gacevic\Desktop\druga_sedmica\files\order_items.csv")
city_market_metrics = pd.read_csv(r"C:\Users\masa.gacevic\Desktop\druga_sedmica\files\city_market_metrics_with_nulls.csv")

#Value counts for spicy meals
dishes['is_spicy'].value_counts().plot(kind = "bar")
plt.title("Distribution of spicy dishes")
plt.xlabel("Is spicy")
plt.ylabel("Number of dishes")
plt.show()

#box plot in order to analyse dish price 
plt.figure(figsize=(6,4))
sns.boxplot(data = dishes, x = 'price_eur')
plt.title('Distribution of dish prices')
plt.xlabel('Dish Price in eurs')
plt.show()

#box plot fr order amount in eur
plt.figure(figsize=(6,4))
sns.boxplot(data = orders, x = 'order_amount_eur')
plt.title('Distribution of order amounts in eur')
plt.xlabel('Price in eurs')
plt.show()


def IQR(data, features):
    iqr_results = pd.DataFrame(0.0, dtype = 'float64', index = features, columns = ['min', 'lower', 'num_below_lower', 'max', 'upper', 'num_above_upper'])
    for name in features:
        (Q1, Q3) = data[name].quantile([0.25, 0.75])
        IQR = Q3 - Q1
        
        upper = Q3 + (1.5 * IQR)                             
        lower = Q1 - (1.5 * IQR)                                   
        iqr_results.loc[name, 'upper'] = upper
        iqr_results.loc[name, 'lower'] = lower

        num_below_lower = (data[name] < lower).sum()            
        num_above_upper = (data[name] > upper).sum()            
        iqr_results.loc[name, 'num_below_lower'] = num_below_lower
        iqr_results.loc[name, 'num_above_upper'] = num_above_upper
    
        
        iqr_results.loc[name, 'min'], iqr_results.loc[name, 'max'] = data[name].min(), data[name].max()  
        
    return iqr_results

outliers_order_prices = IQR(orders, ['order_amount_eur', 'delivery_time_minutes'])
print(pd.DataFrame(outliers_order_prices))

outliers_dish_prices = IQR(dishes, ['price_eur', 'popularity_score'])
print(pd.DataFrame(outliers_dish_prices))

outliers_restaurants = IQR(restaurants, ['total_orders_count', 'number_of_dishes'])
print(pd.DataFrame(outliers_restaurants))

#Numeric informations regarding orders

#people_numeric = people.select_dtypes(include='number')
#print(people_numeric.describe())

orders_numeric = orders.select_dtypes(include='number')
print(orders_numeric.describe())

#Histogram regarding prices of items

plt.figure(figsize=(8,6))
plt.hist(order_items['price_per_item_eur'], bins = 25)
plt.title("Histogram regarding order item prices")
plt.xlabel('Price in eur')
plt.ylabel('Frequency')
plt.show()