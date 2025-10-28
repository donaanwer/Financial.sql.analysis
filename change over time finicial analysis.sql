--Change over time analysis for expense:
/* Purpose: Change-over-time Analysis (Month over Month) */
/* Purpose: Cumulative Spend Trend */
/* Purpose: Detect Spending Anomalies */
--Classify the change into categories (High Increase, Moderate, High Decrease)
--Used to identify spending trend behavior and alert unusual changes
WITH Monthly_changing AS
(
select
	DATETRUNC(MONTH,Date)Month_date,
	ROUND(SUM(Amount),0) AS total_spent
	from [finance].[dbo].[Finance Expenses Data 2]
	WHERE Category_type = 'Expense'
	GROUP by DATETRUNC(MONTH,Date)
)
, Change_percent AS
(
SELECT 
	Month_date,
	total_spent,
	LAG(Total_spent) over(ORDER BY Month_date) AS Pre_month_spent,
	total_spent-LAG(Total_spent) over(ORDER BY Month_date) as Change_MOM,
	ROUND(
  (Total_spent - LAG(Total_spent) OVER (ORDER BY Month_date))
        / NULLIF(LAG(Total_spent) OVER (ORDER BY Month_date),0)* 100,2)AS Change_pct
FROM Monthly_changing
)
SELECT	Month_date,
	total_spent,
	Change_MOM,
concat(Change_pct,'%') as Change_pct,
CASE WHEN Change_pct between -4 and 0 THEN 'Moderate_decrease'
when Change_pct  > -4 then 'High decrease'
WHEN Change_pct BETWEEN 0 AND 4 THEN 'Moderate increase'
else 'high increase'
end as change_type
FROM Change_percent





