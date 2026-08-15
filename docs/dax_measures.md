# DAX Measures

This document lists the main Power BI measures used in the dashboard. The measures are intentionally kept readable so the business logic can be explained in an interview.

## Customer status methodology

Customer status is based on delivered-order activity relative to the dataset observation period. The groups are mutually exclusive:

- **Active:** last delivered order was less than 60 days before the observation end date.
- **At Risk:** last delivered order was 60–89 days before the observation end date.
- **Churned:** last delivered order was 90+ days before the observation end date.
- **Never Ordered:** no delivered-order history.

The observation end date is December 31, 2025. `Never Ordered` customers are excluded from the simplified retention denominator because they never became retained customers.

## Customer KPIs

### Active Customers

Counts customers classified as `Active` by the customer-status logic.

```DAX
Active Customers =
CALCULATE(
    DISTINCTCOUNT(customers[customer_id]),
    customers[Customer Status] = "Active"
)
```

> The exact customer-status implementation is model-specific; the PBIX is the source of truth for the final implementation.

### At Risk Customers

Counts customers classified as `At Risk`.

```DAX
At Risk Customers =
CALCULATE(
    DISTINCTCOUNT(customers[customer_id]),
    customers[Customer Status] = "At Risk"
)
```

### Churned Customers

Counts customers classified as `Churned` by the customer-status logic.

```DAX
Churned Customers =
CALCULATE(
    DISTINCTCOUNT(customers[customer_id]),
    customers[Customer Status] = "Churned"
)
```

### Never Ordered

Counts registered customers with no delivered-order history.

```DAX
Never Ordered =
CALCULATE(
    DISTINCTCOUNT(customers[customer_id]),
    customers[Customer Status] = "Never Ordered"
)
```

### Retention Rate

Retention is calculated among customers classified as Active or Churned, excluding `Never Ordered` and the intermediate `At Risk` segment from this simplified KPI.

```DAX
Retention Rate =
DIVIDE(
    [Active Customers],
    [Active Customers] + [Churned Customers],
    0
)
```

> The monthly retention analysis in SQL uses a separate month-over-month definition: customers active in the previous month who also order in the current month divided by previous-month active customers.

## Revenue KPIs

### Total Revenue

```DAX
Total Revenue =
CALCULATE(
    SUM(orders[final_amount]),
    orders[order_status] = "Delivered"
)
```

### Delivered Orders

```DAX
Delivered Orders =
CALCULATE(
    COUNTROWS(orders),
    orders[order_status] = "Delivered"
)
```

### Average Order Value

```DAX
Avg Order Value =
DIVIDE(
    [Total Revenue],
    [Delivered Orders],
    0
)
```

## Delivery KPIs

```DAX
Avg Delivery Time =
AVERAGE(deliveries[delivery_time_minutes])
```

```DAX
On-Time % =
DIVIDE(
    CALCULATE(
        COUNTROWS(deliveries),
        deliveries[delivered_on_time] = "Yes"
    ),
    COUNTROWS(deliveries),
    0
)
```

## Interview Notes

- `DISTINCTCOUNT(customer_id)` is important because one customer can place multiple orders.
- Delivered-order filters keep cancelled orders from inflating revenue and order KPIs.
- Retention is not the same as `1 - churn rate` unless the numerator and denominator definitions are aligned.
- `At Risk` is intentionally kept separate from `Churned`; an at-risk customer can still be reactivated before becoming churned.
- The SQL monthly retention KPI and the simplified Power BI customer-status retention KPI answer different questions and should not be presented as the same metric.
- Weather and distance findings are observational associations, not causal claims.
