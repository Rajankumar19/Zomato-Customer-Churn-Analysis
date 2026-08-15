# 🍽️ Zomato Customer Churn & Business Performance Analysis

**End-to-end food-delivery analytics case study using MySQL, SQL, Power BI, DAX and Excel to diagnose customer retention, revenue and delivery-performance problems.**

![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi&logoColor=black) ![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?logo=mysql&logoColor=white) ![DAX](https://img.shields.io/badge/DAX-Power%20BI-orange) ![Excel](https://img.shields.io/badge/Excel-Data%20Preparation-217346?logo=microsoftexcel&logoColor=white)

## 🎯 Business Problem

Food-delivery businesses need to understand **which customers are returning, where customer loss is concentrated, which customer segments are most valuable, and what operational factors affect delivery experience.**

Workflow:

**Data validation → SQL analysis → Power BI/DAX → Business insights → Recommendations**

### Core questions

- Which customers are active, at risk, churned or never ordered?
- Where is churn concentrated by city and membership?
- Which customers and membership tiers are most valuable?
- Which restaurants and cuisines drive revenue?
- How do distance and weather relate to delivery reliability?

## 📊 Dataset & Data Model

The final relational model contains **9 tables**:

| Table | Rows |
|---|---:|
| Cities | 10 |
| Memberships | 3 |
| Customers | 3,000 |
| Restaurants | 300 |
| Menu items | 50 |
| Orders | 10,000 |
| Order items | 21,055 |
| Deliveries | 6,690 |
| Feedback | 5,687 |

Main relationships connect customers to cities/memberships, orders to customers/restaurants, order items to orders/menu items, and deliveries/feedback to orders.

## 🔍 Data Quality & Validation

Validation was completed before business analysis. Checks covered:

- Duplicate IDs
- Critical NULLs
- Orphan customer references
- Orphan restaurant references
- Invalid order amounts
- Invalid ratings
- Referential consistency

The final validation checks returned **zero exceptions for the tested critical conditions**.

## 🧮 SQL Analysis

The project contains **30 SQL analyses** covering:

- Revenue and business KPIs
- Cancellation rate
- Monthly revenue and growth
- Membership performance
- Repeat customers and LTV
- Customer inactivity and retention
- City and customer segmentation
- Restaurant and cuisine performance
- Delivery distance and weather
- Ratings and complaints
- Cumulative revenue
- City-level AOV benchmarking

### SQL techniques

`JOIN` · `GROUP BY` · `HAVING` · `CASE WHEN` · CTEs · Subqueries · `RANK()` · `DENSE_RANK()` · `ROW_NUMBER()` · `LAG()` · Window functions · `COUNT(DISTINCT ...)`

## 👥 Customer Status Methodology

Customer status uses mutually exclusive delivered-order activity windows relative to the dataset observation end date (**December 31, 2025**):

| Status | Definition |
|---|---|
| **Active** | Last delivered order <60 days before observation end |
| **At Risk** | Last delivered order 60–89 days before observation end |
| **Churned** | Last delivered order ≥90 days before observation end |
| **Never Ordered** | No delivered-order history |

Never-ordered customers are excluded from the simplified retention denominator because they never became retained customers.

## 💡 Key Business Insights

### 1. Customer churn is the primary retention problem

Of **3,000 registered customers, 1,812 (60.4%) are classified as churned**. Among customers with at least one delivered order, churn is approximately **66.0%**.

**Business impact:** There is a substantial reactivation opportunity among customers the business has already acquired.

**Recommendation:** Prioritize high-value At Risk and Churned customers for targeted reactivation and monitor repeat-order rates after intervention.

### 2. Monthly customer retention is weak

Average month-over-month customer retention is approximately **17.1%**, with **18.2% in December 2025**.

**Recommendation:** Track 30-, 60- and 90-day repeat-order rates and test retention offers by customer value, city and membership.

### 3. Churn rate and churn volume identify different city priorities

**Jaipur has the highest churn rate at 70.3%**, while **Delhi has the largest absolute churn population with 340 churned customers**.

**Business impact:** City prioritization based on churn rate alone can overlook locations with more affected customers.

**Recommendation:** Combine churn rate and churn volume when prioritizing city-level retention campaigns.

### 4. Pro customers have substantially higher order value

Average order value is approximately **₹347 Regular, ₹528 Gold and ₹810 Pro**. Pro AOV is approximately **2.3× Regular AOV**.

**Recommendation:** Protect high-value Pro customers with targeted retention benefits and investigate behaviors associated with higher spending. This is an observed association, not proof that membership causes higher spending.

### 5. Longer-distance deliveries have weaker on-time performance

On-time delivery falls from approximately **78.2% for <3 km orders to 74.1% for >6 km orders**.

**Recommendation:** Investigate long-distance zones for rider allocation, restaurant clustering, service-area design and ETA management.

### 6. Adverse weather is strongly associated with delivery delays

Average delivery time increases from **29.1 minutes in sunny conditions** to **49.2 minutes during rain** and **52.4 minutes during fog**. On-time delivery falls to **5.0% during rain and 0% during fog** in the dataset.

**Recommendation:** Use weather-aware capacity planning and proactive ETA communication during severe conditions.

**Analytical caution:** These are observational relationships; the analysis shows association, not causality.

## 📊 Power BI Dashboard

The report contains five analytical pages:

1. **Executive Overview** — revenue, orders, AOV, active customers and delivery KPIs.
2. **Customer Analytics** — customer value, retention, membership and city comparisons.
3. **Restaurant Performance** — restaurant, cuisine, rating and revenue analysis.
4. **Delivery Performance** — delivery time, distance, weather, ratings and complaints.
5. **Churn Analysis** — customer status, churn by city and membership, and retention opportunities.

![Executive Overview](screenshots/executive_overview.png)

![Customer Analytics](screenshots/customer_analytics.png)

![Restaurant Performance](screenshots/restaurant_performance.png)

![Delivery Performance](screenshots/delivery_performance.png)

![Churn Analysis](screenshots/churn_analysis.png)

## 🎤 Interview Pitch

> **I built an end-to-end food-delivery analytics case study using MySQL, SQL, Power BI and DAX. I validated a 9-table relational dataset, then performed 30 business-focused SQL analyses covering revenue, customer behavior, retention, restaurant performance and delivery operations. The analysis found that 60.4% of registered customers were classified as churned and monthly retention averaged about 17.1%. I then built a five-page Power BI dashboard and translated the findings into targeted retention and operational recommendations.**

## 🛠️ Skills Demonstrated

**SQL / MySQL:** Joins, aggregations, CTEs, subqueries, window functions, ranking, retention and customer analytics.

**Power BI / DAX:** Data modeling, Power Query, KPI measures, segmentation, retention, delivery KPIs and interactive dashboards.

**Business Analysis:** Customer churn, retention, revenue drivers, restaurant performance, delivery operations and recommendation development.

## 📁 Repository Structure

```text
Zomato-Customer-Churn-Analysis/
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

**Status: Interview-ready portfolio case study.**
