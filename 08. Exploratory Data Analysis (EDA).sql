USE ecommerce_sales;

-- exploring the data to find patterns, trends, and useful business information

-- overall business numbers
SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(od.amount) AS total_sales,
    SUM(od.profit) AS total_profit,
    SUM(od.quantity) AS total_quantity,
    ROUND(SUM(od.amount) / COUNT(DISTINCT o.order_id), 2) AS average_order_value
FROM orders o
JOIN order_details od ON o.order_id = od.order_id;

-- Basic Business Overview
-- Total orders = 500
-- Total sales = 431502.00
-- Total profit = 23955.00
-- Total quantity = 5615
-- Average order value = 863

-- which category performs best
SELECT
    od.category,
    SUM(od.amount) AS total_sales,
    SUM(od.profit) AS total_profit,
    SUM(od.quantity) AS total_quantity
FROM order_details od
GROUP BY od.category
ORDER BY total_sales DESC;

-- category      total_sales   total_profit    total_quantity
-- Electronics   165267.00     10494.00        1154
-- Clothing      139054.00     11163.00        3416
-- Furniture     127181.00     2298.00         945

-- sub-category performance
SELECT
    sub_category,
    SUM(amount) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity
FROM order_details
GROUP BY sub_category
ORDER BY total_sales DESC;

-- 17 sub-categories total
-- top 2 by sales: Printers, Bookcases
-- bottom 2 by sales: Leggings, Skirt

-- top 5 profitable sub-categories
SELECT sub_category, SUM(profit) AS total_profit
FROM order_details
GROUP BY sub_category
ORDER BY total_profit DESC
LIMIT 5;

-- sub_category   total_profit
-- Printers       5964.00
-- Bookcases      4888.00
-- Accessories    3559.00
-- Trousers       2847.00
-- Stole          2559.00

-- bottom 5 sub-categories
SELECT sub_category, SUM(profit) AS total_profit
FROM order_details
GROUP BY sub_category
ORDER BY total_profit ASC
LIMIT 5;

-- sub_category        total_profit
-- Tables               -4011.00
-- Electronic Games     -1236.00
-- Kurti                181.00
-- Skirt                235.00
-- Leggings             260.00

-- monthly sales & profit
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(od.amount) AS total_sales,
    SUM(od.profit) AS total_profit,
    SUM(od.quantity) AS total_quantity
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- highest sales month  = 2019-01, 61439.00
-- lowest sales month   = 2018-07, 12966.00
-- highest profit month = 2019-03, 10077.00
-- worst loss month     = 2018-09, -4963.00

-- sales & profit by state
SELECT
    o.state,
    SUM(od.amount) AS total_sales,
    SUM(od.profit) AS total_profit,
    SUM(od.quantity) AS total_quantity
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.state
ORDER BY total_sales DESC;

-- top 5 states by profit
SELECT o.state, SUM(od.profit) AS total_profit
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.state
ORDER BY total_profit DESC
LIMIT 5;

-- state            total_profit
-- Maharashtra      6176.00
-- Madhya Pradesh   5551.00
-- Uttar Pradesh    3237.00
-- Delhi            2987.00
-- West Bengal      2500.00

-- bottom 5 states by profit
SELECT o.state, SUM(od.profit) AS total_profit
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.state
ORDER BY total_profit ASC
LIMIT 5;

-- state              total_profit
-- Tamil Nadu         -2216.00
-- Punjab             -609.00
-- Andhra Pradesh     -496.00
-- Bihar              -321.00
-- Jammu and Kashmir  8.00

-- NEW: profit margin by state
-- sales alone don't tell the full story, a state can have decent sales but still be unprofitable
-- this shows profit as a % of sales for every state, which is a fairer comparison
SELECT
    o.state,
    SUM(od.amount) AS total_sales,
    SUM(od.profit) AS total_profit,
    ROUND(SUM(od.profit) / NULLIF(SUM(od.amount), 0) * 100, 2) AS profit_margin_percent
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.state
ORDER BY profit_margin_percent DESC;

