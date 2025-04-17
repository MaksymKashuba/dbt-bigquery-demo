WITH customers AS (
    SELECT id,
           first_name,
           last_name
    FROM `dbt-tutorial.jaffle_shop.customers`
),
orders AS (
    SELECT id,
           user_id,
           order_date,
           status
    FROM `dbt-tutorial.jaffle_shop.orders`
),
customer_orders AS (
    SELECT c.id AS customer_id,
           c.first_name,
           c.last_name,
           o.id AS order_id,
           o.order_date,
           o.status
    FROM customers c
    LEFT JOIN orders o ON c.id = o.user_id
)
SELECT customer_id,
       first_name,
       last_name,
       order_id,
       order_date,
       status
FROM customer_orders
WHERE order_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
  AND status = 'completed'