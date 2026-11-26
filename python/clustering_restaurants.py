import pandas as pd
import numpy as np
import seaborn as sns
from sklearn.cluster import KMeans

restaurants = pd.read_csv("../csv_files/restaurants.csv")
print(restaurants)