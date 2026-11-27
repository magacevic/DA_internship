import pandas as pd
import numpy as np
import seaborn as sns
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt

restaurants = pd.read_csv("../csv_files/restaurants.csv")
cities = pd.read_csv("../csv_files/cities.csv")
merged = pd.merge(restaurants, cities, on='city_id', how='inner')
#print(merged)

numeric_attributes = ['total_orders_count', 'average_rating', 'number_of_dishes', 'population']
#print(merged[numeric_attributes])
merged['population'] = np.log1p(merged['population']) #because of a large gap between smallest and biggest city

from sklearn.preprocessing import StandardScaler

X = merged[numeric_attributes]

scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

from sklearn.metrics import silhouette_samples, silhouette_score

ks = range(2,11)
inits = ['random', 'k-means++']
results = []

for k in ks:
    for init in inits:

        kmeans = KMeans(n_clusters=k, init=init, n_init=10, random_state=42)

        labels = kmeans.fit_predict(X_scaled)

        results.append({'k':k, 'init':init, 'inertia':kmeans.inertia_, 'silhouette': silhouette_score(X_scaled, labels)})

results = pd.DataFrame(results)

print(results.sort_values(by='silhouette', ascending=False))

#visualizing 6 clusters

kmeans = KMeans(n_clusters=6, init='k-means++', n_init=10, random_state=42)
merged['cluster'] = kmeans.fit_predict(X_scaled)

plt.figure(figsize=(10, 7))

for label in range(6):
    cluster = merged[merged['cluster'] == label]

    plt.scatter(cluster['average_rating'],cluster['total_orders_count'],label=f'Cluster {label}',alpha=0.7)

centroids = pd.DataFrame(scaler.inverse_transform(kmeans.cluster_centers_),columns=numeric_attributes)

plt.scatter(centroids['average_rating'],centroids['total_orders_count'],color='black',marker='X',s=150,label='Centroids')

plt.title('K-means clustering of restaurants (k=6)')
plt.xlabel('Average rating')
plt.ylabel('Total orders count')
plt.legend()
plt.grid(alpha=0.7)
plt.show()