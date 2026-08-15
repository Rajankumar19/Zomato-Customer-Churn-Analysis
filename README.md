# 🍽️ Zomato Customer Churn & Business Performance Analysis

![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi&logoColor=black)
![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?logo=mysql&logoColor=white)
![DAX](https://img.shields.io/badge/DAX-Power%20BI-orange)
![Excel](https://img.shields.io/badge/Excel-Data%20Preparation-217346?logo=microsoftexcel&logoColor=white)

> **End-to-end Data Analyst case study using MySQL, SQL, Power BI, DAX and Excel to investigate customer retention, revenue drivers, restaurant performance and delivery operations.**

## 🎯 Business Problem

Food-delivery businesses need to understand not only how much revenue they generate, but also **which customers are returning, where customer inactivity is concentrated, which restaurant partners drive performance, and what operational factors affect delivery experience.**

This project simulates that problem using a relational food-delivery dataset and follows a complete analytics workflow:

**Data validation → SQL analysis → Data modeling → Power BI/DAX → Business insights → Recommendations**

### Key business questions

- Where is revenue being generated?
- Which customers are active, at risk, churned or have never ordered?
- Which customers and membership tiers are most valuable?
- Which cities, restaurants and cuisines drive revenue?
- Does delivery distance affect delivery time and on-time performance?
- How do weather and delivery performance relate to customer experience?
- Where should retention and operational improvement efforts be prioritized?

## 📊 Dataset & Data Model

The final model contains **9 related tables**:

| Table | Rows | Purpose |
|---|---:|---|
| `cities` | 10 | City master data |
| `memberships` | 3 | Membership tiers |
| `customers` | 3,000 | Customer profiles and signup data |
| `restaurants` | 300 | Restaurant partners and cuisines |
| `menu_items` | 50 | Menu item master data |
| `orders` | 10,000 | Order transactions |
| `order_items` | 21,055 | Items within orders |
| `deliveries` | 6,690 | Delivery time, distance and weather |
| `feedback` | 5,687 | Ratings and complaints |

### Main relationships

`customers → cities / memberships`  
`orders → customers / restaurants`  
`order_items → orders / menu_items`  
`deliveries → orders`  
`feedback → orders`

## 🔍 Data Quality & Validation

Validation was performed before business analysis and dashboard development.

Checks include:

- Row-count validation
- Duplicate primary-key checks
- Important NULL checks
- Orphan customer references
- Orphan restaurant references
- Invalid order amounts
- Invalid ratings
- Referential consistency

The goal was to prevent incorrect relationships or invalid records from producing misleading business conclusions.

## 🧮 SQL Analysis

The project contains **30 business-focused SQL questions**, supported by separate data-quality and schema-validation checks.

### Analysis areas

- Business overview and revenue
- Cancellation rate
- Monthly revenue and growth
- Membership performance
- Repeat vs one-time customers
- Customer lifetime value
- Customer inactivity risk
- Monthly customer retention
- City and age-group segmentation
- Restaurant and cuisine performance
- Menu-item revenue
- Top restaurants by city
- Delivery time and distance
- Weather impact
- Delivery ratings and complaints
- Customer value by city
- Cumulative revenue
- City-level AOV benchmarking
- Executive KPI summary

### SQL techniques demonstrated

`JOIN` · `GROUP BY` · `HAVING` · `CASE WHEN` · Subqueries · CTEs · `RANK()` · `DENSE_RANK()` · `ROW_NUMBER()` · `LAG()` · Window functions · `COUNT(DISTINCT ...)`

## 👥 Customer Status Methodology

Customer status is based on delivered-order activity relative to the dataset observation period.

| Status | Definition | Business meaning |
|---|---|---|
| **Active** | At least one delivered order in the most recent 90 days | Currently engaged customer |
| **At Risk** | Previously ordered, but no delivered order for 60–89 days | Early retention opportunity |
| **Churned** | Previously ordered, but inactive for 90+ days | Longer-term customer loss |
| **Never Ordered** | No delivered-order history | Registered but never retained |

**Important:** The SQL inactivity query uses the **60-day threshold as an At Risk indicator**. It is not presented as the final churn definition. The 90-day threshold is used for the Active/Churned classification.

`Never Ordered` customers are excluded from the simplified retention denominator because they were never retained customers.

## 📊 Power BI Dashboard

The report contains five analytical pages designed around business questions rather than standalone charts.

### 1. Executive Overview

**Question:** How is the business performing?

KPIs include delivered revenue, delivered orders, AOV, average delivery time, active customers and on-time delivery rate.

![Executive Overview](screenshots/executive_overview.png)

### 2. Customer Analytics

**Question:** Who are the highest-value and highest-risk customers?

Covers customer status, customer value, retention, membership performance and city-level customer comparison.

![Customer Analytics](screenshots/customer_analytics.png)

### 3. Restaurant Performance

**Question:** Which restaurant partners drive revenue and which require attention?

Covers restaurant revenue, ratings, cuisines and partner benchmarking.

![Restaurant Performance](screenshots/restaurant_performance.png)

### 4. Delivery Performance

**Question:** What affects delivery reliability and customer experience?

Covers delivery time, distance, on-time performance, complaints, ratings and weather.

![Delivery Performance](screenshots/delivery_performance.png)

### 5. Churn Analysis

**Question:** Where is customer loss concentrated and where should retention efforts focus?

Covers active, at-risk, churned and never-ordered customers, plus churn by membership and city.

![Churn Analysis](screenshots/churn_analysis.png)

## 💡 Business Insights & Recommendations

The analysis is designed to identify actionable opportunities such as:

- Prioritize high-value customers for retention and reactivation campaigns.
- Target cities with elevated customer inactivity or churn.
- Use membership-level differences to design more relevant retention offers.
- Investigate longer-distance routes with weaker on-time performance.
- Prepare additional delivery capacity for adverse weather conditions.
- Benchmark low-rated or low-revenue restaurant partners against stronger performers.
- Monitor repeat-order rate and customer-status movement after retention initiatives.

Business recommendations are based on the analytical outputs rather than generic dashboard observations.

## 🛠️ Tools & Skills

### SQL / MySQL

Joins · Aggregations · CTEs · Subqueries · Window Functions · Ranking · Retention Analysis · Customer Analytics · Data Validation

### Power BI / DAX

Data Modeling · Power Query · KPI Measures · Customer Segmentation · Retention · Delivery KPIs · Interactive Dashboards · Data Storytelling

### Business Analysis

Customer Churn · Customer Retention · Revenue Drivers · Restaurant Performance · Delivery Operations · Root-Cause Thinking · Recommendations

## 🎤 Interview Pitch

> **I built an end-to-end food-delivery analytics case study using MySQL, SQL, Power BI and DAX. I first validated a 9-table relational dataset containing 3,000 customers and 10,000 orders, then performed 30 business-focused SQL analyses covering revenue, customer behavior, retention, restaurant performance and delivery operations. I then built a five-page Power BI dashboard to identify customer-risk patterns, revenue drivers and operational bottlenecks, and translated those findings into targeted business recommendations.**

### Interview topics covered

- Why a relational 9-table model instead of one flat table?
- How were customer-status definitions designed?
- Why use `COUNT(DISTINCT customer_id)`?
- Why are delivered orders used for revenue KPIs?
- How do CTEs and window functions support the analysis?
- Why use `LAG()` for monthly growth?
- Why distinguish At Risk from Churned?
- How is retention calculated?
- How would you prioritize a city with high churn?
- What additional data would be required in a production environment?

See the full [interview guide](docs/interview_guide.md) and [DAX documentation](docs/dax_measures.md).

## 📁 Repository Structure

```text
Zomato-Customer-Churn-Analysis/
│
├── README.md
├── data/
│   └── Zomato_Customer_Retention.xlsx
├── powerbi/
│   └── Zomato_Customer_Churn.pbix
├── sql/
│   ├── Zomato_Customer_Churn_SQL.sql
│   └── screenshots/
├── docs/
│   ├── data_dictionary.md
│   ├── dax_measures.md
│   └── interview_guide.md
└── screenshots/
    ├── executive_overview.png
    ├── customer_analytics.png
    ├── restaurant_performance.png
    ├── delivery_performance.png
    └── churn_analysis.png
```

## 📌 Portfolio Note

This is a **portfolio/analytical dataset** structured to simulate a food-delivery business. It does not represent Zomato's proprietary internal data.

## 🚀 Project Status

**Interview-ready portfolio case study.**

The repository includes source data, SQL analysis, data-quality validation, Power BI reporting, DAX documentation, a data dictionary and interview preparation material.
