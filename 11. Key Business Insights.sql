-- KEY BUSINESS INSIGHTS
-- pulling together the patterns that stood out most while going through the data

-- 1. Overall performance
-- the business made 431,502 in sales from 500 orders, with 23,955 in profit.
-- that works out to a 5.55% profit margin overall - profitable, but thin.

-- 2. Category performance
-- Clothing actually had the best profit margin (8.03%), even though Electronics
-- had the highest raw sales (165,267). Furniture is the weak spot here - it brought in
-- 127,181 in sales but only 2,298 profit, just a 1.81% margin. High sales clearly
-- doesn't automatically mean high profit.

-- 3. Loss-making transactions
-- 503 individual line items came in with negative profit. that's a meaningful chunk
-- of all transactions, and it's spread across specific sub-categories rather than
-- being random - Tables and Electronic Games are the two sub-categories dragging
-- this down the most.

-- 4. State-level performance
-- Madhya Pradesh had the highest total sales, but Maharashtra actually earned more profit.
-- West Bengal stood out with the best profit margin overall (17.75%) despite not being
-- a top seller - proportionally it's the most efficient state.
-- Tamil Nadu is the opposite story: -2,216 loss and a -36.41% margin, the weakest
-- state in the dataset by a clear margin. Bihar, Andhra Pradesh and Punjab were also
-- in the red.

-- 5. Customer performance
-- Yaanvi had the highest sales among top customers (9,177 from just 2 orders), but
-- Abhijeet was more profitable per order (1,562 profit from only 2 orders).
-- Pooja is a flag - 9,030 in sales across 5 orders but still ended up at a loss (-269).
-- more orders/sales from a customer doesn't guarantee they're actually profitable.

-- 6. Sales vs target (new finding after adding the target comparison query)
-- Clothing missed its target badly in July 2018, coming in 78.71% below what was
-- planned for that month. this was the single biggest month-category gap found in
-- the whole target comparison, worth flagging separately from the rest.
