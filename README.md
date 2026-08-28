# E-commerce Sales Analysis (MySQL)

## What this project is about

I wanted to practice going through a full analyst workflow using just SQL - no Power BI
or Excel dashboard, just queries. The data is order-level e-commerce data (orders,
order line items, and monthly sales targets by category), and the goal was to clean it,
explore it, and pull out insights and recommendations a business could actually act on.

## What I did, step by step

1. Created the database and staging tables
2. Imported the raw CSVs into staging tables
3. Checked for missing values, duplicates, and bad data
4. Cleaned the staging tables and loaded proper data into the final tables
5. Ran exploratory queries to understand overall sales, profit, and trends
6. Wrote advanced SQL queries (CTEs, window functions, subqueries) to answer
   specific business questions
7. Pulled together the key KPIs
8. Summarized the insights and wrote recommendations based on them

## Tools used

MySQL, plus Excel just for the original raw CSV files.

## Key KPIs

- Total Orders: 500
- Total Sales: ₹431,502
- Total Profit: ₹23,955
- Overall Profit Margin: 5.55%
- Average Order Value: ₹863
- Best Selling Category: Electronics
- Most Profitable Category (by margin): Clothing

## What stood out to me

- Electronics sells the most, but Clothing is actually the more profitable category
  per rupee of sales. Sales volume and profitability aren't the same thing.
- Furniture is the weak link - decent sales, barely any profit.
- West Bengal runs the best profit margin of any state, even though it's not a top
  seller by volume.
- Tamil Nadu is the clear underperformer - it's actually losing money overall.
- Clothing missed its sales target badly in July 2018 (78.71% under target) -
  the target data had been sitting unused until I went back and actually joined it
  against real sales.

## Files in this project

1. Creating Database and Tables.sql
2. Creating Staging Tables.sql
3. Importing Data from Local Files.sql
4. Checking Missing Values in Staging Tables.sql
5. Data Cleaning of Order Details.sql
6. Data Cleaning of Sales Targets.sql
7. Inserting Clean Data into Main Tables.sql
8. Exploratory Data Analysis (EDA).sql
9. Advanced SQL for Real Business Questions.sql
10. Important KPIs.sql
11. Key Business Insights.sql
12. Recommendations.sql

## Notes for anyone re-running this

The raw CSV file paths in file 3 point to a local folder on my machine - update those
paths before running `LOAD DATA LOCAL INFILE` on a different system. Also depending on
your MySQL setup you may need to enable `local_infile` for that step to work.
