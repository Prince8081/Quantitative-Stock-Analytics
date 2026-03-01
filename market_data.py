
import pandas as pd 

df = pd.read_csv('market_data.csv')

print(df.info())

print(df.isnull().sum())

print(df.duplicated().sum())


df['Date'] = pd.to_datetime(df['Date'])

df = df.dropna()

df['Close_Price'] = df['Close_Price'].round(2)

df['50_DMA'] = df['50_DMA'].round(2)

df['RSI'] = df['RSI'].round(2)

df['Volume'] = df['Volume'].astype(int)

print(df.head())

df.to_csv('cleaned_data.csv', index=False)
