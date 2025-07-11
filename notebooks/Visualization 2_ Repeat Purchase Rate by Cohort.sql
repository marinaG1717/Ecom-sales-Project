-- Databricks notebook source
USE CATALOG workspace;
USE bigquery_db_cohort_db;

 -- Step 1: Get first purchase date and total number of orders per customer
WITH customer_orders AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date,
        COUNT(order_id) AS total_orders
    FROM ecom_orders
    GROUP BY customer_id
),

-- Step 2: Assign customers to monthly cohorts
cohorts AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', first_purchase_date) AS cohort_month,
        total_orders
    FROM customer_orders
)

-- Step 3: Aggregate repeat purchase metrics
SELECT
    cohort_month,
    COUNT(*) AS total_customers,

    -- At least 2 orders
    COUNT(CASE WHEN total_orders >= 2 THEN 1 END) AS repeat_2_orders,
    ROUND(100.0 * COUNT(CASE WHEN total_orders >= 2 THEN 1 END) / COUNT(*), 1) AS repeat_2_rate,

    -- At least 3 orders
    COUNT(CASE WHEN total_orders >= 3 THEN 1 END) AS repeat_3_orders,
    ROUND(100.0 * COUNT(CASE WHEN total_orders >= 3 THEN 1 END) / COUNT(*), 1) AS repeat_3_rate,

    -- At least 4 orders
    COUNT(CASE WHEN total_orders >= 4 THEN 1 END) AS repeat_4_orders,
    ROUND(100.0 * COUNT(CASE WHEN total_orders >= 4 THEN 1 END) / COUNT(*), 1) AS repeat_4_rate

FROM cohorts
GROUP BY cohort_month
ORDER BY cohort_month;


-- COMMAND ----------

-- MAGIC %md
-- MAGIC 📈 **Observed Trends
-- MAGIC ✅ 2nd Order Rate:**
-- MAGIC
-- MAGIC
-- MAGIC Very high across all cohorts (96%–100%)
-- MAGIC
-- MAGIC
-- MAGIC Indicates excellent short-term retention (almost everyone makes a second purchase)
-- MAGIC
-- MAGIC
-- MAGIC 📉 3rd Order Rate:
-- MAGIC Still strong (70%–98.5%), but gradually declines from Jan to Jun
-- MAGIC
-- MAGIC
-- MAGIC Sign of slight customer drop-off after 2nd order
-- MAGIC
-- MAGIC
-- MAGIC 📉 4th Order Rate:
-- MAGIC Clear downward trend from 83.3% (Jan) to 60% (Jun)
-- MAGIC
-- MAGIC
-- MAGIC Suggests long-term retention decreases for newer cohorts
-- MAGIC
-- MAGIC
-- MAGIC
-- MAGIC **📌 Interpretation**
-- MAGIC
-- MAGIC
-- MAGIC Older cohorts (Jan–Mar) had better long-term engagement, with more customers making 3rd and 4th purchases.
-- MAGIC
-- MAGIC
-- MAGIC Newer cohorts (Apr–Jun) show weaker follow-up behavior, especially for 3rd/4th orders.
-- MAGIC
-- MAGIC
-- MAGIC This might reflect:
-- MAGIC
-- MAGIC
-- MAGIC Less time to make more purchases
-- MAGIC
-- MAGIC
-- MAGIC Seasonality
-- MAGIC
-- MAGIC
-- MAGIC Changes in product, marketing, or customer behavior
-- MAGIC