-- DATA CLEANING - STEP 3: SALES_TARGETS

USE ecommerce_sales;

-- checking missing values again just for this table specifically
SELECT
    SUM(target_month IS NULL OR TRIM(target_month) = '') AS missing_month,
    SUM(category IS NULL OR TRIM(category) = '') AS missing_category,
    SUM(target IS NULL) AS missing_target
FROM stg_sales_targets;

-- checking for duplicate target rows (same month + category shouldn't repeat)
SELECT
    target_month, category, COUNT(*) AS record_count
FROM stg_sales_targets
GROUP BY target_month, category
HAVING COUNT(*) > 1;

-- if duplicates show up above, this removes them the same way we did for order_details
CREATE TABLE stg_sales_targets_temp AS
SELECT DISTINCT * FROM stg_sales_targets;

TRUNCATE TABLE stg_sales_targets;

INSERT INTO stg_sales_targets
SELECT * FROM stg_sales_targets_temp;

DROP TABLE stg_sales_targets_temp;

-- making sure target values actually make sense (no zero or negative targets)
SELECT
    MIN(target) AS min_target,
    MAX(target) AS max_target,
    SUM(target <= 0) AS invalid_targets
FROM stg_sales_targets;

-- confirming category names are consistent (no typos/extra spaces creating "fake" new categories)
SELECT DISTINCT category
FROM stg_sales_targets
ORDER BY category;
