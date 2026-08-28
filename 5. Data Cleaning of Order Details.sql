-- DATA CLEANING - STEP 2: ORDER_DETAILS
-- earlier file just checked for problems, this one actually fixes them

USE ecommerce_sales;

-- checking for exact duplicate rows (same order_id, amount, profit, qty, category, sub_category)
SELECT
    order_id, amount, profit, quantity, category, sub_category,
    COUNT(*) AS duplicate_count
FROM stg_order_details
GROUP BY order_id, amount, profit, quantity, category, sub_category
HAVING COUNT(*) > 1;

-- if the query above returns any rows, run this to actually remove the duplicates
-- (keeps one copy of each row, drops the rest)
CREATE TABLE stg_order_details_temp AS
SELECT DISTINCT * FROM stg_order_details;

TRUNCATE TABLE stg_order_details;

INSERT INTO stg_order_details
SELECT * FROM stg_order_details_temp;

DROP TABLE stg_order_details_temp;

-- sanity check on numeric columns - looking for anything that shouldn't be possible
-- (negative amount, zero/negative quantity)
SELECT
    SUM(amount < 0) AS negative_amount,
    SUM(quantity <= 0) AS invalid_quantity,
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount,
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity
FROM stg_order_details;

-- note on profit: profit going negative is NOT bad data, it's a real loss on that sale
-- so we are NOT deleting negative profit rows, they're a genuine part of the business story
SELECT COUNT(*) AS loss_making_records
FROM stg_order_details
WHERE profit < 0;          -- 503 loss making records

SELECT COUNT(*) AS zero_profit_records
FROM stg_order_details
WHERE profit = 0;          -- 47 zero profit records

-- final row count after de-duping
SELECT COUNT(*) AS rows_after_cleaning FROM stg_order_details;
