USE ecommerce_sales;

-- loading List-of-Orders data
-- (update the path below to wherever the csv is saved on your system)
LOAD DATA LOCAL INFILE 'D:/Downloads/List-of-Orders.csv'
INTO TABLE stg_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- loading order_details data
LOAD DATA LOCAL INFILE 'D:/Downloads/Order-Details.csv'
INTO TABLE stg_order_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- loading sales target data
LOAD DATA LOCAL INFILE 'D:/Downloads/Sales-target.csv'
INTO TABLE stg_sales_targets
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- checking raw row counts before doing anything else
SELECT COUNT(*) AS total_rows FROM stg_orders;          -- 560 rows
SELECT COUNT(*) AS total_rows FROM stg_order_details;    -- 1500 rows
SELECT COUNT(*) AS total_rows FROM stg_sales_targets;    -- 36 rows
