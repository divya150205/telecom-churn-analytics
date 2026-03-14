import sqlite3
import pandas as pd

# Load cleaned dataset
df = pd.read_csv('C:/Users/Lenevo/telecom-churn-analytics/telecom-churn-analytics/data/processed/telco_churn_clean.csv')

# Create SQLite database
conn = sqlite3.connect('C:/Users/Lenevo/telecom-churn-analytics/telecom-churn-analytics/sql/telco_churn.db')

# Write dataframe to SQL table
df.to_sql('telco_churn', conn, if_exists='replace', index=False)

print("Database created successfully!")
print(f"Table: telco_churn")
print(f"Rows inserted: {len(df)}")

conn.close()