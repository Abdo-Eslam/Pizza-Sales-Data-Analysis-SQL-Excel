 -- ============================================================
--           PIZZA SALES ANALYSIS - SQL QUERIES
--           Database: SQL Server
--           Table: pizza_sales
-- ============================================================


-- ============================================================
-- A. KEY PERFORMANCE INDICATORS (KPIs)
-- ============================================================

-- 1. Total Revenue
-- Returns the total income generated from all pizza sales.
SELECT SUM(total_price) AS Total_Revenue 
FROM pizza_sales;


-- 2. Average Order Value
-- Returns the average amount spent per order.
-- Calculated by dividing total revenue by number of distinct orders.
SELECT (SUM(total_price) / COUNT(DISTINCT order_id)) AS Avg_Order_Value 
FROM pizza_sales;


-- 3. Total Pizzas Sold
-- Returns the total number of pizzas sold across all orders.
SELECT SUM(quantity) AS Total_Pizza_Sold 
FROM pizza_sales;


-- 4. Total Orders
-- Returns the total number of unique orders placed.
SELECT COUNT(DISTINCT order_id) AS Total_Orders 
FROM pizza_sales;


-- 5. Average Pizzas Per Order
-- Returns the average number of pizzas included in each order.
-- Uses DECIMAL casting to get a precise result.
SELECT 
    CAST(
        CAST(SUM(quantity) AS DECIMAL(10,2)) / 
        CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) 
    AS DECIMAL(10,2)) AS Avg_Pizzas_Per_Order
FROM pizza_sales;


-- ============================================================
-- B. DAILY TREND FOR TOTAL ORDERS
-- ============================================================

-- Shows how many orders were placed on each day of the week.
-- Helps identify the busiest days for the restaurant.
SELECT 
    DATENAME(DW, order_date) AS Order_Day, 
    COUNT(DISTINCT order_id) AS Total_Orders 
FROM pizza_sales
GROUP BY DATENAME(DW, order_date);


-- ============================================================
-- C. HOURLY TREND FOR ORDERS
-- ============================================================

-- Shows order volume for each hour of the day.
-- Useful for identifying peak hours and planning staff schedules.
SELECT 
    DATEPART(HOUR, order_time) AS Order_Hour, 
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATEPART(HOUR, order_time)
ORDER BY DATEPART(HOUR, order_time);


-- ============================================================
-- D. PERCENTAGE OF SALES BY PIZZA CATEGORY
-- ============================================================

-- Shows total revenue and revenue share (%) for each pizza category.
-- Categories: Classic, Supreme, Veggie, Chicken.
SELECT 
    pizza_category, 
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Revenue,
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category;


-- ============================================================
-- E. PERCENTAGE OF SALES BY PIZZA SIZE
-- ============================================================

-- Shows total revenue and revenue share (%) for each pizza size.
-- Sizes: S, M, L, XL, XXL.
SELECT 
    pizza_size, 
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Revenue,
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;


-- ============================================================
-- F. TOTAL PIZZAS SOLD BY PIZZA CATEGORY
-- ============================================================

-- Shows total quantity sold per category, filtered by month.
-- Change the MONTH number to filter a different month (e.g. 1 = January, 6 = June).
SELECT 
    pizza_category, 
    SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
WHERE MONTH(order_date) = 2   -- Change 2 to any month number
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC;


-- ============================================================
-- G. TOP 5 BEST SELLERS BY TOTAL PIZZAS SOLD
-- ============================================================

-- Returns the 5 pizzas with the highest total quantity sold.
-- Great for identifying the most popular menu items.
SELECT TOP 5 
    pizza_name, 
    SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC;


-- ============================================================
-- H. BOTTOM 5 WORST SELLERS BY TOTAL PIZZAS SOLD
-- ============================================================

-- Returns the 5 pizzas with the lowest total quantity sold.
-- Useful for reviewing underperforming items or planning promotions.
SELECT TOP 5 
    pizza_name, 
    SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC;


-- ============================================================
-- BONUS: APPLYING FILTERS (Month / Quarter / Week)
-- ============================================================

-- Filter by Month (e.g. January = 1, April = 4)
SELECT 
    DATENAME(DW, order_date) AS Order_Day, 
    COUNT(DISTINCT order_id) AS Total_Orders 
FROM pizza_sales
WHERE MONTH(order_date) = 1       -- Change to desired month number
GROUP BY DATENAME(DW, order_date);


-- Filter by Quarter (e.g. Q1 = 1, Q3 = 3)
SELECT 
    DATENAME(DW, order_date) AS Order_Day, 
    COUNT(DISTINCT order_id) AS Total_Orders 
FROM pizza_sales
WHERE DATEPART(QUARTER, order_date) = 1    -- Change to desired quarter number
GROUP BY DATENAME(DW, order_date);


-- ============================================================
-- END OF QUERIES
-- ============================================================