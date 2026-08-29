USE ecommerce_sales;

-- loading clean data into orders from stg_orders
-- skipping the 60 blank order_id rows we found earlier, can't insert an order with no id
INSERT INTO orders (order_id, order_date, customer_name, state, city)
SELECT
    order_id,
    STR_TO_DATE(order_date, '%d-%m-%Y'),
    TRIM(customer_name),
    TRIM(state),
    TRIM(city)
FROM stg_orders
WHERE TRIM(order_id) <> '';

-- double check no duplicate order ids made it through
SELECT order_id, COUNT(*) AS order_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;          -- none found

-- loading clean order_details
-- (already deduped in the previous file, so this is a straight insert)
INSERT INTO order_details (order_id, amount, profit, quantity, category, sub_category)
SELECT
    TRIM(order_id),
    amount,
    profit,
    quantity,
    TRIM(category),
    TRIM(sub_category)
FROM stg_order_details;

-- loading clean sales_targets
-- target_month comes in as something like "Apr-18" so we need to convert it to a real date
SELECT * FROM stg_sales_targets LIMIT 10;

DESCRIBE sales_targets;

-- checking the date conversion logic before actually inserting
SELECT
    target_month,
    STR_TO_DATE(
        CONCAT(
            CASE LEFT(target_month, 3)
                WHEN 'Jan' THEN '01' WHEN 'Feb' THEN '02' WHEN 'Mar' THEN '03'
                WHEN 'Apr' THEN '04' WHEN 'May' THEN '05' WHEN 'Jun' THEN '06'
                WHEN 'Jul' THEN '07' WHEN 'Aug' THEN '08' WHEN 'Sep' THEN '09'
                WHEN 'Oct' THEN '10' WHEN 'Nov' THEN '11' WHEN 'Dec' THEN '12'
            END,
            '-01-', RIGHT(target_month, 2)
        ), '%m-%d-%y'
    ) AS converted_date
FROM stg_sales_targets
LIMIT 10;          -- e.g. Apr-18 becomes 2018-04-01, looks correct

-- now actually inserting with the converted date
INSERT INTO sales_targets (target_month, category, target)
SELECT
    STR_TO_DATE(
        CONCAT(
            CASE LEFT(TRIM(target_month), 3)
                WHEN 'Jan' THEN '01' WHEN 'Feb' THEN '02' WHEN 'Mar' THEN '03'
                WHEN 'Apr' THEN '04' WHEN 'May' THEN '05' WHEN 'Jun' THEN '06'
                WHEN 'Jul' THEN '07' WHEN 'Aug' THEN '08' WHEN 'Sep' THEN '09'
                WHEN 'Oct' THEN '10' WHEN 'Nov' THEN '11' WHEN 'Dec' THEN '12'
            END,
            '-01-', RIGHT(TRIM(target_month), 2)
        ), '%m-%d-%y'
    ),
    TRIM(category),
    target
FROM stg_sales_targets;

-- final row counts to confirm everything loaded properly
SELECT COUNT(*) AS total_orders FROM orders;                 -- 500 rows
SELECT COUNT(*) AS total_order_details FROM order_details;   -- 1500 rows
SELECT COUNT(*) AS total_targets FROM sales_targets;          -- 36 rows
