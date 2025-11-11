#IMPORT-------
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sqlalchemy import create_engine

#DATA COLLECTION---------
#Read CSV file
df = pd.read_csv(r"C:\Users\GOKUL\Desktop\retail inventory\retail.csv", sep='\t',engine='python')

#DATA UNDERSTANDING----------
#info,describe & head
print("Data Info:")
df.info()
print("\nData Description:")
print(df.describe())
print(df.head())

#DATA CLEANING---------------
#null value
print(df.isnull().sum())
print(df[df.isnull().any(axis=1)])

#nan
total_nan = df.isnull().sum().sum()
print("Total missing values in dataset:", total_nan)

#clean & standardise column 
df.columns = df.columns.str.strip().str.lower()
print(df.columns)

#remove duplicates
df = df.drop_duplicates()

#DATA TRANSFORMATION------------
#convert numeric columns
numeric_cols = ['stock_in', 'stock_out', 'opening_stock', 'unit_price', 'reorder_level','discount_applied', 'review_rating', 'return_rate', 'purchase_frequency']
for col in numeric_cols:
    df[col] = pd.to_numeric(df[col], errors='coerce').fillna(0)

#calculate derived columns
df['closing_stock'] = df['opening_stock'] + df['stock_in'] - df['stock_out']
df['average_stock'] = (df['opening_stock'] + df['closing_stock']) / 2

#avoid division by zero
df['stock_turnover'] = df.apply(lambda row: row['stock_out']/row['average_stock'] 
                                if row['average_stock'] != 0 else 0, axis=1)

#Date conversion
df['date'] = pd.to_datetime(df['date'], dayfirst=True)  # Correct date parsing

#FILTERS = Electronics
electronics_items = df[df['category'] == 'Electronics']
print(electronics_items.head())

#closingstock < reorder level
low_stock = df[df['closing_stock'] < df['reorder_level']]
print(low_stock)

#turnover > average
fast_moving = df[df['stock_turnover'] > df['stock_turnover'].mean()]
print(fast_moving)

#DATA ANALYSIS-------------
#fast & slow-moving items
mean_turnover = df['stock_turnover'].mean()
fast_moving = df[df['stock_turnover'] > mean_turnover]
slow_moving = df[df['stock_turnover'] <= mean_turnover]

#monthly sales calculation
monthly_sales = df.groupby([df['date'].dt.to_period('M'), 'sku_id'])['stock_out'].sum().reset_index()
monthly_sales['date'] = monthly_sales['date'].dt.to_timestamp()

print("\nMonthly Sales Head:")
print(monthly_sales.head())


#DATA VISUALIZATION-------
#visualization & stock turnover distribution
plt.figure(figsize=(10,5))
sns.histplot(df['stock_turnover'], kde=True)
plt.title('Stock Turnover Distribution')
plt.xlabel('Stock Turnover')
plt.ylabel('Frequency')
plt.show()

#Fast vs slow-moving items by category
plt.figure(figsize=(10,5))
sns.countplot(x='category', hue=(df['stock_turnover'] > mean_turnover), data=df)
plt.title('Fast vs Slow Moving Items by Category')
plt.xlabel('Category')
plt.ylabel('Count')
plt.legend(title='Fast Moving')
plt.show()

#top 5 SKUs monthly trend
top_skus = df.groupby('sku_id')['stock_out'].sum().sort_values(ascending=False).head(5).index
monthly_top_skus = monthly_sales[monthly_sales['sku_id'].isin(top_skus)]
monthly_top_pivot = monthly_top_skus.pivot(index='date', columns='sku_id', values='stock_out')

plt.figure(figsize=(12,6))
monthly_top_pivot.plot(marker='o')
plt.title('Monthly Stock-Out Trend for Top 5 SKUs')
plt.ylabel('Stock Out')
plt.xlabel('Month')
plt.show()

#MySQL connection
username = "root"
password = "root"
host = "localhost"
port = "3306"
database = "retailproject"

engine = create_engine(f"mysql+pymysql://root:root@localhost:3306/retailproject")
table_name = "inventory"

#DATA EXPORT----------
df.to_sql(table_name, engine, if_exists='replace', index=False)
print("\nData successfully saved to MySQL table:",table_name)