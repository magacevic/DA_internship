import pandas as pd

gradovi = pd.read_csv(r"C:\Users\masa.gacevic\Desktop\DA_intern\cities.csv")

print(gradovi)
print(gradovi.isna().sum())

#mergovanje tabela, inner i left
df1 = pd.read_csv(r"C:\Users\masa.gacevic\Desktop\DA_intern\cities.csv")
df2 = pd.read_csv(r"C:\Users\masa.gacevic\Desktop\DA_intern\city_market_metrics.csv")

merged_df = pd.merge(df1, df2, on='city_id', how='inner')
print(merged_df.head())
print(merged_df.isna().sum())

left_merged_df = pd.merge(df1, df2, on='city_id', how='left')
print(left_merged_df)

#soritranje vrijednosti po populaciji
gradovi_sort = gradovi.sort_values(by='population', ascending=True)
print(gradovi_sort)

print(gradovi.isnull().sum())

#uklanjanje duplikata i NA vrijednosti
gradovi_marketi = pd.read_csv(r"C:\Users\masa.gacevic\Desktop\DA_intern\city_market_metrics.csv")
print(gradovi_marketi.shape)
print(gradovi_marketi.duplicated().sum())
print(gradovi_marketi.isna().sum())
gradovi_marketi_bezNa = gradovi_marketi.dropna()
print(gradovi_marketi_bezNa.shape)


#deskriptivna statistika i tipovi podataka
print(gradovi.describe())
print(gradovi.dtypes)

#matplotlib biblioteka za vizualizaciju podataka
import matplotlib.pyplot as plt
#scatter plot
plt.scatter(gradovi['city_name'], gradovi['population'])
plt.xlabel('City Name')
plt.ylabel('Population')
plt.title('City Populations')
plt.xticks(rotation=45)
plt.show()

#bar chart
plt.bar(gradovi['city_name'], gradovi['population'])
plt.xlabel('City Name') 
plt.ylabel('Population')
plt.title('City Populations')
plt.xticks(rotation=45)
plt.show()

import seaborn as sns
matrica_korelacije = gradovi.corr(numeric_only=True)
print(matrica_korelacije)
