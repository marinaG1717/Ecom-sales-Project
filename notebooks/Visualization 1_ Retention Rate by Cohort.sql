-- Databricks notebook source
USE CATALOG workspace;
USE bigquery_db_cohort_db;
-- Step 1.1: Get first purchase per customer
WITH first_order AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_date
    FROM ecom_orders
    GROUP BY customer_id
),

-- Step 1.2: Get second purchase (if any)
second_order AS (
    SELECT
        eo.customer_id,
        MIN(eo.order_date) AS second_date
    FROM ecom_orders eo
    JOIN first_order fo ON eo.customer_id = fo.customer_id
    WHERE eo.order_date > fo.first_date
    GROUP BY eo.customer_id
),

-- Step 1.3: Combine both and calculate difference in months as integer
cohorts AS (
    SELECT
        fo.customer_id,
        DATE_TRUNC('month', fo.first_date) AS cohort_month,
        FLOOR(DATEDIFF(so.second_date, fo.first_date) / 30) AS month_diff
    FROM first_order fo
    LEFT JOIN second_order so ON fo.customer_id = so.customer_id
)

-- Step 1.4: Aggregate retention by cohort month
SELECT
    cohort_month,
    COUNT(*) AS total_customers,

    -- Customers with second purchase within 1 month (month_diff = 0)
    COUNT(CASE WHEN month_diff = 0 THEN 1 END) AS retained_1m,

    -- within 2 months (month_diff <= 1)
    COUNT(CASE WHEN month_diff <= 1 THEN 1 END) AS retained_2m,

    -- within 3 months (month_diff <= 2)
    COUNT(CASE WHEN month_diff <= 2 THEN 1 END) AS retained_3m

FROM cohorts
GROUP BY cohort_month
ORDER BY cohort_month;


-- COMMAND ----------

-- MAGIC %md
-- MAGIC **1. Which cohort shows the highest retention rate for each time threshold?**
-- MAGIC
-- MAGIC
-- MAGIC **1 Month:
-- MAGIC **
-- MAGIC
-- MAGIC Highest retention is May 2024 cohort with 50.0%
-- MAGIC
-- MAGIC
-- MAGIC **2 Months:**
-- MAGIC
-- MAGIC
-- MAGIC Highest retention is June 2024 cohort with 100.0%
-- MAGIC  (Note: June cohort size is only 10 customers, so small sample)
-- MAGIC
-- MAGIC
-- MAGIC **3 Months:**
-- MAGIC
-- MAGIC
-- MAGIC Highest retention is May and June 2024 cohorts with 100.0%
-- MAGIC
-- MAGIC
-- MAGIC
-- MAGIC **2. Are there notable differences in short-term retention across cohorts?**
-- MAGIC
-- MAGIC
-- MAGIC Yes, 1-month retention varies significantly from around 30% (March, June) to 50% (May).
-- MAGIC
-- MAGIC
-- MAGIC Earlier cohorts (Jan, Feb, Mar) have lower 1-month retention (~30-38%) compared to later cohorts (Apr, May) with 48-50%.
-- MAGIC
-- MAGIC
-- MAGIC At 2 and 3 months, retention rates generally increase for later cohorts, even reaching 100%, but note the sample size for the latest cohorts is small (10–16 customers).
-- MAGIC
-- MAGIC
-- MAGIC This suggests improvement in retention for newer cohorts, especially after 1 month, but caution due to smaller cohort sizes.
-- MAGIC
-- MAGIC
-- MAGIC