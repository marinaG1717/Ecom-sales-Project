-- Databricks notebook source
-- MAGIC %md
-- MAGIC **Step 1:** Calculate the First Purchase Date

-- COMMAND ----------

USE CATALOG workspace;
USE bigquery_db_cohort_db;
   SELECT
        customer_id,
        MIN(order_date) AS first_order_date
    FROM ecom_orders
    GROUP BY customer_id;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Step 2:** Calculate the Second Purchase Date
-- MAGIC
-- MAGIC For each customer, find the earliest order_date that is after their first purchase date

-- COMMAND ----------

USE CATALOG workspace;
USE bigquery_db_cohort_db;
WITH first_orders AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date
    FROM ecom_orders
    GROUP BY customer_id
)

SELECT
    eo.customer_id,
    MIN(eo.order_date) AS second_order_date
FROM ecom_orders eo
JOIN first_orders fo ON eo.customer_id = fo.customer_id
WHERE eo.order_date > fo.first_order_date
GROUP BY eo.customer_id;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Step 3:** Combine the Results and Calculate the Days Between Purchases
-- MAGIC
-- MAGIC
-- MAGIC Join the two queries to produce a final result that includes the customer’s first purchase date, second purchase date, and the number of days between these dates.

-- COMMAND ----------

USE CATALOG workspace;
USE bigquery_db_cohort_db;

WITH first_orders AS (
    -- Step 1: Get the first purchase date for each customer
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date
    FROM ecom_orders
    GROUP BY customer_id
),

second_orders AS (
    -- Step 2: Get the earliest purchase after the first one
    SELECT
        eo.customer_id,
        MIN(eo.order_date) AS second_order_date
    FROM ecom_orders eo
    JOIN first_orders fo
      ON eo.customer_id = fo.customer_id
    WHERE eo.order_date > fo.first_order_date
    GROUP BY eo.customer_id
)

-- Step 3: Combine both and calculate days between purchases
SELECT
    fo.customer_id,
    fo.first_order_date,
    so.second_order_date,
    
    -- Calculate number of days between purchases (can be NULL)
    CASE
        WHEN so.second_order_date IS NOT NULL THEN
            DATEDIFF(so.second_order_date, fo.first_order_date)
        ELSE NULL
    END AS days_between

FROM first_orders fo
LEFT JOIN second_orders so
  ON fo.customer_id = so.customer_id;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Step 4:** Save the Final Result as a New Table
-- MAGIC
-- MAGIC
-- MAGIC Create a new table (for example, cohort_analysis) in your Databricks database using the query result from Step 3.

-- COMMAND ----------

USE CATALOG workspace;
USE bigquery_db_cohort_db;

CREATE OR REPLACE TABLE cohort_analysis AS
WITH first_orders AS (
    -- Get the first purchase date per customer
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date
    FROM ecom_orders
    GROUP BY customer_id
),
second_orders AS (
    -- Get the second purchase date (after first)
    SELECT
        eo.customer_id,
        MIN(eo.order_date) AS second_order_date
    FROM ecom_orders eo
    JOIN first_orders fo
      ON eo.customer_id = fo.customer_id
    WHERE eo.order_date > fo.first_order_date
    GROUP BY eo.customer_id
)
-- Combine and calculate the days between purchases
SELECT
    fo.customer_id,
    fo.first_order_date,
    so.second_order_date,
    DATEDIFF(so.second_order_date, fo.first_order_date) AS days_between
FROM first_orders fo
LEFT JOIN second_orders so
  ON fo.customer_id = so.customer_id;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Verify Transformation:**

-- COMMAND ----------

USE CATALOG workspace;
USE bigquery_db_cohort_db;

SELECT * FROM cohort_analysis LIMIT 10;