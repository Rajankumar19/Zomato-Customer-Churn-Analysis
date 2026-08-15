-- ZOMATO CUSTOMER RETENTION & BUSINESS ANALYSIS

-- Business Objective:
-- Understand customer behavior, retention, revenue, restaurant performance, delivery experience, and the main drivers of churn risk.

-- Dataset:
-- 9 tables | 3,000 customers | 10,000 orders

-- ============================================================
-- 1. DATABASE & SCHEMA
-- ============================================================

CREATE DATABASE IF NOT EXISTS zomato_customer_retention;
USE zomato_customer_retention;

CREATE TABLE cities (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(50),
    region VARCHAR(30)
);
CREATE TABLE memberships (
    membership_id INT PRIMARY KEY,
    membership_name VARCHAR(30),
    monthly_fee DECIMAL(10,2)
);
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    gender VARCHAR(10),
    age INT,
    city_id INT,
    membership_id INT,
    signup_date DATE,
    FOREIGN KEY (city_id) REFERENCES cities(city_id),
    FOREIGN KEY (membership_id) REFERENCES memberships(membership_id)
);
CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(100),
    city_id INT,
    cuisine VARCHAR(50),
    average_rating DECIMAL(2,1),
    FOREIGN KEY (city_id) REFERENCES cities(city_id)
);
CREATE TABLE menu_items (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    category VARCHAR(30),
    base_price DECIMAL(10,2)
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    order_datetime DATETIME,
    order_type VARCHAR(20),
    subtotal DECIMAL(10,2),
    discount DECIMAL(10,2),
    delivery_fee DECIMAL(10,2),
    final_amount DECIMAL(10,2),
    payment_method VARCHAR(30),
    order_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    line_total DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
);
CREATE TABLE deliveries (
    delivery_id INT PRIMARY KEY,
    order_id INT,
    delivery_time_minutes INT,
    distance_km DECIMAL(5,2),
    weather VARCHAR(20),
    delivered_on_time VARCHAR(5),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
CREATE TABLE feedback (
    feedback_id INT PRIMARY KEY,
    order_id INT,
    food_rating INT,
    delivery_rating INT,
    complaint_flag VARCHAR(5),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- ============================================================
-- 2. DATA QUALITY & VALIDATION
-- ============================================================

-- Row counts
SELECT 'cities' AS table_name, COUNT(*) AS row_count FROM cities
UNION ALL SELECT 'memberships', COUNT(*) FROM memberships
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'restaurants', COUNT(*) FROM restaurants
UNION ALL SELECT 'menu_items', COUNT(*) FROM menu_items
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'deliveries', COUNT(*) FROM deliveries
UNION ALL SELECT 'feedback', COUNT(*) FROM feedback;

-- Duplicate primary keys
SELECT order_id, COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT customer_id, COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Important NULL checks
SELECT
    SUM(customer_id IS NULL) AS null_customer_id,
    SUM(order_datetime IS NULL) AS null_order_datetime,
    SUM(final_amount IS NULL) AS null_final_amount,
    SUM(order_status IS NULL) AS null_order_status
FROM orders;

-- Orphan customer references
SELECT COUNT(*) AS orphan_customer_orders
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Orphan restaurant references
SELECT COUNT(*) AS orphan_restaurant_orders
FROM orders o
LEFT JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
WHERE r.restaurant_id IS NULL;

-- Basic business-rule checks
SELECT COUNT(*) AS invalid_order_amounts
FROM orders
WHERE subtotal < 0
   OR discount < 0
   OR delivery_fee < 0
   OR final_amount < 0;

SELECT COUNT(*) AS invalid_ratings
FROM feedback
WHERE food_rating NOT BETWEEN 1 AND 5
   OR delivery_rating NOT BETWEEN 1 AND 5;


-- ============================================================
-- 3. BUSINESS OVERVIEW
-- ============================================================

-- Q1. Overall business performance
SELECT
    COUNT(*) AS delivered_orders,
    COUNT(DISTINCT customer_id) AS active_customers,
    ROUND(SUM(final_amount), 2) AS total_revenue,
    ROUND(AVG(final_amount), 2) AS average_order_value
FROM orders
WHERE order_status = 'Delivered';

-- Q2. Cancellation rate
SELECT
    ROUND(
        SUM(order_status = 'Cancelled') * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM orders;

-- Q3. Monthly orders and revenue
SELECT
    DATE_FORMAT(order_datetime, '%Y-%m') AS month,
    COUNT(*) AS delivered_orders,
    ROUND(SUM(final_amount), 2) AS revenue
FROM orders
WHERE order_status = 'Delivered'
GROUP BY month
ORDER BY month;

-- Q4. Monthly revenue growth
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_datetime, '%Y-%m') AS month,
        SUM(final_amount) AS revenue
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY month
),
growth AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(revenue - previous_month_revenue, 2) AS revenue_change,
    ROUND(
        (revenue - previous_month_revenue) * 100.0
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS growth_rate_pct
FROM growth
ORDER BY month;


-- ============================================================
-- 4. CUSTOMER & RETENTION ANALYTICS
-- ============================================================

-- Q5. Membership performance
SELECT
    m.membership_name,
    COUNT(DISTINCT o.customer_id) AS active_customers,
    COUNT(o.order_id) AS delivered_orders,
    ROUND(SUM(o.final_amount), 2) AS revenue,
    ROUND(AVG(o.final_amount), 2) AS average_order_value
FROM memberships m
JOIN customers c
    ON m.membership_id = c.membership_id
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY m.membership_name
ORDER BY revenue DESC;

-- Q6. Repeat vs one-time customers
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS delivered_orders
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN delivered_orders = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percentage
FROM customer_orders
GROUP BY customer_type;

-- Q7. Repeat customer rate
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS delivered_orders
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
)
SELECT
    ROUND(
        SUM(delivered_orders > 1) * 100.0 / COUNT(*),
        2
    ) AS repeat_customer_rate
FROM customer_orders;

-- Q8. Top 10 customers by lifetime value
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS delivered_orders,
    ROUND(SUM(o.final_amount), 2) AS lifetime_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY lifetime_value DESC
LIMIT 10;

-- Q9. Customers with no delivered orders
SELECT
    c.customer_id,
    c.customer_name,
    c.signup_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
   AND o.order_status = 'Delivered'
WHERE o.order_id IS NULL;

-- Q10. Customers with declining activity / inactive customers
-- Business rule: inactive = no delivered order in the last 60 days
-- of the dataset observation period. This is a churn-risk indicator,
-- not a claim of permanent churn.
WITH customer_last_order AS (
    SELECT
        customer_id,
        MAX(order_datetime) AS last_order_date
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
),
observation AS (
    SELECT MAX(order_datetime) AS dataset_end_date
    FROM orders
)
SELECT
    COUNT(*) AS inactive_customers,
    ROUND(
        COUNT(*) * 100.0
        / (SELECT COUNT(*) FROM customer_last_order),
        2
    ) AS inactive_customer_rate
FROM customer_last_order c
CROSS JOIN observation o
WHERE c.last_order_date < DATE_SUB(o.dataset_end_date, INTERVAL 60 DAY);

-- Q11. Monthly active customers
SELECT
    DATE_FORMAT(order_datetime, '%Y-%m') AS month,
    COUNT(DISTINCT customer_id) AS monthly_active_customers
FROM orders
WHERE order_status = 'Delivered'
GROUP BY month
ORDER BY month;

-- Q12. Customers retained from the previous month
WITH monthly_customers AS (
    SELECT DISTINCT
        DATE_FORMAT(order_datetime, '%Y-%m') AS month,
        customer_id
    FROM orders
    WHERE order_status = 'Delivered'
),
monthly_active AS (
    SELECT
        month,
        COUNT(*) AS active_customers
    FROM monthly_customers
    GROUP BY month
),
retention AS (
    SELECT
        mc.month,
        ma.active_customers,
        prev_ma.active_customers AS previous_month_active,
        COUNT(DISTINCT CASE
            WHEN prev.customer_id IS NOT NULL THEN mc.customer_id
        END) AS retained_from_previous_month
    FROM monthly_customers mc
    JOIN monthly_active ma
        ON mc.month = ma.month
    LEFT JOIN monthly_customers prev
        ON prev.customer_id = mc.customer_id
       AND prev.month = DATE_FORMAT(
            DATE_SUB(
                STR_TO_DATE(CONCAT(mc.month, '-01'), '%Y-%m-%d'),
                INTERVAL 1 MONTH
            ),
            '%Y-%m'
       )
    LEFT JOIN monthly_active prev_ma
        ON prev_ma.month = DATE_FORMAT(
            DATE_SUB(
                STR_TO_DATE(CONCAT(mc.month, '-01'), '%Y-%m-%d'),
                INTERVAL 1 MONTH
            ),
            '%Y-%m'
       )
    GROUP BY
        mc.month,
        ma.active_customers,
        prev_ma.active_customers
)
SELECT
    month,
    active_customers,
    previous_month_active,
    retained_from_previous_month,
    ROUND(
        retained_from_previous_month * 100.0
        / NULLIF(previous_month_active, 0),
        2
    ) AS monthly_retention_rate
FROM retention
ORDER BY month;


-- ============================================================
-- 5. CITY & CUSTOMER SEGMENTATION
-- ============================================================

-- Q13. City revenue and AOV
SELECT
    ci.city_name,
    COUNT(o.order_id) AS delivered_orders,
    ROUND(SUM(o.final_amount), 2) AS revenue,
    ROUND(AVG(o.final_amount), 2) AS average_order_value
FROM cities ci
JOIN customers c
    ON ci.city_id = c.city_id
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY ci.city_name
ORDER BY revenue DESC;

-- Q14. Age group performance
SELECT
    CASE
        WHEN c.age BETWEEN 18 AND 25 THEN '18-25'
        WHEN c.age BETWEEN 26 AND 35 THEN '26-35'
        WHEN c.age BETWEEN 36 AND 45 THEN '36-45'
        ELSE '46+'
    END AS age_group,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(o.order_id) AS delivered_orders,
    ROUND(SUM(o.final_amount), 2) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY age_group
ORDER BY revenue DESC;


-- ============================================================
-- 6. RESTAURANT & SALES ANALYTICS
-- ============================================================

-- Q15. Top 10 restaurants by revenue
SELECT
    r.restaurant_id,
    r.restaurant_name,
    COUNT(o.order_id) AS delivered_orders,
    ROUND(SUM(o.final_amount), 2) AS revenue,
    ROUND(AVG(o.final_amount), 2) AS average_order_value
FROM restaurants r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
WHERE o.order_status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY revenue DESC
LIMIT 10;

-- Q16. Top cuisines by revenue
SELECT
    r.cuisine,
    COUNT(o.order_id) AS delivered_orders,
    ROUND(SUM(o.final_amount), 2) AS revenue
FROM restaurants r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
WHERE o.order_status = 'Delivered'
GROUP BY r.cuisine
ORDER BY revenue DESC;

-- Q17. Top 10 menu items by revenue
SELECT
    m.item_name,
    ROUND(SUM(oi.line_total), 2) AS revenue
FROM menu_items m
JOIN order_items oi
    ON m.item_id = oi.item_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY m.item_id, m.item_name
ORDER BY revenue DESC
LIMIT 10;

-- Q18. Top restaurant in each city
WITH restaurant_revenue AS (
    SELECT
        c.city_name,
        r.restaurant_name,
        SUM(o.final_amount) AS revenue,
        RANK() OVER (
            PARTITION BY c.city_name
            ORDER BY SUM(o.final_amount) DESC
        ) AS city_rank
    FROM orders o
    JOIN restaurants r
        ON o.restaurant_id = r.restaurant_id
    JOIN cities c
        ON r.city_id = c.city_id
    WHERE o.order_status = 'Delivered'
    GROUP BY c.city_name, r.restaurant_name
)
SELECT
    city_name,
    restaurant_name,
    ROUND(revenue, 2) AS revenue
FROM restaurant_revenue
WHERE city_rank = 1
ORDER BY revenue DESC;

-- Q19. Top 3 restaurants in every city
WITH restaurant_rank AS (
    SELECT
        c.city_name,
        r.restaurant_name,
        SUM(o.final_amount) AS revenue,
        DENSE_RANK() OVER (
            PARTITION BY c.city_name
            ORDER BY SUM(o.final_amount) DESC
        ) AS city_rank
    FROM restaurants r
    JOIN cities c
        ON r.city_id = c.city_id
    JOIN orders o
        ON r.restaurant_id = o.restaurant_id
    WHERE o.order_status = 'Delivered'
    GROUP BY c.city_name, r.restaurant_name
)
SELECT
    city_name,
    restaurant_name,
    ROUND(revenue, 2) AS revenue,
    city_rank
FROM restaurant_rank
WHERE city_rank <= 3
ORDER BY city_name, city_rank;


-- ============================================================
-- 7. DELIVERY & CUSTOMER EXPERIENCE
-- ============================================================

-- Q20. Overall delivery performance
SELECT
    COUNT(*) AS total_deliveries,
    ROUND(AVG(delivery_time_minutes), 2) AS average_delivery_time,
    ROUND(AVG(distance_km), 2) AS average_distance_km,
    ROUND(
        SUM(delivered_on_time = 'Yes') * 100.0 / COUNT(*),
        2
    ) AS on_time_delivery_rate
FROM deliveries;

-- Q21. Delivery time by distance bucket
SELECT
    CASE
        WHEN distance_km < 3 THEN 'Below 3 km'
        WHEN distance_km BETWEEN 3 AND 6 THEN '3-6 km'
        ELSE 'Above 6 km'
    END AS distance_bucket,
    COUNT(*) AS deliveries,
    ROUND(AVG(delivery_time_minutes), 2) AS average_delivery_time
FROM deliveries
GROUP BY distance_bucket
ORDER BY average_delivery_time;

-- Q22. Delivery time by weather
SELECT
    weather,
    COUNT(*) AS deliveries,
    ROUND(AVG(delivery_time_minutes), 2) AS average_delivery_time
FROM deliveries
GROUP BY weather
ORDER BY average_delivery_time DESC;

-- Q23. Does delivery time affect delivery ratings?
SELECT
    CASE
        WHEN d.delivery_time_minutes < 30 THEN 'Under 30 min'
        WHEN d.delivery_time_minutes BETWEEN 30 AND 45 THEN '30-45 min'
        ELSE 'Above 45 min'
    END AS delivery_bucket,
    COUNT(f.feedback_id) AS feedback_count,
    ROUND(AVG(f.delivery_rating), 2) AS average_delivery_rating,
    ROUND(
        SUM(f.complaint_flag = 'Yes') * 100.0
        / NULLIF(COUNT(f.feedback_id), 0),
        2
    ) AS complaint_rate
FROM deliveries d
JOIN feedback f
    ON d.order_id = f.order_id
GROUP BY delivery_bucket
ORDER BY average_delivery_rating;

-- Q24. Restaurants with the lowest delivery ratings
SELECT
    r.restaurant_name,
    COUNT(f.feedback_id) AS feedback_count,
    ROUND(AVG(f.delivery_rating), 2) AS average_delivery_rating
FROM restaurants r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
JOIN feedback f
    ON o.order_id = f.order_id
WHERE o.order_status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name
HAVING COUNT(f.feedback_id) >= 10
ORDER BY average_delivery_rating
LIMIT 10;

-- Q25. Restaurants with the highest complaint rate
SELECT
    r.restaurant_name,
    COUNT(f.feedback_id) AS feedback_count,
    SUM(f.complaint_flag = 'Yes') AS complaints,
    ROUND(
        SUM(f.complaint_flag = 'Yes') * 100.0
        / NULLIF(COUNT(f.feedback_id), 0),
        2
    ) AS complaint_rate
FROM restaurants r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
JOIN feedback f
    ON o.order_id = f.order_id
WHERE o.order_status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name
HAVING COUNT(f.feedback_id) >= 10
ORDER BY complaint_rate DESC
LIMIT 10;

-- Q26. Complaint rate by weather
SELECT
    d.weather,
    COUNT(f.feedback_id) AS feedback_count,
    SUM(f.complaint_flag = 'Yes') AS complaints,
    ROUND(
        SUM(f.complaint_flag = 'Yes') * 100.0
        / NULLIF(COUNT(f.feedback_id), 0),
        2
    ) AS complaint_rate
FROM deliveries d
JOIN feedback f
    ON d.order_id = f.order_id
GROUP BY d.weather
ORDER BY complaint_rate DESC;


-- ============================================================
-- 8. ADVANCED SQL / INTERVIEW-LEVEL ANALYSIS
-- ============================================================

-- Q27. Highest-value customer in each city
WITH customer_revenue AS (
    SELECT
        ci.city_name,
        c.customer_id,
        c.customer_name,
        SUM(o.final_amount) AS revenue,
        RANK() OVER (
            PARTITION BY ci.city_name
            ORDER BY SUM(o.final_amount) DESC
        ) AS city_rank
    FROM customers c
    JOIN cities ci
        ON c.city_id = ci.city_id
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Delivered'
    GROUP BY ci.city_name, c.customer_id, c.customer_name
)
SELECT
    city_name,
    customer_id,
    customer_name,
    ROUND(revenue, 2) AS revenue
FROM customer_revenue
WHERE city_rank = 1
ORDER BY city_name;

-- Q28. Cumulative revenue over time
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_datetime, '%Y-%m') AS month,
        SUM(final_amount) AS revenue
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY month
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        SUM(revenue) OVER (ORDER BY month),
        2
    ) AS cumulative_revenue
