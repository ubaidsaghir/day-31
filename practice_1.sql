CREATE TABLE customers (
customer_id INT PRIMARY KEY,
customer_name VARCHAR(50),
city VARCHAR(50),
signup_date DATE
);


INSERT INTO customers VALUES
(1,'Ali','Karachi','2023-01-10'),
(2,'Sara','Lahore','2023-02-15'),
(3,'Ahmed','Islamabad','2023-03-20'),
(4,'Fatima','Karachi','2023-04-05'),
(5,'Usman','Lahore','2023-05-01'),
(6,'Hassan','Multan','2023-06-12');


CREATE TABLE products (
product_id INT PRIMARY KEY,
product_name VARCHAR(50),
category VARCHAR(50),
price INT
);

INSERT INTO products VALUES
(101,'Laptop','Electronics',1200),
(102,'Phone','Electronics',900),
(103,'Headphones','Electronics',200),
(104,'Desk','Furniture',300),
(105,'Chair','Furniture',150),
(106,'Tablet','Electronics',600);


CREATE TABLE orders (
order_id INT PRIMARY KEY,
customer_id INT,
order_date DATE,

FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
);


INSERT INTO orders VALUES
(1,1,'2024-01-01'),
(2,2,'2024-01-02'),
(3,1,'2024-01-03'),
(4,3,'2024-01-05'),
(5,4,'2024-01-06'),
(6,2,'2024-01-07'),
(7,5,'2024-01-08');


CREATE TABLE order_items (
order_item_id INT PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT,
FOREIGN KEY (order_id)
REFERENCES orders(order_id),
FOREIGN KEY (product_id)
REFERENCES products(product_id)
);


INSERT INTO order_items VALUES
(1,1,101,1),
(2,1,103,2),
(3,2,102,1),
(4,3,105,3),
(5,4,104,1),
(6,5,101,1),
(7,6,106,2),
(8,7,102,1),
(9,7,103,1);



-- Task 1
-- Show:
-- customer_name
-- order_id
-- order_date

SELECT c.customer_name,o.order_id,o.order_date
FROM orders o
JOIN customers c
ON c.customer_id = o.customer_id;


-- Task 2
-- Show:
-- customer_name
-- product_name
-- quantity


SELECT c.customer_name,p.product_name,oi.quantity
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON p.product_id = oi.product_id;


-- Task 3
-- Find customers who never placed an order.

SELECT 
c.customer_id,
c.customer_name,
o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Task 4
-- Find total sales amount per order.

SELECT o.order_id, 
SUM(p.price * oi.quantity) AS total_sales
FROM orders o
JOIN order_items oi
ON oi.order_id = o.order_id
JOIN products p
ON p.product_id = oi.product_id
GROUP BY o.order_id
ORDER BY o.order_id;


-- Task 5
-- Rank products by total revenue.
-- Use:
-- SUM()
-- RANK()


SELECT p.product_name,
SUM(p.price * oi.quantity) AS total_revenue,
RANK() OVER(ORDER BY SUM(p.price * oi.quantity)DESC)
AS revenue_rank
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name;


-- Task 6
-- Rank each customer's orders by date


SELECT o.order_id,
c.customer_name,
o.order_date,
ROW_NUMBER() OVER(PARTITION BY c.customer_id
ORDER BY o.order_date)AS order_rank
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id;


-- Task 7
-- Find previous order date

SELECT customer_id,
order_id,
order_date,
LAG(order_date) OVER(PARTITION BY customer_id
ORDER BY order_date) AS previous_order
FROM orders;


-- Task 8
-- Find next order date

SELECT customer_id,
order_id,
order_date,
LEAD(order_date) OVER(PARTITION BY customer_id
ORDER BY order_date) AS next_order
FROM orders;


-- Task 9
-- CTE-Total sales per product


WITH product_sale AS(
SELECT
p.product_name,
SUM(p.price * oi.quantity) AS total_sales
FROM products p
JOIN order_items oi
ON p.product_id= oi.product_id
GROUP BY p.product_name
)
SELECT *
FROM product_sale
WHERE total_sales > 1000
ORDER BY total_sales DESC;


-- TASK 10
-- Top spending customer(CTE + Wndow Function)

WITH customer_sales AS (
SELECT c.customer_name,
SUM(p.price * oi.quantity) AS total_spending
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON p.product_id = oi.product_id
GROUP BY c.customer_name
)
SELECT 
customer_name,
total_spending,
RANK() OVER(ORDER BY total_spending DESC) AS spending_rank
FROM customer_sales
LIMIT 1;