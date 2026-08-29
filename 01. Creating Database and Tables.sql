-- creating the main database for this project
CREATE DATABASE IF NOT EXISTS ecommerce_sales;
USE ecommerce_sales;

-- 1. orders table - one row per order
CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE,
    customer_name VARCHAR(100),
    state VARCHAR(100),
    city VARCHAR(100)
);

-- 2. order_details table - one row per item inside an order
CREATE TABLE order_details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(20),
    amount DECIMAL(10,2),
    profit DECIMAL(10,2),
    quantity INT,
    category VARCHAR(50),
    sub_category VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 3. sales_targets table - monthly target per category
CREATE TABLE sales_targets (
    target_id INT AUTO_INCREMENT PRIMARY KEY,
    target_month DATE,
    category VARCHAR(50),
    target DECIMAL(10,2)
);

-- quick check that all 3 tables got created
SHOW TABLES;
