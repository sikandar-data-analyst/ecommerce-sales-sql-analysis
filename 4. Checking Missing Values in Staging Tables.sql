-- DATA CLEANING - STEP 1: FIND THE PROBLEMS FIRST
-- before fixing anything, checking each staging table to see what's actually wrong with it

-- how many completely blank order_id rows in stg_orders?
SELECT COUNT(*) AS blank_rows
FROM stg_orders
WHERE order_id IS NULL OR TRIM(order_id) = '';   -- 60 blank rows

-- missing values column by column in stg_orders
SELECT
    SUM(order_id IS NULL OR TRIM(order_id) = '') AS missing_order_id,
    SUM(order_date IS NULL OR TRIM(order_date) = '') AS missing_order_date,
    SUM(customer_name IS NULL OR TRIM(customer_name) = '') AS missing_customer,
    SUM(state IS NULL OR TRIM(state) = '') AS missing_state,
    SUM(city IS NULL OR TRIM(city) = '') AS missing_city
FROM stg_orders;

-- missing values in stg_order_details
SELECT
    SUM(order_id IS NULL OR TRIM(order_id) = '') AS missing_order_id,
    SUM(amount IS NULL) AS missing_amount,
    SUM(profit IS NULL) AS missing_profit,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(category IS NULL OR TRIM(category) = '') AS missing_category,
    SUM(sub_category IS NULL OR TRIM(sub_category) = '') AS missing_sub_category
FROM stg_order_details;

-- missing values in stg_sales_targets
SELECT
    SUM(target_month IS NULL OR TRIM(target_month) = '') AS missing_month,
    SUM(category IS NULL OR TRIM(category) = '') AS missing_category,
    SUM(target IS NULL) AS missing_target
FROM stg_sales_targets;

-- note: the 60 blank order_id rows in stg_orders are the reason our final
-- orders table ends up with 500 rows instead of 560. those rows get dropped
-- during the insert step later since we can't keep an order with no id.
