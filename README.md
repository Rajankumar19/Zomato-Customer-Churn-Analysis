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
- Does delivery distance relate to delivery reliability?
- How do weather conditions relate to delivery performance?
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

All tested critical validation checks returned **zero exceptions** in the final dataset.

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
- Weather and delivery performance
- Delivery ratings and complaints
- Customer value by city
- Cumulative revenue
- City-level AOV benchmarking
- Executive KPI summary

### SQL techniques demonstrated

`JOIN` · `GROUP BY` · `HAVING` · `CASE WHEN` · Subqueries · CTEs · `RANK()` · `DENSE_RANK()` · `ROW_NUMBER()` · `LAG()` · Window functions · `COUNT(DISTINCT ...)`

## 👥 Customer Status Methodology

Customer status is based on delivered-order activity relative to the dataset observation period. The groups are mutually exclusive.

| Status | Definition | Business meaning |
|---|---|---|
| **Active** | Last delivered order was <60 days before the observation end date | Currently engaged customer |
| **At Risk** | Last delivered order was 60–89 days before the observation end date | Early retention opportunity |
| **Churned** | Last delivered order was ≥90 days before the observation end date | Longer-term customer loss |
| **Never Ordered** | No delivered-order history | Registered but never retained |

The observation end date is **December 31, 2025**, based on the latest delivered-order activity used by the analysis.

`Never Ordered` customers are excluded from the simplified retention denominator because they never became retained customers.

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

## 💡 Key Business Insights & Recommendations

### 1. Customer churn is the primary retention problem

Of **3,000 registered customers**, **1,812 (60.4%) are classified as Churned**. Among customers with at least one delivered order, the churn share is approximately **66.0%**.

**Business impact:** The business has a substantial reactivation opportunity among customers it has already acquired.

**Recommendation:** Prioritize high-value At Risk and Churned customers for targeted reactivation campaigns and monitor repeat-order rate after intervention.

### 2. Monthly customer retention is weak

Month-over-month customer retention averages approximately **17.1%** across the observation period, with **18.2%** in December 2025.

**Business impact:** Revenue activity can continue while customer continuity remains weak.

**Recommendation:** Track 30-, 60- and 90-day repeat-order rates and test retention offers by customer value, city and membership tier.

### 3. Churn rate and churn volume identify different city priorities

Among customers with delivered-order history, **Jaipur has the highest churn rate at 70.3%**, while **Delhi has the largest absolute churn population with 340 churned customers**.

**Business impact:** Prioritizing cities using churn rate alone could overlook locations with a larger number of affected customers.

**Recommendation:** Use both churn rate and churned-customer volume to prioritize city-level retention interventions.

### 4. Pro customers have substantially higher order value

Average order value is approximately **₹347 for Regular**, **₹528 for Gold** and **₹810 for Pro** customers. Pro AOV is approximately **2.3× Regular AOV**.

**Business impact:** Pro customers represent a disproportionately valuable segment.

**Recommendation:** Protect high-value Pro customers with targeted retention benefits and investigate which customer behaviors are associated with their higher spending. This is an observed association, not proof that membership causes higher spending.

### 5. Longer-distance deliveries have weaker on-time performance

On-time delivery falls from approximately **78.2% for orders under 3 km** to **74.1% for orders above 6 km**.

**Business impact:** Longer delivery distances are associated with weaker delivery reliability in this dataset.

**Recommendation:** Investigate long-distance zones for rider allocation, restaurant clustering, service-area design and ETA management.

### 6. Adverse weather is strongly associated with delivery delays

Average delivery time increases from **29.1 minutes in sunny conditions** to **49.2 minutes during rain** and **52.4 minutes during fog**. On-time delivery falls to **5.0% during rain** and **0% during fog** in the dataset.

**Business impact:** Adverse weather coincides with substantially weaker delivery reliability.

**Recommendation:** Introduce weather-aware operational planning, including additional delivery capacity, proactive ETA communication and temporary service-area adjustments during severe conditions.

**Analytical caution:** These are observational relationships. The analysis shows association, not that weather alone causes delivery delays.

## 🛠️ Tools & Skills

### SQL / MySQL

Joins · Aggregations · CTEs · Subqueries · Window Functions · Ranking · Retention Analysis · Customer Analytics · Data Validation

### Power BI / DAX

Data Modeling · Power Query · KPI Measures · Customer Segmentation · Retention · Delivery KPIs · Interactive Dashboards · Data Storytelling

### Business Analysis

Customer Churn · Customer Retention · Revenue Drivers · Restaurant Performance · Delivery Operations · Root-Cause Thinking · Recommendations

## 🎤 Interview Pitch

> **I built an end-to-end food-delivery analytics case study using MySQL, SQL, Power BI and DAX. I first validated a 9-table relational dataset containing 3,000 customers and 10,000 orders, then performed 30 business-focused SQL analyses covering revenue, customer behavior, retention, restaurant performance and delivery operations. The analysis found that 60.4% of registered customers were classified as churned, monthly retention averaged about 17.1%, and delivery reliability varied substantially by distance and weather conditions. I then built a five-page Power BI dashboard to investigate these patterns and translated the findings into targeted retention and operational recommendations.**

### Interview topics covered

- Why a relational 9-table model instead of one flat table?
- How were customer-status definitions designed?
- Why use `COUNT(DISTINCT customer_id)`?
- Why are delivered orders used for revenue KPIs?
- How do CTEs and window functions support the analysis?
- Why use `LAG()` for monthly growth?
- Why distinguish At Risk from Churned?
- How is retention calculated?
- Why can churn rate and churn volume lead to different city priorities?
- Why should weather be described as associated with delays rather than as a proven cause?
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
