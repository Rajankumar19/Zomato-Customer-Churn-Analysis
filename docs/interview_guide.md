# Interview Guide

## 30-second project explanation

> I built an end-to-end food-delivery analytics case study using MySQL, SQL, Power BI and DAX. I first validated a 9-table relational dataset, then used SQL to analyze revenue, customer behavior, retention, restaurant performance and delivery operations. Finally, I built a five-page Power BI dashboard to turn those findings into business insights and recommendations.

## 2-minute explanation

The business problem was to understand where revenue comes from, why customers become inactive, which restaurant partners perform best, and what operational factors affect delivery experience.

I started with data-quality validation because incorrect relationships or invalid transactions could produce misleading dashboard results. The dataset contains 9 related tables covering customers, memberships, cities, restaurants, orders, order items, deliveries and feedback.

I then used MySQL for 30 business-focused questions. The analysis included joins, aggregations, CTEs, subqueries, ranking functions, `LAG()` and windowed `SUM()`. Examples include customer lifetime value, inactivity risk, monthly retention, top restaurants by city, weather-related delivery performance and cumulative revenue.

For the BI layer, I created DAX measures for revenue, delivered orders, AOV, active customers, churned customers, retention and delivery KPIs. The Power BI report contains Executive Overview, Customer Analytics, Restaurant Performance, Delivery Performance and Churn Analysis pages.

The final step was translating the numbers into actions: targeted retention campaigns, city-level churn interventions, membership-specific offers, delivery-distance investigation and weather-aware operational planning.

## Customer-status methodology

The final methodology uses mutually exclusive customer-status groups:

- **Active:** last delivered order was less than 60 days before the dataset observation end date.
- **At Risk:** last delivered order was 60–89 days before the dataset observation end date.
- **Churned:** last delivered order was 90+ days before the dataset observation end date.
- **Never Ordered:** registered customer with no delivered-order history.

The dataset observation end date is the latest delivered-order timestamp: **December 31, 2025**.

This makes the groups mutually exclusive. `Never Ordered` customers are excluded from the simplified retention denominator because they never became retained customers.

## Key findings from the actual dataset

### Finding 1 — Customer churn is the primary retention problem

Of 3,000 registered customers:

- 684 are **Active**
- 228 are **At Risk**
- 1,812 are **Churned**
- 276 are **Never Ordered**

Therefore, **60.4% of all registered customers are classified as Churned**. Among customers with at least one delivered order, the churn share is approximately **66.0%**.

**Business implication:** The business has a substantial reactivation opportunity among previously acquired customers.

**Recommendation:** Prioritize high-value At Risk and Churned customers for targeted reactivation campaigns and monitor repeat-order rate after intervention.

### Finding 2 — Monthly customer retention is weak

Month-over-month customer retention averages approximately **17.1%** across the observation period. December 2025 retention was **18.2%**.

**Business implication:** Revenue activity can continue while customer continuity remains weak.

**Recommendation:** Track 30-, 60- and 90-day repeat-order rates and test targeted retention offers by customer value, city and membership tier.

### Finding 3 — Churn rate and churn volume tell different stories

Among customers with delivered-order history, **Jaipur has the highest churn rate at 70.3%**, while **Delhi has the largest absolute churn population with 340 churned customers**.

**Business implication:** A retention strategy should not prioritize locations using churn rate alone; the number of affected customers also matters.

**Recommendation:** Use both churn rate and churned-customer volume to prioritize city-level interventions.

### Finding 4 — Pro customers have substantially higher order value

Average order value by membership is approximately:

| Membership | AOV |
|---|---:|
| Regular | ₹347 |
| Gold | ₹528 |
| Pro | **₹810** |

Pro customers have an AOV approximately **2.3×** that of Regular customers.

**Business implication:** Pro customers represent a disproportionately valuable customer segment.

**Recommendation:** Protect high-value Pro customers with targeted retention benefits and investigate which customer behaviors are associated with their higher spending. This is an observed association, not proof that membership itself causes higher spending.

