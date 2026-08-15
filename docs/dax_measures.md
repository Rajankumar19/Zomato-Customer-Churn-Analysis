# DAX Measures

This document lists the main Power BI measures used in the dashboard. The measures are intentionally kept readable so the business logic can be explained in an interview.

## Customer KPIs

### Active Customers (90D)

Counts customers with delivered-order activity inside the project's 90-day activity window.

```DAX
Active Customers =
CALCULATE(
    DISTINCTCOUNT(customers[customer_id]),
    customers[Customer Status] = "Active"
)
```

> The exact customer-status logic is model-specific; the PBIX is the source of truth for the final implementation.

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

Retention is calculated among customers classified as active or churned, excluding `Never Ordered` from the denominator.

```DAX
Retention Rate =
DIVIDE(
    [Active Customers],
    [Active Customers] + [Churned Customers],
    0
)
```

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
