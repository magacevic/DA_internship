import numpy as np
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import GridSearchCV
from sklearn.linear_model import LinearRegression

orders = pd.read_csv("../files/orders.csv")
orders = orders[orders['delivery_fee_eur'].notna()]
print(orders.shape)
print(orders.isna().sum())
#print(orders)

orders_nothing_missing = orders[(orders['customer_rating'].notna())]
print(orders_nothing_missing.isna().sum())
print(orders_nothing_missing.shape)

from sklearn.model_selection import train_test_split

features = ['order_amount_eur', 'delivery_fee_eur', 'discount_eur', 'delivery_time_minutes']

#Correlation matrix, features and customer rating
correlation = orders_nothing_missing[features + ['customer_rating']].corr()

print(pd.DataFrame(correlation)) #dataframe explaining correlations with features
#print(correlation['customer_rating'].sort_values(ascending=False))

correlation.to_csv("../correlation_matrix.csv", index=False)

X = orders_nothing_missing[features]
y = orders_nothing_missing['customer_rating']

X_train, X_test, y_train, y_test = train_test_split(X, y, train_size=0.8, stratify=y, random_state=42)

scaler = StandardScaler()

X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

results = pd.DataFrame(
    columns=['Model', 'MAE', 'RMSE', 'R2']
)

from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

def evaluate_model(model_name, y_test, y_pred):
    mae = mean_absolute_error(y_test, y_pred) #lower values indicate better model performance
    rmse = np.sqrt(mean_squared_error(y_test, y_pred)) #lower values indicate better results 
    r2 = r2_score(y_test, y_pred) #values closer to 1 indicate better results

    return {
        'Model': model_name,
        'MAE': mae,
        'RMSE': rmse,
        'R2': r2
    }

#linearna regresija + not standardized 
model1 = LinearRegression()
model1.fit(X_train, y_train)
y_pred1 = model1.predict(X_test)

results.loc[len(results)] = evaluate_model('Linear Regression, not standardized', y_test, y_pred1)

#Linearna regresija + standardized 
model2 = LinearRegression()
model2.fit(X_train_scaled, y_train)
y_pred2 = model2.predict(X_test_scaled)

results.loc[len(results)] = evaluate_model('Linear Regression, standardized', y_test, y_pred2)

#Ridge

from sklearn.linear_model import Ridge
model3 = Ridge()

param_grid = {'alpha' : [0.01, 0.1, 1, 10, 100]}

model_possibilities = GridSearchCV(estimator=model3, param_grid=param_grid, cv=5, scoring='neg_mean_squared_error')
model_possibilities.fit(X_train_scaled, y_train)
best_model = model_possibilities.best_estimator_
best_params = model_possibilities.best_params_
print("Best params:", best_params)

y_pred3 = best_model.predict(X_test_scaled)

results.loc[len(results)] = evaluate_model('Ridge - optimized hyperparams',y_test,y_pred3)

print(results)
results.to_csv("DataFrameLinearRegression.csv", index=False)

orders_missing_ratings = orders[orders['customer_rating'].isna()]
print(orders_missing_ratings.isna().sum())
print(orders_missing_ratings.shape)
print(orders_missing_ratings)

X_missing_ratings = orders_missing_ratings[features]
#print(y)

model1.fit(X, y)
predicted_ratings = model1.predict(X_missing_ratings)
predicted_ratings = np.clip(predicted_ratings, 1, 5)

#print(orders)
orders.loc[orders_missing_ratings.index,'customer_rating'] = predicted_ratings

print(orders.isna().sum())

orders.to_csv("LR_orders.csv", index = False)
