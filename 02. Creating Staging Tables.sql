-- raw CSV data is messy, so instead of loading it directly into the real tables
-- we first dump it into staging tables and clean it there

USE ecommerce_sales;

-- 1. stg_orders - order_date kept as VARCHAR for now since the csv date format
-- doesn't match MySQL's DATE format, we'll fix that during insert later
CREATE TABLE stg_orders (
    order_id VARCHAR(20),
    order_date VARCHAR(20),
    customer_name VARCHAR(100),
    state VARCHAR(100),
    city VARCHAR(100)
);

-- 2. stg_order_details
CREATE TABLE stg_order_details (
    order_id VARCHAR(20),
    amount DECIMAL(10,2),
    profit DECIMAL(10,2),
    quantity INT,
    category VARCHAR(50),
    sub_category VARCHAR(100)
);

-- 3. stg_sales_targets - target_month also kept as VARCHAR, format is like "Apr-18"
CREATE TABLE stg_sales_targets (
    target_month VARCHAR(20),
    category VARCHAR(50),
    target DECIMAL(10,2)
);

SHOW TABLES;
