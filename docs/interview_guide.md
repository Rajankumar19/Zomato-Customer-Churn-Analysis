# Interview Guide

## 30-second project explanation

> I built an end-to-end food-delivery analytics case study using MySQL, SQL, Power BI and DAX. I first validated a 9-table relational dataset, then used SQL to analyze revenue, customer behavior, retention, restaurant performance and delivery operations. Finally, I built a five-page Power BI dashboard to turn those findings into business insights and recommendations.

## 2-minute explanation

The business problem was to understand where revenue comes from, why customers become inactive, which restaurant partners perform best, and what operational factors affect delivery experience.

I started with data-quality validation because incorrect relationships or invalid transactions could produce misleading dashboard results. The dataset contains 9 related tables covering customers, memberships, cities, restaurants, orders, order items, deliveries and feedback.

I then used MySQL for 30 business-focused questions. The analysis included joins, aggregations, CTEs, subqueries, ranking functions, `LAG()` and windowed `SUM()`. Examples include customer lifetime value, inactive customers, monthly retention, top restaurants by city, weather-related delivery performance and cumulative revenue.

For the BI layer, I created DAX measures for revenue, delivered orders, AOV, active customers, churned customers, retention and delivery KPIs. The Power BI report contains Executive Overview, Customer Analytics, Restaurant Performance, Delivery Performance and Churn Analysis pages.

The final step was translating the numbers into actions: targeted retention campaigns, city-level churn interventions, membership-specific offers, delivery-distance investigation and support for low-performing restaurant partners.

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

13. What is your definition of an active customer?
14. Why is the activity window 90 days?
15. Why keep `At Risk` separate from `Churned`?
16. Why are `Never Ordered` customers excluded from the retention denominator?
17. How did you calculate the retention rate?
18. What action would you take if churn is concentrated in one city?

### Power BI & DAX

19. Why use measures instead of calculated columns for KPIs?
20. Why use `DISTINCTCOUNT` for customers?
21. How does filter context affect your retention measure?
22. How would a city or membership slicer change the KPI cards?
23. Why did a retention calculation produce unexpected results during development?

### Business insights

24. Which finding would you present first to management?
25. What is the most important churn-reduction recommendation?
26. What operational issue does the delivery page reveal?
27. How can restaurants use the performance page?
28. Which KPI would you monitor weekly after implementing your recommendations?
29. What additional data would you request in a real Zomato environment?
30. What would you improve if this became a production analytics project?

## Strong answer pattern

For business questions, answer in this order:

**Finding → Evidence → Business impact → Recommendation → Next metric to monitor**

Example:

> Churn is concentrated in a few cities. The city-level dashboard shows those locations have a larger churned customer base. That creates a retention risk because customer acquisition spend may be wasted if customers do not return. I would run targeted reactivation campaigns in those cities and monitor 30/60/90-day repeat-order rate after the campaign.