-- West Bengal came out with the best margin at 17.75%, even though its total sales
-- weren't the highest overall - shows it's a more "efficient" state than the big sales leaders
-- Tamil Nadu was the worst at -36.41%, confirming it's not just a small loss, the margin itself is broken there

-- who are our most valuable customers
SELECT
    o.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(od.amount) AS total_sales,
    SUM(od.profit) AS total_profit
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- customer_name   total_orders   total_sales   total_profit
-- Yaanvi          2              9177.00       488.00
-- Pooja           5              9030.00       -269.00
-- Abhishek        5              8135.00       1314.00
-- Surabhi         4              6889.00       412.00
-- Soumya          3              6869.00       894.00
-- Harshal         1              6026.00       864.00
-- Priyanka        4              5762.00       1340.00
-- Shruti          4              5750.00       485.00
-- Abhijeet        2              5691.00       1562.00
-- Sarita          3              5449.00       1265.00

-- customers who placed more than one order
SELECT
    o.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(od.amount) AS total_sales,
    SUM(od.profit) AS total_profit
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.customer_name
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_orders DESC
LIMIT 5;

-- what % of total sales does each top customer contribute
WITH customer_sales AS (
    SELECT o.customer_name, SUM(od.amount) AS total_sales
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.customer_name
)
SELECT
    customer_name,
    total_sales,
    ROUND(total_sales / SUM(total_sales) OVER () * 100, 2) AS sales_contribution_percent
FROM customer_sales
ORDER BY total_sales DESC
LIMIT 5;

-- which sub-categories sell the most units
SELECT
    sub_category,
    SUM(quantity) AS total_quantity,
    SUM(amount) AS total_sales,
    SUM(profit) AS total_profit
FROM order_details
GROUP BY sub_category
ORDER BY total_quantity DESC;

-- top 5 by units sold: Saree, Hankerchief, Stole, Furnishings, T-shirt

-- sub-categories where total profit is negative
SELECT
    sub_category,
    SUM(amount) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity
FROM order_details
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

-- sub_category        total_sales   total_profit   total_quantity
-- Tables              22614.00      -4011.00       61
-- Electronic Games    39168.00      -1236.00       297

-- profit margin per category
SELECT
    category,
    SUM(amount) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(amount), 0) * 100, 2) AS profit_margin_percent
FROM order_details
GROUP BY category
ORDER BY profit_margin_percent DESC;

-- category      total_sales   total_profit   profit_margin_percent
-- Clothing      139054.00     11163.00       8.03
-- Electronics   165267.00     10494.00       6.35
-- Furniture     127181.00     2298.00        1.81

-- order-level profitability
SELECT
    o.order_id,
    o.customer_name,
    o.order_date,
    SUM(od.amount) AS order_sales,
    SUM(od.profit) AS order_profit,
    SUM(od.quantity) AS total_quantity
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id, o.customer_name, o.order_date
ORDER BY order_profit DESC
LIMIT 5;

-- order_id   customer_name   order_date    order_sales   order_profit   total_quantity
-- B-25973    Seema           2019-01-24    5228.00       1970.00        40
-- B-25855    Abhijeet        2018-11-08    4613.00       1432.00        32
-- B-25656    Priyanka        2018-05-11    3895.00       1021.00        43
-- B-26093    Sarita          2019-03-27    4502.00       1020.00        28
-- B-25761    Surabhi         2018-08-25    3339.00       984.00         28

-- NEW: sales vs target comparison, this table was created earlier but never actually used
-- joining actual monthly category sales against the target set for that month/category
WITH monthly_actual AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS month,
        od.category,
        SUM(od.amount) AS actual_sales
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01'), od.category
)
SELECT
    st.target_month,
    st.category,
    st.target,
    ma.actual_sales,
    ROUND((ma.actual_sales - st.target) / st.target * 100, 2) AS variance_percent
FROM sales_targets st
LEFT JOIN monthly_actual ma
    ON st.target_month = ma.month AND st.category = ma.category
ORDER BY variance_percent ASC;

-- the worst gap found: Clothing in July 2018 came in 78.71% below its target
-- this is the number referenced in the recommendations file, this query is what produces it