### Finding 5 — Longer-distance deliveries have weaker on-time performance

| Distance | Average delivery time | On-time rate |
|---|---:|---:|
| <3 km | 35.6 min | 78.2% |
| 3–6 km | 36.2 min | 75.5% |
| >6 km | 36.2 min | **74.1%** |

**Business implication:** Longer delivery distances are associated with weaker delivery reliability in this dataset.

**Recommendation:** Investigate long-distance zones for rider allocation, restaurant clustering, service-area design and ETA management.

### Finding 6 — Adverse weather is strongly associated with delivery delays

| Weather | Average delivery time | On-time rate |
|---|---:|---:|
| Sunny | 29.1 min | 100.0% |
| Cloudy | 34.8 min | 100.0% |
| Rain | 49.2 min | 5.0% |
| Fog | 52.4 min | 0.0% |

**Business implication:** Rain and fog coincide with substantially longer delivery times and much weaker on-time performance.

**Recommendation:** Introduce weather-aware operational planning, including additional delivery capacity, proactive ETA communication and temporary service-area adjustments during severe conditions.

**Analytical caution:** These are observational relationships. The analysis shows association, not that weather alone causes delivery delays.

## Data-quality validation result

The validation checks returned no exceptions for the tested critical conditions:

- Duplicate customer IDs: **0**
- Duplicate order IDs: **0**
- Orphan customer references: **0**
- Orphan restaurant references: **0**
- Critical NULL checks in orders: **0**
- Invalid order amounts: **0**
- Invalid ratings: **0**

This validation was completed before interpreting the business metrics.

## Questions you should be ready for

### Data & modeling

1. Why did you use 9 tables instead of one flat table?
2. What are the main relationships in the model?
3. How did you validate the data before building the dashboard?
4. What does an orphan customer or restaurant reference mean?
5. Why are delivered orders used for most revenue KPIs?

### SQL

6. Why use `COUNT(DISTINCT customer_id)` for active customers?
7. When would you use `HAVING` instead of `WHERE`?
8. Why did you use a CTE for customer lifetime value or ranking analysis?
9. What is the difference between `RANK`, `DENSE_RANK` and `ROW_NUMBER`?
10. Why is `LAG()` useful for monthly revenue growth?
11. How did you calculate cumulative revenue?
12. How would you optimize a slow version of one of these queries?

### Churn & retention

13. What is your definition of an Active customer?
14. Why did you choose a 90-day churn threshold?
15. Why is the 60–89 day segment treated as At Risk?
16. Why keep At Risk separate from Churned?
17. Why are Never Ordered customers excluded from the retention denominator?
18. How did you calculate the monthly retention rate?
19. Why can churn rate and churn volume lead to different city priorities?
20. What would you do if churn is concentrated in one city?

### Power BI & DAX

21. Why use measures instead of calculated columns for KPIs?
22. Why use `DISTINCTCOUNT` for customers?
23. How does filter context affect your retention measure?
24. How would a city or membership slicer change the KPI cards?
25. Why did a retention calculation produce unexpected results during development?

### Business insights

26. Which finding would you present first to management?
27. Why is high churn the primary business concern?
28. Why is Pro membership interesting even though you cannot claim causality?
29. What does the distance analysis tell you about delivery operations?
30. Why should you say weather is associated with delays rather than causes them?
31. Which KPI would you monitor weekly after implementing the recommendations?
32. What additional data would you request in a real food-delivery environment?

## Strong answer pattern

For business questions, answer in this order:

**Finding → Evidence → Business impact → Recommendation → Next metric to monitor**

Example:

> **Finding:** Customer churn is high and concentrated in specific locations. **Evidence:** 1,812 of 3,000 registered customers are classified as churned, while Delhi has the largest absolute churn population and Jaipur has the highest churn rate among ordered customers. **Business impact:** The business risks losing value from customers it has already acquired. **Recommendation:** Prioritize high-value reactivation campaigns using both churn rate and churn volume. **Next metric:** 30/60/90-day repeat-order and reactivation rate.
