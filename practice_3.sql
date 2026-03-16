CREATE TABLE products (
product_id INT PRIMARY KEY,
product_name VARCHAR(50),
category VARCHAR(50),
price INT
);

CREATE TABLE orders (
order_id INT PRIMARY KEY,
order_date DATE
);

CREATE TABLE order_items (
order_item_id INT PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT,
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products VALUES
(101,'Laptop','Electronics',1200),
(102,'Phone','Electronics',900),
(103,'Headphones','Electronics',200),
(104,'Desk','Furniture',300),
(105,'Chair','Furniture',150),
(106,'Tablet','Electronics',600);

INSERT INTO orders VALUES
(1,'2024-01-01'),
(2,'2024-01-02'),
(3,'2024-01-03'),
(4,'2024-01-04'),
(5,'2024-01-05');

INSERT INTO order_items VALUES
(1,1,101,1),
(2,1,102,2),
(3,2,105,1),
(4,3,101,1),
(5,3,103,3),
(6,4,104,1),
(7,5,102,1),
(8,5,106,2);

-- TASK 1
-- Daily Sales per Category

SELECT o.order_date,p.category,
SUM(p.price * oi.quantity) AS daily_sales
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON p.product_id = oi.product_id
GROUP BY o.order_date,p.category;


-- TASK 2
-- Find Top Product Category (CTE)

WITH category_sales AS (
SELECT
category,
SUM(p.price * oi.quantity) AS total_sales
FROM order_items oi
JOIN products p
ON p.product_id = oi.product_id
GROUP BY category
)
SELECT category
FROM category_sales
ORDER BY total_sales DESC
LIMIT 1;


-- TASK 3
-- Combine Daily Sales + Top Category + Rolling Avg


WITH daily_sales AS (
  SELECT
    o.order_date,
    p.category,
    SUM(p.price * oi.quantity) AS sales
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN products p ON oi.product_id = p.product_id
  GROUP BY o.order_date, p.category
),
top_category AS (
  SELECT category
  FROM daily_sales
  GROUP BY category
  ORDER BY SUM(sales) DESC
  LIMIT 1
)
SELECT
d.order_date,
d.category,
d.sales,
ROUND(
  AVG(d.sales) OVER(
    PARTITION BY d.category
    ORDER BY d.order_date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ),2
) AS rolling_avg_3days
FROM daily_sales d
JOIN top_category t
ON d.category = t.category;