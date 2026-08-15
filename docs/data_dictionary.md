# Data Dictionary

## Overview

The project uses a 9-table relational model representing a simulated food-delivery platform.

| Table | Purpose | Rows |
|---|---|---:|
| `cities` | City master data | 10 |
| `memberships` | Membership tiers and fees | 3 |
| `customers` | Customer profile and signup information | 3,000 |
| `restaurants` | Restaurant partner information | 300 |
| `menu_items` | Menu item master data | 50 |
| `orders` | Customer order transactions | 10,000 |
| `order_items` | Items contained in each order | 21,055 |
| `deliveries` | Delivery time, distance and weather | 6,690 |
| `feedback` | Food/delivery ratings and complaints | 5,687 |

## Key Relationships

- `customers.city_id` → `cities.city_id`
- `customers.membership_id` → `memberships.membership_id`
- `restaurants.city_id` → `cities.city_id`
- `orders.customer_id` → `customers.customer_id`
- `orders.restaurant_id` → `restaurants.restaurant_id`
- `order_items.order_id` → `orders.order_id`
- `order_items.item_id` → `menu_items.item_id`
- `deliveries.order_id` → `orders.order_id`
- `feedback.order_id` → `orders.order_id`

## Important Fields

### customers

| Field | Meaning |
|---|---|
| `customer_id` | Unique customer identifier |
| `customer_name` | Customer name |
| `gender` | Customer gender |
| `age` | Customer age |
| `city_id` | Customer's city |
| `membership_id` | Membership tier |
| `signup_date` | Customer registration date |

### orders

| Field | Meaning |
|---|---|
| `order_id` | Unique order identifier |
| `customer_id` | Customer placing the order |
| `restaurant_id` | Restaurant receiving the order |
| `order_datetime` | Date/time of order |
| `order_type` | Order channel/type |
| `subtotal` | Pre-discount item value |
| `discount` | Discount applied |
| `delivery_fee` | Delivery fee |
| `final_amount` | Final order value used for revenue analysis |
| `order_status` | Order outcome; delivered orders are used for most performance analysis |

### deliveries

| Field | Meaning |
|---|---|
| `delivery_id` | Unique delivery identifier |
| `order_id` | Related order |
| `delivery_time_minutes` | Delivery duration |
| `distance_km` | Delivery distance |
| `weather` | Weather condition during delivery |
| `delivered_on_time` | Whether the delivery met the on-time definition |

### feedback

| Field | Meaning |
|---|---|
| `feedback_id` | Unique feedback record |
| `order_id` | Related order |
| `food_rating` | Food rating from 1–5 |
| `delivery_rating` | Delivery rating from 1–5 |
| `complaint_flag` | Whether a complaint was recorded |

## Data Quality Checks

The SQL workflow checks row counts, duplicate keys, important NULLs, orphan customer/restaurant references, invalid monetary values and invalid ratings before business analysis.
