--cumulative analysis for total_spent by month:
WITH Monthly_expense AS
(
SELECT
	DATETRUNC(MONTH,Date) AS Month_Date,
	ROUND(
	SUM(Amount),0) AS Total_Spent
FROM [finance].[dbo].[Finance Expenses Data 2] 
WHERE Category_type = 'Expense'
GROUP BY DATETRUNC(MONTH,Date)
),
 Total_Yearly_Spent AS
(
SELECT
	SUM(Total_Spent) AS Total_Yearly_Spent
FROM Monthly_expense
)
SELECT 
    M.Month_Date,
	M.total_spent,
	 SUM(M.total_spent) over(order by M.Month_Date) AS Cumulative_spent,
	 CONCAT(ROUND(
	  SUM(M.total_spent) over(order by M.Month_Date)/
	   Total_Yearly_Spent*100
       ,2),'%') AS cumulative_percent
FROM Monthly_expense M
CROSS JOIN Total_yearly_spent t 
ORDER BY M.Month_date
;

--cumulative analysis by category
WITH Category_Monthly AS
(
 SELECT
      Category,
      DATETRUNC(MONTH, Date) AS Month_Date,
      ROUND(SUM(Amount),0) AS Total_Spent
FROM [finance].[dbo].[Finance Expenses Data 2] 
WHERE Category_type = 'Expense'
GROUP BY DATETRUNC(MONTH, Date), Category
),
Category_total AS
(
SELECT
    Category,
    SUM(Total_Spent) AS Total_Yearly_Spent
FROM Category_Monthly
GROUP BY Category
)
SELECT 
    c.Category,
    c.Month_Date,
    c.Total_Spent,
    SUM(c.Total_Spent) OVER (PARTITION BY c.Category ORDER BY c.Month_Date) AS Cumulative_Spent,
    CONCAT(
        ROUND(
            SUM(c.Total_Spent) OVER (PARTITION BY c.Category ORDER BY c.Month_Date) 
            / ct.Total_Yearly_Spent * 100, 2
        ), '%'
    ) AS Cumulative_Percent
FROM Category_Monthly c
JOIN Category_total ct
    ON c.Category = ct.Category
ORDER BY c.Category, c.Month_Date;


