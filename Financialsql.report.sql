/*
Purpose:
    - This report consolidates key financial metrics and behaviors per Category and Subcategory.
    
Highlights:
    1. Aggregates financial transactions by Category and Subcategory.
    2. Segments data by Type (Expense or Income).
    3. Calculates essential metrics:
        - Total Transactions
        - Total Amount
        - Average Transaction Amount
        - Active Months
        - Months Since Last Transaction
        - Average Monthly Amount
    4. Prepares the data for dashboards and performance analysis.
*/

WITH Finance_Data AS 
(
    SELECT
        Date,
        Category_type,
        Category,
        Sub_category,
        Amount
    FROM [finance].[dbo].[Finance Expenses Data 2]
),
Aggregated AS (
    SELECT
        Category,
        Sub_category,
        Category_type,
        COUNT(DISTINCT Date) AS Total_Transactions,
        SUM(Amount) AS Total_Amount,
        ROUND(AVG(Amount),2) AS Avg_Transaction_Amount,
        DATEDIFF(MONTH, MIN(Date), MAX(Date)) + 1 AS Active_Months,
        DATEDIFF(MONTH, MAX(Date), GETDATE()) AS Months_Since_Last_Transaction,
        ROUND(SUM(Amount)/NULLIF(DATEDIFF(MONTH, MIN(Date), GETDATE())+1,0),2) AS Avg_Monthly_Amount,
        CASE 
            WHEN SUM(Amount) < 0 THEN 'Expense'
            ELSE 'Income'
        END AS Type
    FROM Finance_Data
    GROUP BY Category, Sub_category, Category_type
)
SELECT *
FROM Aggregated
ORDER BY Total_Amount DESC;
