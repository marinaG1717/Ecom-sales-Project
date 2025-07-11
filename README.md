# 📊 Ecom-Sales Project

### 🧩 Customer Retention & Cohort Analysis with the Modern Data Stack

**Project Title**: Building a Modern Marketing Analytics Solution for Customer Retention  
**Date**: July 2025  
**Tools Used**: Fivetran · GCP Cloud SQL · Databricks (Delta Lake, SQL, Dashboards)

---

## 1. 🎯 Project Objective

The goal of this project was to build an **end-to-end data analytics solution** to analyze and improve **customer retention** in an e-commerce business.

We focused on **cohort analysis** to explore:

- ⏱️ How long it takes customers to make a second purchase  
- 🔁 How repeat purchase rates evolve over time  
- 📅 How retention differs across monthly cohorts  
- 📉 How new customer acquisition trends changed over the past 6 months  

---

## 2. 🛠️ Data Pipeline & Architecture

We used the **modern data stack** to ingest, transform, and visualize data.

### ✅ Data Source
- **GCP Cloud SQL** with e-commerce sales data

### 🚀 Ingestion
- **Fivetran** automatically replicated tables and schema into **Databricks Delta Lake**

### 🔄 Transformation
- SQL (CTEs, subqueries) in **Databricks Notebooks** to:
  - Identify each customer's **first** and **second purchase date**
  - Assign customers to **monthly cohorts**

### 📊 Visualization
- **Databricks Dashboards** to display:
  - Retention trends
  - Repeat purchase rates
  - Cohort sizes over time

---

## 3. 📈 Key Visualizations & Insights

### 3.1 🔁 Retention Rate by Cohort (Time to Second Purchase)

| ⏱ Timeframe | 📌 Highest Retention | 💡 Details |
|-------------|----------------------|------------|
| 1 Month     | **May 2024 (50%)**   | Strong short-term retention |
| 2 Months    | **June 2024 (100%)** | Small sample (10 users) |
| 3 Months    | **May & June 2024 (100%)** | Suggests improved engagement |

**Trend**:
- Older cohorts (Jan–Mar) had lower 1-month retention (**~30–38%**)  
- Later cohorts (Apr–May) improved to **48–50%**

---

### 3.2 🔄 Repeat Purchase Rate by Cohort

| Cohort     | 2nd Order (%) | 3rd Order (%) | 4th Order (%) |
|------------|---------------|----------------|----------------|
| Jan 2024   | 100.0         | 98.5           | 83.3           |
| Feb 2024   | 97.9          | 95.8           | 81.3           |
| Mar 2024   | 100.0         | 93.9           | 81.8           |
| Apr 2024   | 96.3          | 85.2           | 77.8           |
| May 2024   | 100.0         | 93.8           | 68.8           |
| Jun 2024   | 100.0         | 70.0           | 60.0           |

**Insights**:
- ✅ 2nd purchase rate is consistently high (**96–100%**)
- 📉 Drop-off begins at 3rd and 4th purchases, more visible in newer cohorts
- 📆 Older cohorts show stronger long-term engagement

**Interpretation**:
- Newer users may not have had time for multiple purchases yet  
- Possible seasonal, product, or campaign changes

---

### 3.3 📉 Cohort Size by Month

| Month      | 🧍 Customers |
|------------|-------------|
| Jan 2024   | 66          |
| Feb 2024   | 48          |
| Mar 2024   | 33          |
| Apr 2024   | 27          |
| May 2024   | 16          |
| Jun 2024   | 10          |

**Trend**:
- Clear decline in new customer acquisition  
- June’s cohort is **~85% smaller** than January’s

---

## 4. 📌 Key Insights Summary

- 📈 **Short-term retention** is improving for newer cohorts (up to 50%)
- 📉 **Long-term retention** (3rd/4th order) is decreasing
- 🔽 **Customer acquisition** has declined month-over-month
- 💡 **High 2nd purchase rates** suggest effective onboarding or first-purchase experience

---

## 5. 💡 Recommendations

- 🧪 Investigate why customers drop off after the 2nd/3rd purchase
- 🎯 Optimize acquisition strategies (ads, offers, landing pages)
- 📦 Improve post-purchase experiences (loyalty programs, follow-ups)
- 📅 Keep tracking new cohorts as they mature
- 🔁 Repeat this cohort analysis **quarterly**

---

## 6. ✅ Conclusion

This project demonstrates how **Fivetran + Databricks** can power a **scalable, automated cohort analysis workflow**. It enabled actionable insights for:

- Enhancing **retention and engagement**
- Tracking **cohort performance**
- Supporting **data-driven marketing strategies**

By continuously monitoring these metrics, the business can boost long-term customer value and optimize its growth strategy.

---

## 📎 Folder Structure  make new!!!!!

```bash
├── README.md
├── notebooks/
│   ├──  Create cohort_analysis table from ecom_orders.sql
│   ├── Visualization 1_ Retention Rate by Cohort.sql
│   ├── Visualization 2_ Repeat Purchase Rate by Cohort.sql
│   ├── Visualization 3_ Cohort Size by Month.sql
├── dashboards/
│   └── cohort_retention_dashboard.png
├── source/
│   └── ecom_orders.csv
