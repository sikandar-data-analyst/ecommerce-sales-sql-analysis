USE ecommerce_sales;

-- each query below answers a specific business question using CTEs, subqueries and window functions

-- 1. which sub-categories generate the most profit (CTE)
WITH subcategory_performance AS (
    SELECT sub_category, SUM(amount) AS total_sales, SUM(profit) AS total_profit
    FROM order_details
    GROUP BY sub_category
)
SELECT sub_category, total_sales, total_profit
FROM subcategory_performance
ORDER BY total_profit DESC
LIMIT 5;

-- sub_category   total_sales   total_profit
-- Printers       58252.00      5964.00
-- Bookcases      56861.00      4888.00
-- Accessories    21728.00      3559.00
-- Trousers       30039.00      2847.00
-- Stole          18546.00      2559.00

-- 2. which sub-categories have profit above the overall average sub-category profit (subquery)
SELECT sub_category, SUM(profit) AS total_profit
FROM order_details
GROUP BY sub_category
HAVING SUM(profit) > (
    SELECT AVG(subcategory_profit)
    FROM (
        SELECT sub_category, SUM(profit) AS subcategory_profit
        FROM order_details
        GROUP BY sub_category
    ) AS subcategory_summary
)
ORDER BY total_profit DESC;

-- 8 sub-categories came out above average, topped by Printers and Bookcases

-- 3. bucketing sub-categories into High Profit / Moderate Profit / Loss (CASE WHEN)
SELECT
    sub_category,
    SUM(profit) AS total_profit,
    CASE
        WHEN SUM(profit) >= 5000 THEN 'High Profit'
        WHEN SUM(profit) >= 0 THEN 'Moderate Profit'
        ELSE 'Loss'
    END AS profit_category
FROM order_details
GROUP BY sub_category
ORDER BY total_profit DESC;

-- only Printers hit "High Profit", 15 sub-categories were "Moderate", and
-- Tables + Electronic Games were the only two actually making a loss

-- 4. best sub-category within each category, based on profit (ROW_NUMBER)
WITH subcategory_profit AS (
    SELECT category, sub_category, SUM(profit) AS total_profit
    FROM order_details
    GROUP BY category, sub_category
),
ranked_subcategories AS (
    SELECT
        category, sub_category, total_profit,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_profit DESC) AS profit_rank
    FROM subcategory_profit
)
SELECT category, sub_category, total_profit, profit_rank
FROM ranked_subcategories
WHERE profit_rank = 1
ORDER BY category;

-- category      sub_category   total_profit   profit_rank
-- Clothing      Trousers       2847.00        1
-- Electronics   Printers       5964.00        1
-- Furniture     Bookcases      4888.00        1

-- 5. ranking all sub-categories by profit, showing how ties would be handled (RANK)
WITH subcategory_profit AS (
    SELECT sub_category, SUM(profit) AS total_profit
    FROM order_details
    GROUP BY sub_category
)
SELECT
    sub_category, total_profit,
    RANK() OVER (ORDER BY total_profit DESC) AS profit_rank
FROM subcategory_profit
ORDER BY profit_rank;

-- 6. same ranking but with DENSE_RANK, to compare the difference against RANK()
WITH subcategory_profit AS (
    SELECT sub_category, SUM(profit) AS total_profit
    FROM order_details
    GROUP BY sub_category
)
SELECT
    sub_category, total_profit,
    DENSE_RANK() OVER (ORDER BY total_profit DESC) AS profit_rank
FROM subcategory_profit
ORDER BY profit_rank;

-- 7. how profit changed month over month (LAG)
WITH monthly_profit AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(od.profit) AS total_profit
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT
    month,
    total_profit,
    LAG(total_profit) OVER (ORDER BY month) AS previous_month_profit,
    ROUND(total_profit - LAG(total_profit) OVER (ORDER BY month), 2) AS profit_change
FROM monthly_profit
ORDER BY month;

-- business was in the red every month until 2018-10, then flipped positive
-- and stayed mostly positive from there, biggest single jump was Oct to Nov 2018 (+8526)

-- 8. comparing this month's sales against next month's (LEAD)
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(od.amount) AS total_sales
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT
    month,
    total_sales,
    LEAD(total_sales) OVER (ORDER BY month) AS next_month_sales,
    ROUND(LEAD(total_sales) OVER (ORDER BY month) - total_sales, 2) AS sales_change_next_month
FROM monthly_sales
ORDER BY month;

-- 9. running total of sales month by month (window function + CTE)
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(od.amount) AS total_sales
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT
    month,
    total_sales,
    SUM(total_sales) OVER (ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_sales
FROM monthly_sales
ORDER BY month;

-- running total confirms the final number matches our overall total sales KPI (431502.00)

-- 10. what % of total sales does each category contribute
WITH category_sales AS (
    SELECT category, SUM(amount) AS total_sales
    FROM order_details
    GROUP BY category
)
SELECT
    category,
    total_sales,
    ROUND(total_sales / SUM(total_sales) OVER () * 100, 2) AS sales_contribution_percent
FROM category_sales
ORDER BY total_sales DESC;

-- category      total_sales   sales_contribution_percent
-- Electronics   165267.00     38.30
-- Clothing      139054.00     32.23
-- Furniture     127181.00     29.47