FROM monthly_sales
ORDER BY month;

-- Q29. Restaurants performing above their own city AOV
WITH restaurant_aov AS (
    SELECT
        c.city_id,
        c.city_name,
        r.restaurant_id,
        r.restaurant_name,
        AVG(o.final_amount) AS restaurant_aov
    FROM restaurants r
    JOIN cities c
        ON r.city_id = c.city_id
    JOIN orders o
        ON r.restaurant_id = o.restaurant_id
    WHERE o.order_status = 'Delivered'
    GROUP BY
        c.city_id,
        c.city_name,
        r.restaurant_id,
        r.restaurant_name
),
city_aov AS (
    SELECT
        c.city_id,
        AVG(o.final_amount) AS city_aov
    FROM cities c
    JOIN customers cu
        ON c.city_id = cu.city_id
    JOIN orders o
        ON cu.customer_id = o.customer_id
    WHERE o.order_status = 'Delivered'
    GROUP BY c.city_id
)
SELECT
    r.city_name,
    r.restaurant_name,
    ROUND(r.restaurant_aov, 2) AS restaurant_aov,
    ROUND(c.city_aov, 2) AS city_aov
FROM restaurant_aov r
JOIN city_aov c
    ON r.city_id = c.city_id
WHERE r.restaurant_aov > c.city_aov
ORDER BY r.city_name, r.restaurant_aov DESC;

-- Q30. Executive KPI summary
SELECT
    COUNT(*) AS delivered_orders,
    COUNT(DISTINCT customer_id) AS active_customers,
    ROUND(SUM(final_amount), 2) AS total_revenue,
    ROUND(AVG(final_amount), 2) AS average_order_value,
    ROUND(MAX(final_amount), 2) AS highest_order_value,
    ROUND(
        SUM(final_amount) / COUNT(DISTINCT customer_id),
        2
    ) AS revenue_per_active_customer
FROM orders
WHERE order_status = 'Delivered';

-- ============================================================
-- END OF ANALYSIS
-- ============================================================