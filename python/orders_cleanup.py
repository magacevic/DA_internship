import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

orders = pd.read_csv("../files/orders.csv")
print(orders.head())
print(orders.isna().sum())
print("----------------------")
orders = orders[orders['delivery_fee_eur'].notna()]
print(orders.isna().sum())
print("Popunjavanje nedostajucih vrijednosti unutar customer ratinga")
group_median = orders.groupby(
    ['discount_eur', 'order_amount_eur', 'delivery_time_minutes']
)['customer_rating'].transform('median')

orders['customer_rating'] = orders['customer_rating'].fillna(group_median)

orders['customer_rating'] = orders['customer_rating'].fillna(
    orders['customer_rating'].median()
)

print(orders)
print("----------------------")
print(orders.isna().sum())

orders.to_csv('orders_cleaned.csv', index=False)