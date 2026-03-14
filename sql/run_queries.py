import sqlite3
import pandas as pd

# Connect to database
conn = sqlite3.connect('C:/Users/Lenevo/telecom-churn-analytics/telecom-churn-analytics/sql/telco_churn.db')

# ── Q1: Overall Churn Rate
print("=" * 55)
print("Q1: OVERALL CHURN RATE")
print("=" * 55)
q1 = pd.read_sql_query('''
    SELECT
        COUNT(*) AS total_customers,
        SUM("Churn Value") AS churned_customers,
        ROUND(100.0 * SUM("Churn Value") / COUNT(*), 2) AS churn_rate_pct,
        COUNT(*) - SUM("Churn Value") AS retained_customers
    FROM telco_churn
''', conn)
print(q1.to_string(index=False))

# ── Q2: Revenue Analysis
print("\n" + "=" * 55)
print("Q2: MONTHLY REVENUE ANALYSIS")
print("=" * 55)
q2 = pd.read_sql_query('''
    SELECT
        ROUND(SUM("Monthly Charges"), 2) AS total_monthly_revenue,
        ROUND(SUM(CASE WHEN "Churn Label" = 'No'
                  THEN "Monthly Charges" ELSE 0 END), 2) AS retained_revenue,
        ROUND(SUM(CASE WHEN "Churn Label" = 'Yes'
                  THEN "Monthly Charges" ELSE 0 END), 2) AS revenue_lost_to_churn,
        ROUND(100.0 * SUM(CASE WHEN "Churn Label" = 'Yes'
                  THEN "Monthly Charges" ELSE 0 END)
                  / SUM("Monthly Charges"), 2) AS pct_revenue_at_risk
    FROM telco_churn
''', conn)
print(q2.to_string(index=False))

# ── Q3: Churn by Contract
print("\n" + "=" * 55)
print("Q3: CHURN BY CONTRACT TYPE")
print("=" * 55)
q3 = pd.read_sql_query('''
    SELECT Contract, COUNT(*) AS total_customers,
        SUM("Churn Value") AS churned,
        ROUND(100.0 * SUM("Churn Value") / COUNT(*), 2) AS churn_rate_pct,
        ROUND(AVG("Monthly Charges"), 2) AS avg_monthly_charges,
        ROUND(SUM(CASE WHEN "Churn Label" = 'Yes'
                  THEN "Monthly Charges" ELSE 0 END), 2) AS revenue_at_risk
    FROM telco_churn
    GROUP BY Contract
    ORDER BY churn_rate_pct DESC
''', conn)
print(q3.to_string(index=False))

# ── Q4: Churn by Tenure Band
print("\n" + "=" * 55)
print("Q4: CHURN BY TENURE BAND")
print("=" * 55)
q4 = pd.read_sql_query('''
    SELECT "Tenure Band", COUNT(*) AS total_customers,
        SUM("Churn Value") AS churned,
        ROUND(100.0 * SUM("Churn Value") / COUNT(*), 2) AS churn_rate_pct,
        ROUND(AVG("Monthly Charges"), 2) AS avg_monthly_charges
    FROM telco_churn
    GROUP BY "Tenure Band"
    ORDER BY churn_rate_pct DESC
''', conn)
print(q4.to_string(index=False))

# ── Q5: Churn by Payment Method
print("\n" + "=" * 55)
print("Q5: CHURN BY PAYMENT METHOD")
print("=" * 55)
q5 = pd.read_sql_query('''
    SELECT "Payment Method", COUNT(*) AS total_customers,
        SUM("Churn Value") AS churned,
        ROUND(100.0 * SUM("Churn Value") / COUNT(*), 2) AS churn_rate_pct,
        ROUND(SUM(CASE WHEN "Churn Label" = 'Yes'
                  THEN "Monthly Charges" ELSE 0 END), 2) AS revenue_at_risk
    FROM telco_churn
    GROUP BY "Payment Method"
    ORDER BY churn_rate_pct DESC
''', conn)
print(q5.to_string(index=False))

# ── Q8: Top Churn Reasons
print("\n" + "=" * 55)
print("Q8: TOP CHURN REASONS")
print("=" * 55)
q8 = pd.read_sql_query('''
    SELECT "Churn Reason", COUNT(*) AS frequency,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_of_churned,
        ROUND(AVG("Monthly Charges"), 2) AS avg_monthly_charges
    FROM telco_churn
    WHERE "Churn Label" = 'Yes'
        AND "Churn Reason" IS NOT NULL
        AND "Churn Reason" != ''
    GROUP BY "Churn Reason"
    ORDER BY frequency DESC
    LIMIT 10
''', conn)
print(q8.to_string(index=False))

conn.close()
print("\n" + "=" * 55)
print("All queries executed successfully!")
print("=" * 55)