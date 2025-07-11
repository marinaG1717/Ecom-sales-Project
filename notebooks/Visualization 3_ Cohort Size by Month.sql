-- Databricks notebook source
USE CATALOG workspace;
USE bigquery_db_cohort_db;

-- Step 1: Get first purchase date per customer
WITH first_orders AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM ecom_orders
    GROUP BY customer_id
)

-- Step 2: Group by cohort month and count new customers
SELECT
    DATE_TRUNC('month', first_purchase_date) AS cohort_month,
    COUNT(*) AS new_customers
FROM first_orders
GROUP BY cohort_month
ORDER BY cohort_month;


-- COMMAND ----------

-- MAGIC %md
-- MAGIC **How does the cohort size vary over time?**
-- MAGIC
-- MAGIC
-- MAGIC The cohort size decreases steadily from January to June 2024.
-- MAGIC
-- MAGIC
-- MAGIC After January’s peak (66 customers), each subsequent month shows a smaller number of new customers:
-- MAGIC
-- MAGIC
-- MAGIC February: 48 (down by ~27%)
-- MAGIC
-- MAGIC
-- MAGIC March: 33 (down by ~31%)
-- MAGIC
-- MAGIC
-- MAGIC April: 27 (down by ~18%)
-- MAGIC
-- MAGIC
-- MAGIC May: 16 (down by ~41%)
-- MAGIC
-- MAGIC
-- MAGIC June: 10 (down by ~38%)
-- MAGIC
-- MAGIC
-- MAGIC This trend suggests that new customer acquisition slowed down over these months.
-- MAGIC
-- MAGIC
-- MAGIC