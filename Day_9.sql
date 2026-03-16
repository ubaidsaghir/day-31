CREATE TABLE employee_performance (
emp_id INT,
emp_name VARCHAR(50),
department VARCHAR(50),
sales_amount INT,
sale_month DATE
);


INSERT INTO employee_performance VALUES
(1,'Sarah','Sales',5000,'2024-01-01'),
(2,'Mike','Sales',3500,'2024-01-01'),
(3,'Elena','Marketing',4000,'2024-01-01'),
(4,'David','Marketing',4200,'2024-01-01'),

(1,'Sarah','Sales',6200,'2024-02-01'),
(2,'Mike','Sales',3800,'2024-02-01'),
(3,'Elena','Marketing',4100,'2024-02-01'),
(4,'David','Marketing',4500,'2024-02-01'),

(1,'Sarah','Sales',5800,'2024-03-01'),
(2,'Mike','Sales',3900,'2024-03-01'),
(3,'Elena','Marketing',4300,'2024-03-01'),
(4,'David','Marketing',4700,'2024-03-01');


-- TASK 1
-- 1. The Ranking Challenge
-- The Prompt: "Within each department, 
-- I want to see a list of employees ranked by their sales_amount (highest to lowest). Use the RANK() function. The output should show the department, employee name, sales, and their rank."
-- Goal: Test OVER(PARTITION BY ... ORDER BY ...).


SELECT
emp_name,
department,
sales_amount,
RANK() OVER(PARTITION BY department
ORDER BY sales_amount DESC)
AS sales_rank
FROM employee_performance;


-- Task 2
-- 2. The Running Total (Cumulative)
-- The Prompt: "Pick one employee (e.g., Sarah). 
-- Write a query that shows her sale_month, sales_amount, and a third column showing her Running Total of sales as the months progress."
-- Goal: Test the default windowing behavior of SUM() OVER().

SELECT 
sale_month,
sales_amount,
SUM(sales_amount) OVER(ORDER BY sale_month
) AS running_total
FROM employee_performance
WHERE emp_name = 'Sarah';

-- Task 3
-- 3. The Comparison (Month-over-Month)
-- The Prompt: "For every employee,
-- show their current month's sales_amount and the sales_amount from the previous month in a column called prev_month_sales. (Hint: Use LAG())."
-- Goal: Test the ability to look at previous rows without a self-join.

SELECT
emp_name,
sale_month,
sales_amount,
LAG(sales_amount) OVER(PARTITION BY emp_id
ORDER BY sale_month) AS prev_month_sales
FROM employee_performance;


-- Task 4
-- 4. The CTE Cleanup
-- The Prompt: "Create a CTE called HighPerformers that only includes sales records over $5,000. Then, in your main query, use that CTE to find the average sale amount for these top-tier records per department."
-- Goal: Test WITH clause syntax and readability.

WITH HighPerformers AS(
SELECT *
FROM employee_performance
WHERE sales_amount >5000
)
SELECT
department,
ROUND(AVG(sales_amount),2) 
AS avg_sales
FROM HighPerformers
GROUP BY department;

