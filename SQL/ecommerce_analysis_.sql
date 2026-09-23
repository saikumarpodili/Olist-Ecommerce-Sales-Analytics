use olist_ecommerece;
select count(*) from orders;

CREATE TABLE orders (
    order_id VARCHAR(32),
    customer_id VARCHAR(32),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);
show tables;

show global variables like 'local_infile';
SET GLOBAL local_infile = 1;



use olist_ecommerce;
select count(*) from orders;

select count(distinct(customer_unique_id)) from customers;

desc payments;

select round(sum(payment_value)) as total_revenue from payments;

select avg(payment_value) from payments;

select payment_type, count(*) from payments
group by payment_type;
desc orders;


select order_status, count(*) from orders
group by order_status;

desc customers;
select customer_state ,count(*) from customers
group by customer_state;

select payment_type, sum(payment_value) from payments
group by payment_type;

select date_format (order_purchase_timestamp, '%y-%m') as order_month, count(*) as total_orders from orders
group by order_month
order by order_month;

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;

SELECT COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;

SELECT ROUND(SUM(payment_value), 2) AS total_revenue
FROM payments;
SELECT 
    ROUND(SUM(payment_value) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM payments;

SELECT 
    payment_type,
    COUNT(*) AS payment_count
FROM payments
GROUP BY payment_type
ORDER BY payment_count DESC;

SELECT 
    payment_type,
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM payments
GROUP BY payment_type
ORDER BY total_revenue DESC;

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY order_month
ORDER BY order_month;

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
    ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM orders AS o
JOIN payments AS p
    ON o.order_id = p.order_id
GROUP BY order_month
ORDER BY order_month;

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items AS oi
JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    seller_id,
    ROUND(SUM(price), 2) AS total_sales
FROM order_items
GROUP BY seller_id
ORDER BY total_sales DESC
LIMIT 10;


SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;

SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ), 2
    ) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

SELECT
    ROUND(
        100.0 * SUM(
            CASE
                WHEN order_delivered_customer_date >
                     order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS late_delivery_percentage
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;
  
  SELECT
    review_score,
    COUNT(*) AS review_count
FROM reviews
GROUP BY review_score
ORDER BY review_score;

SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        c.customer_unique_id
    FROM orders AS o
    JOIN customers AS c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(DISTINCT o.order_id) > 1
) AS repeat_customer_list;