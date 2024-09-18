USE GoldStocks;

-- CALCULATING REVENUE
SELECT SUM(Close_Price) AS Total_Revenue
FROM combined_gold_stocks;

-- CALCULATING TOTAL_PROFIT
SELECT SUM(Close_Price - Open_Price) * Total_Revenue FROM combined_gold_stocks;

-- AVERAGE CLOSING PRICE FOR EACH YEAR
SELECT YEAR(Date) AS YEAR , AVG(Close_Price) AS AVERAGE_CLOSE_PRICE
FROM combined_gold_stocks
GROUP BY YEAR(DATE)
ORDER BY YEAR DESC;

-- AVERAGE GOLD PRICE FLUCTUATIONS PER YEAR
SELECT YEAR(Date) AS YEAR , AVG(High_Price - Low_Price) AS AVERAGE_PRICE_FLUCTUATION
FROM combined_gold_stocks
GROUP BY YEAR(Date)
ORDER BY YEAR ASC;

-- TOTAL GOLD SOLD
SELECT SUM(Trading_Volume) AS TOTAL_GOLD_SOLD FROM combined_gold_stocks

-- VOLUME AND PRICE CHANGE
SELECT YEAR(Date) AS YEAR, Trading_Volume , (Close_Price - Open_Price) AS CHANGE_IN_PRICE
FROM combined_gold_stocks
WHERE Trading_Volume > 600000
ORDER BY YEAR DESC;

-- MONTHLY AVERAGE PRICE CHANGE
SELECT 
    YEAR(Date) AS Year, 
    MONTH(Date) AS Month, 
    AVG(Close_Price - Open_Price) AS AVERAGE_MONTHLY_CHANGE
FROM combined_gold_stocks
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Year, Month;


-- DAILY TREND FOR TOTAL GOLD SOLD
SELECT 
    DATE(Date) AS DateOnly, 
    SUM(Trading_Volume) AS TOTAL_GOLD_SOLD
FROM combined_gold_stocks
GROUP BY DATE(Date)
ORDER BY DateOnly;

-- MONTHLY TREND FOR TOTAL GOLD SOLD
SELECT 
    YEAR(Date) AS Year, 
    MONTH(Date) AS Month, 
    SUM(Trading_Volume) AS TOTAL_GOLD_SOLD
FROM combined_gold_stocks
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Year, Month DESC;

-- MONTHLY AVERAGE CLOSING PRICE
SELECT 
    YEAR(Date) AS Year, 
    MONTH(Date) AS Month, 
    AVG(Close_Price) AS AVERAGE_CLOSING_PRICE
FROM combined_gold_stocks
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Year, Month;

-- price reversals by finding the maximum and minimum closing price over periods
WITH PriceReversals AS (
    SELECT 
        Date,
        Close_Price,
        LAG(Close_Price, 1) OVER (ORDER BY Date) AS Previous_Close_Price,
        LEAD(Close_Price, 1) OVER (ORDER BY Date) AS Next_Close_Price
    FROM combined_gold_stocks
)
SELECT 
    Date,
    Close_Price,
    Previous_Close_Price,
    Next_Close_Price
FROM PriceReversals
WHERE Close_Price > Previous_Close_Price
  AND Close_Price > Next_Close_Price
ORDER BY Date;

-- WEEKLY TREND IN GOLD STOCK PRICES
SELECT 
    WEEK(Date, 1) AS WEEK_NUMBER, 
    YEAR(Date) AS Year,
    COUNT(DISTINCT Close_Price) AS Total_Close_Prices
FROM combined_gold_stocks
GROUP BY WEEK(Date, 1), YEAR(Date)
ORDER BY Year, WEEK(Date, 1);

-- Yearly Percentage Change
WITH yearly_prices AS (
    SELECT 
        YEAR(Date) AS Year,
        MIN(Close_Price) AS Starting_Price,
        MAX(Close_Price) AS Ending_Price
    FROM combined_gold_stocks
    GROUP BY YEAR(Date)
),
percentage_change AS (
    SELECT
        Year,
        Starting_Price,
        Ending_Price,
        ((Ending_Price - Starting_Price) / Starting_Price) * 100 AS Percentage_Change
    FROM yearly_prices
)
SELECT *
FROM percentage_change
ORDER BY Year;

-- 7-day rolling average of closing prices
SELECT YEAR(Date), Close_Price,
       AVG(Close_Price) OVER (ORDER BY Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS ROLLING_7_DAY_AVERAGE
FROM combined_gold_stocks
ORDER BY YEAR(Date) DESC;

--  TOP 10 DAYS WITH THE HIGHEST PRICE GAIN
SELECT YEAR(Date), (Close_Price - Open_Price) AS DAILY_GAIN
FROM combined_gold_stocks
ORDER BY DAILY_GAIN DESC
LIMIT 10;

-- QUARTERLY CHANGE IN PRICE
SELECT YEAR(Date), QUARTER(Date) AS QUARTER, Close_Price
FROM combined_gold_stocks
WHERE YEAR(Date) > 2023 AND YEAR(Date) = 2024
ORDER BY YEAR(Date) DESC;

-- Summary statistics for gold prices (open, close, high, low)
SELECT 
  MIN(Close_Price) AS MINIMUM_CLOSE_PRICE, 
  MAX(Close_Price) AS MAX_CLOSE_PRICE, 
  AVG(Close_Price) AS AVERAGE_CLOSE_PRICE, 
  STDDEV(Close_Price) AS STDEV_CLOSE_PRICE
FROM combined_gold_stocks;





















