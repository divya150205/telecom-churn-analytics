-- ================================================================
-- TELECOM CUSTOMER CHURN ANALYTICS
-- SQL Queries for Business Analysis
-- Database: telco_churn.db | Table: telco_churn
-- ================================================================


-- ----------------------------------------------------------------
-- Q1: Overall Churn Rate
-- ----------------------------------------------------------------
SELECT
    COUNT(*)                                                        AS total_customers,
    SUM("Churn Value")                                             AS churned_customers,
    ROUND(100.0 * SUM("Churn Value") / COUNT(*), 2)               AS churn_rate_pct,
    COUNT(*) - SUM("Churn Value")                                  AS retained_customers
FROM telco_churn;


-- ----------------------------------------------------------------
-- Q2: Monthly Revenue Analysis
-- ----------------------------------------------------------------
SELECT
    ROUND(SUM("Monthly Charges"), 2)                               AS total_monthly_revenue,
    ROUND(SUM(CASE WHEN "Churn Label" = 'No'
              THEN "Monthly Charges" ELSE 0 END), 2)               AS retained_revenue,
    ROUND(SUM(CASE WHEN "Churn Label" = 'Yes'
              THEN "Monthly Charges" ELSE 0 END), 2)               AS revenue_lost_to_churn,
    ROUND(100.0 * SUM(CASE WHEN "Churn Label" = 'Yes'
              THEN "Monthly Charges" ELSE 0 END)
              / SUM("Monthly Charges"), 2)                         AS pct_revenue_at_risk
FROM telco_churn;


-- ----------------------------------------------------------------
-- Q3: Churn Rate by Contract Type
-- ----------------------------------------------------------------
SELECT
    Contract,
    COUNT(*)                                                        AS total_customers,
    SUM("Churn Value")                                             AS churned,
    ROUND(100.0 * SUM("Churn Value") / COUNT(*), 2)               AS churn_rate_pct,
    ROUND(AVG("Monthly Charges"), 2)                               AS avg_monthly_charges,
    ROUND(SUM(CASE WHEN "Churn Label" = 'Yes'
              THEN "Monthly Charges" ELSE 0 END), 2)               AS revenue_at_risk
FROM telco_churn
GROUP BY Contract
ORDER BY churn_rate_pct DESC;


-- ----------------------------------------------------------------
-- Q4: Churn Rate by Tenure Band
-- ----------------------------------------------------------------
SELECT
    "Tenure Band",
    COUNT(*)                                                        AS total_customers,
    SUM("Churn Value")                                             AS churned,
    ROUND(100.0 * SUM("Churn Value") / COUNT(*), 2)               AS churn_rate_pct,
    ROUND(AVG("Monthly Charges"), 2)                               AS avg_monthly_charges
FROM telco_churn
GROUP BY "Tenure Band"
ORDER BY churn_rate_pct DESC;


-- ----------------------------------------------------------------
-- Q5: Churn Rate by Payment Method
-- ----------------------------------------------------------------
SELECT
    "Payment Method",
    COUNT(*)                                                        AS total_customers,
    SUM("Churn Value")                                             AS churned,
    ROUND(100.0 * SUM("Churn Value") / COUNT(*), 2)               AS churn_rate_pct,
    ROUND(SUM(CASE WHEN "Churn Label" = 'Yes'
              THEN "Monthly Charges" ELSE 0 END), 2)               AS revenue_at_risk
FROM telco_churn
GROUP BY "Payment Method"
ORDER BY churn_rate_pct DESC;


-- ----------------------------------------------------------------
-- Q6: Churn by Demographic Segments
-- ----------------------------------------------------------------
SELECT
    "Senior Citizen",
    Partner,
    Dependents,
    COUNT(*)                                                        AS total_customers,
    SUM("Churn Value")                                             AS churned,
    ROUND(100.0 * SUM("Churn Value") / COUNT(*), 2)               AS churn_rate_pct
FROM telco_churn
GROUP BY "Senior Citizen", Partner, Dependents
HAVING COUNT(*) > 50
ORDER BY churn_rate_pct DESC
LIMIT 10;


-- ----------------------------------------------------------------
-- Q7: Revenue at Risk — High Risk Customers (Still Active)
-- ----------------------------------------------------------------
SELECT
    CustomerID,
    "Tenure Months",
    Contract,
    "Monthly Charges",
    "Total Charges",
    "Internet Service",
    "Payment Method",
    "Churn Score",
    CLTV,
    'High Risk' AS risk_label
FROM telco_churn
WHERE
    "Churn Label" = 'No'
    AND Contract = 'Month-to-month'
    AND "Tenure Months" <= 12
    AND "Monthly Charges" >= 65
    AND "Internet Service" = 'Fiber optic'
ORDER BY "Monthly Charges" DESC
LIMIT 20;


-- ----------------------------------------------------------------
-- Q8: Top Churn Reasons
-- ----------------------------------------------------------------
SELECT
    "Churn Reason",
    COUNT(*)                                                        AS frequency,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2)             AS pct_of_churned,
    ROUND(AVG("Monthly Charges"), 2)                               AS avg_monthly_charges
FROM telco_churn
WHERE "Churn Label" = 'Yes'
    AND "Churn Reason" IS NOT NULL
    AND "Churn Reason" != ''
GROUP BY "Churn Reason"
ORDER BY frequency DESC
LIMIT 10;


-- ----------------------------------------------------------------
-- Q9: Customer Lifetime Value by Segment
-- ----------------------------------------------------------------
SELECT
    Contract,
    "Internet Service",
    "Revenue Segment",
    COUNT(*)                                                        AS total_customers,
    ROUND(AVG(CLTV), 2)                                            AS avg_cltv,
    ROUND(AVG("Monthly Charges"), 2)                               AS avg_monthly_charges,
    ROUND(100.0 * SUM("Churn Value") / COUNT(*), 2)               AS churn_rate_pct
FROM telco_churn
GROUP BY Contract, "Internet Service", "Revenue Segment"
HAVING COUNT(*) > 30
ORDER BY avg_cltv DESC
LIMIT 15;


-- ----------------------------------------------------------------
-- Q10: Churn Rate by Internet Service
-- ----------------------------------------------------------------
SELECT
    "Internet Service",
    COUNT(*)                                                        AS total_customers,
    SUM("Churn Value")                                             AS churned,
    ROUND(100.0 * SUM("Churn Value") / COUNT(*), 2)               AS churn_rate_pct,
    ROUND(AVG("Monthly Charges"), 2)                               AS avg_monthly_charges,
    ROUND(SUM(CASE WHEN "Churn Label" = 'Yes'
              THEN "Monthly Charges" ELSE 0 END), 2)               AS revenue_at_risk
FROM telco_churn
GROUP BY "Internet Service"
ORDER BY churn_rate_pct DESC;