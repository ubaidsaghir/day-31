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









-- Task 10
-- 3-day rolling average sales
WITH daily_sales AS (

SELECT
o.order_date,
p.category,
SUM(p.price * oi.quantity) AS sales
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY o.order_date, p.category

)

SELECT
order_date,
category,
sales,
ROUND(
AVG(sales) OVER(
PARTITION BY category
ORDER BY order_date
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
),2) AS rolling_avg_3days
FROM daily_sales;