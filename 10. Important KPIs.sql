USE ecommerce_sales;

-- pulling together the core numbers a manager would actually want to see on one page

-- 1. Total Sales
SELECT SUM(amount) AS total_sales FROM order_details;
-- 431502.00

-- 2. Total Profit
SELECT SUM(profit) AS total_profit FROM order_details;
-- 23955.00

-- 3. Overall Profit Margin
SELECT ROUND(SUM(profit) / SUM(amount) * 100, 2) AS profit_margin_percent
FROM order_details;
-- 5.55%

-- 4. Average Order Value
SELECT ROUND(SUM(od.amount) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN order_details od ON o.order_id = od.order_id;
-- 863.00

-- 5. Total Orders
SELECT COUNT(DISTINCT order_id) AS total_orders FROM orders;
-- 500

-- 6. Best Performing Category (by sales)
SELECT category, SUM(amount) AS total_sales
FROM order_details
GROUP BY category
ORDER BY total_sales DESC
LIMIT 1;
-- Electronics, 165267.00

-- 7. Most Profitable Category (by margin, not just raw sales)
SELECT
    category,
    ROUND(SUM(profit) / SUM(amount) * 100, 2) AS profit_margin_percent
FROM order_details
GROUP BY category
ORDER BY profit_margin_percent DESC
LIMIT 1;
-- Clothing, 8.03%
-- worth noting this is different from the "best selling" category above,
-- Electronics sells more but Clothing is actually more profitable per rupee of sales
