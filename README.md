# 🍽️ Zomato Customer Churn & Business Performance Analysis

![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi&logoColor=black)
![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?logo=mysql&logoColor=white)
![DAX](https://img.shields.io/badge/DAX-Power%20BI-orange)
![Excel](https://img.shields.io/badge/Excel-Data%20Preparation-217346?logo=microsoftexcel&logoColor=white)
![Project Status](https://img.shields.io/badge/Status-Completed-brightgreen)

> **End-to-end Data Analyst case study using SQL, MySQL, Power BI and DAX to analyze customer retention, churn, revenue, restaurant performance and delivery operations.**

---

## 📌 Project Overview

This project analyzes a simulated Zomato-style food-delivery business from an end-to-end Data Analyst perspective.

The analysis combines **relational data validation, SQL business analysis, Power BI data modeling, DAX KPI development and interactive dashboarding** to answer practical business questions and turn the findings into recommendations.

### Business Problem

A food-delivery platform needs to understand:

- Where revenue is being generated.
- Which customers are active, at risk, churned or have never ordered.
- Which customers and membership tiers are most valuable.
- Which restaurants and cuisines drive revenue.
- Whether delivery distance affects on-time performance.
- How weather affects delivery time and complaints.
- Which cities and customer segments have higher churn.

### Project Objectives

1. Validate the relational dataset and identify data-quality issues.
2. Use SQL to answer business questions across customers, orders, restaurants and deliveries.
3. Build reusable Power BI/DAX KPIs.
4. Analyze customer retention and churn.
5. Evaluate restaurant and cuisine performance.
6. Identify delivery and customer-experience bottlenecks.
7. Translate analysis into actionable business recommendations.

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **MySQL / SQL** | Data validation, querying and business analysis |
| **Power BI** | Interactive dashboard and visualization |
| **DAX** | KPI and analytical measures |
| **Power Query** | Data preparation and transformation |
| **Excel** | Source-data/workbook preparation |

---

## 🗂️ Data Model

The final analytical model contains **9 tables**:

| Table | Rows |
|---|---:|
| `cities` | 10 |
| `memberships` | 3 |
| `customers` | 3,000 |
| `restaurants` | 300 |
| `menu_items` | 50 |
| `orders` | 10,000 |
| `order_items` | 21,055 |
| `deliveries` | 6,690 |
| `feedback` | 5,687 |

The model connects customers, memberships, cities, orders, restaurants, menu items, deliveries and feedback to support end-to-end analysis.

---

## 🔍 Data Quality & Validation

Before business analysis, the dataset was validated for:

- Row counts
- Duplicate primary keys
- Important NULL values
- Orphan customer references
- Orphan restaurant references
- Invalid order amounts
- Invalid ratings
- Referential consistency across key tables

This step was important because the Power BI dashboard was built only after the underlying data quality checks were completed.

---

# 🧮 SQL Analysis

The final SQL script contains **30 numbered business questions**, in addition to schema/data-quality validation queries.

### Analysis Areas

- Business overview and revenue
- Membership performance
- Repeat vs one-time customers
- Customer lifetime value
- Inactive customers
- Monthly active customers and retention
- City and age-group segmentation
- Restaurant performance
- Cuisine performance
- Menu-item revenue
- Restaurant rankings by city
- Delivery time and distance
- Weather impact
- Delivery ratings and complaints
- Customer value by city
- Cumulative revenue
- City-level AOV benchmarking
- Executive KPI summaries

### Advanced SQL Techniques

The project demonstrates practical use of:

- `JOIN`
- `GROUP BY`
- `HAVING`
- `CASE WHEN`
- Subqueries
- CTEs
- `RANK()`
- `DENSE_RANK()`
- `ROW_NUMBER()`
- `LAG()`
- Windowed `SUM()`
- `COUNT(DISTINCT ...)`

### ⭐ Selected SQL Questions

The repository will also include screenshots of selected queries so recruiters can quickly see the SQL work without opening the complete script.

| Question | Analysis |
|---:|---|
| **Q8** | Customer Lifetime Value |
| **Q10** | Inactive Customers |
| **Q12** | Customer Retention |
| **Q18** | Top Restaurant in Each City |
| **Q19** | Top 3 Restaurants by City |
| **Q22** | Delivery Performance by Weather |
| **Q28** | Cumulative Revenue |
| **Q29** | City-level AOV Benchmarking |

The complete SQL script remains available in [`sql/`](sql/).

---

# 📊 Power BI Dashboard

The final report contains **5 analytical pages**.

## 1️⃣ Executive Overview

**Business question:** *How is the business performing?*

### KPIs
- Delivered Revenue
- Delivered Orders
- Average Order Value
- Average Delivery Time
- Active Customers
- On-Time Delivery %

### Analysis
- Monthly revenue trend
- Revenue by city
- Revenue by membership

---

## 2️⃣ Customer Analytics

**Business question:** *Who are the most valuable and highest-risk customers?*

### KPIs
- Active Customers (90D)
- Churned Customers
- Never Ordered
- Average Orders per Customer
- Top Customer Spend
- Retention Rate

### Analysis
- Top 5 customers by spend
- Active vs Churned by city
- Customer signups by month

---

## 3️⃣ Restaurant Performance

**Business question:** *Which restaurant partners drive revenue and which need attention?*

### KPIs
- Total Restaurants
- Top Restaurant Revenue
- Average Rating
- Top Cuisine
- Restaurants Below 3.5★
- Restaurants Below ₹5K Revenue

### Analysis
- Top 5 restaurants by revenue
- Bottom 5 restaurants by revenue
- Revenue by cuisine

---

## 4️⃣ Delivery Performance

**Business question:** *What affects delivery reliability and customer experience?*

### KPIs
- Average Delivery Time
- On-Time %
- Average Distance
- Complaint Rate
- Average Food Rating
- Average Delivery Rating

### Analysis
- Delivery time by weather
- Complaint rate by weather
- On-time % by distance band

---

## 5️⃣ Churn Analysis

**Business question:** *Where is customer loss concentrated?*

### KPIs
- Total Customers
- Active Customers
- Churned Customers
- Never Ordered
- Churn Rate

### Analysis
- Churn by membership tier
- Churn by city
- Customer status distribution

---

# 👥 Customer Definitions

The project keeps **At Risk** separate from **Churned** because the two groups require different business actions.

### Active Customer (90D)
A customer with delivered-order activity inside the defined 90-day activity window.

### At Risk
An intermediate customer segment identified by the project's customer-status logic. These customers are not automatically classified as fully churned.

### Churned Customer
A previously active/order-making customer who has exceeded the defined inactivity threshold.

### Never Ordered
A registered customer with no delivered-order history.

### Retention Rate
The dashboard uses:

`Active Customers / (Active Customers + Churned Customers)`

This definition should be interpreted as retention among customers included in the active/churned population, rather than retention across never-ordered customers.

---

# 💡 Key Business Insights

The analysis is designed to identify actionable patterns such as:

1. **Customer retention is a major opportunity** because a significant share of previously active customers are no longer active.
2. **Churn varies by city**, allowing retention campaigns to be targeted geographically.
3. **Membership tiers show different customer and revenue behavior**, making membership segmentation useful for retention strategy.
4. **Longer delivery distances can weaken on-time performance**, highlighting a potential operational bottleneck.
5. **Weather can affect delivery time and complaint rates**, supporting weather-aware operational planning.
6. **Restaurant revenue is concentrated among stronger partners and cuisines**, creating opportunities for partner benchmarking.
7. **Low-revenue and low-rated restaurants can be identified** for targeted partner-support initiatives.

> Exact KPI values can change with dashboard filters; the PBIX is the source of truth for interactive results.

---

# 🎯 Business Recommendations

Based on the analysis, management could:

- Prioritize high-value customers for retention and reactivation campaigns.
- Target high-churn cities with localized offers.
- Use membership-specific retention incentives.
- Investigate long-distance routes with weak on-time performance.
- Plan delivery capacity around adverse weather conditions.
- Provide targeted support to low-revenue or low-rated restaurant partners.
- Use top-performing restaurants and cuisines as benchmarks.

---

# 📁 Repository Structure

```text
Zomato-Customer-Churn-Analysis/
│
├── README.md
│
├── powerbi/
│   └── Zomato_Customer_Churn.pbix
│
├── sql/
│   ├── Zomato_Customer_Churn_SQL.sql
│   └── screenshots/
│       ├── 01_data_quality.png
│       ├── 02_Q08_customer_lifetime_value.png
│       ├── 03_Q10_inactive_customers.png
│       ├── 04_Q12_customer_retention.png
│       ├── 05_Q18_top_restaurant_by_city.png
│       ├── 06_Q19_top_3_restaurants_by_city.png
│       ├── 07_Q22_delivery_weather.png
│       ├── 08_Q28_cumulative_revenue.png
│       └── 09_Q29_city_aov_benchmark.png
│
├── data/
│   └── Zomato_Customer_Retention.xlsx
│
├── documentation/
│   └── Project_Documentation.pdf
│
├── docs/
│   ├── data_dictionary.md
│   ├── dax_measures.md
│   └── interview_guide.md
│
└── screenshots/
    ├── 01_executive_overview.png
    ├── 02_customer_analytics.png
    ├── 03_restaurant_performance.png
    ├── 04_delivery_performance.png
    └── 05_churn_analysis.png
```

---

# 🎤 Interview Pitch

> **I built an end-to-end food-delivery analytics case study using MySQL, SQL, Power BI and DAX. I first validated a 9-table relational dataset and performed 30 business-focused SQL analyses covering revenue, customer behavior, retention, restaurant performance and delivery operations. I then built a five-page Power BI dashboard with DAX-based KPIs to identify churn patterns, revenue drivers and operational bottlenecks, and translated those findings into business recommendations.**

### Questions I can defend in an interview

- Why did you choose a 90-day customer activity definition?
- Why keep At Risk separate from Churned?
- How did you calculate retention?
- How did you avoid duplicate customer counting?
- Why did you use SQL before Power BI?
- Which advanced SQL techniques did you use?
- How did you build the customer-status logic?
- How does delivery distance affect on-time performance?
- What business action would you recommend to reduce churn?
- What would you improve if this were production data?

---

# 🧠 Skills Demonstrated

### SQL
Joins • Aggregations • CTEs • Subqueries • Window Functions • Ranking • Customer Analytics • Retention Analysis

### Power BI
Data Modeling • Power Query • KPI Cards • Interactive Slicers • Business Dashboards • Data Storytelling

### DAX
Customer Segmentation • Retention • Revenue • Delivery KPIs • Operational Metrics

### Business Analysis
Customer Churn • Customer Retention • Revenue Drivers • Restaurant Performance • Delivery Operations • Root-Cause Thinking • Recommendations

---

## 📌 Portfolio Note

This is a **portfolio/analytical dataset** structured to simulate a food-delivery business. It is intended to demonstrate analytical workflow, SQL skills, BI development and business decision-making; it does not represent Zomato's proprietary internal data.

---

## 🚀 Project Status

**Completed — portfolio ready.**

The next step is to add the final dashboard screenshots and selected SQL screenshots so the repository can be reviewed visually without opening the PBIX or SQL file.
