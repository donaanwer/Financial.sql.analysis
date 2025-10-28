SELECT*
FROM [finance].[dbo].[Finance Expenses Data 2];

select
	account
from[finance].[dbo].[Finance Expenses Data 2]
GROUP BY account
;


SELECT
	Account,
	Category,
	Sub_category,
	Category_type,
	ROUND(SUM(Debit),1) AS Total_Debit,
	SUM(credit) AS Total_credit
FROM [finance].[dbo].[Finance Expenses Data 2]
Group by Sub_category,Account,Category,Category_type
ORDER BY Total_Debit DESC
;

WITH finance_table AS
(
SELECT
	Account,
	Category,
	Sub_category,
	Category_type,
	MAX(Date) AS Old_date,
	MIN(Date) AS New_date,
	count(Account) AS Total_account,
	ROUND(SUM(Debit),1) AS Total_Debit,
	SUM(credit) AS Total_credit,
	Amount
FROM [finance].[dbo].[Finance Expenses Data 2]
Group by Sub_category,Category,Category_type,Account,Amount
)
SELECT
	Category,
	Sub_category,
	Old_date,
	New_date,
	Total_account,
	Account,
	Total_Debit,
	Total_credit,
	Amount,
	Category_type
FROM finance_table 
ORDER BY Total_Debit DESC
;

--Total_spent,Average_spent By Category:
SELECT
	Category,
	ROUND(SUM(Amount),1) AS Total_spent,
	ROUND(AVG(Amount),1) AS Average_spent
FROM [finance].[dbo].[Finance Expenses Data 2]
WHERE Amount < 0
GROUP BY Category
ORDER BY SUM(Amount) ,AVG(Amount) ASC
;


--Total_spent,Average_Spent of category By Month:
SELECT
	Category,
	ROUND(SUM(Amount),1) AS Total_spent,
	ROUND(AVG(Amount),1) AS AVG_spent,
	DATETRUNC(MONTH,Date) AS Month_date
FROM [finance].[dbo].[Finance Expenses Data 2]
WHERE Amount < 0
GROUP BY DATETRUNC(MONTH,Date), Category
ORDER BY AVG(Amount), SUM(Amount)  
;

--Total_spent, Average_spent By Month
SELECT 
	ROUND(SUM(Amount),1) AS Total_spent,
	ROUND(AVG(Amount),1) AS AVG_spent,
	DATETRUNC(MONTH,Date) AS Month_date
FROM [finance].[dbo].[Finance Expenses Data 2]
WHERE Amount < 0
GROUP BY DATETRUNC(MONTH,Date)
ORDER BY AVG(Amount), SUM(Amount)
;

--Top 5 sub_category by total_spent and average_spent:
SELECT top 5
	(Sub_category),
	ROUND(SUM(Amount),1) AS Total_spent,
	ROUND(AVG(Amount),1) AS AVG_spent
FROM [finance].[dbo].[Finance Expenses Data 2]
WHERE Amount < 0
GROUP BY Sub_category
ORDER BY AVG(Amount), SUM(Amount)
;

--Bottom 5 sub_category by total_spent and average_spent:
SELECT top 5
	(Sub_category),
	ROUND(SUM(Amount),1) AS Total_spent,
	ROUND(AVG(Amount),1) AS AVG_spent
FROM [finance].[dbo].[Finance Expenses Data 2]
WHERE Amount < 0
GROUP BY Sub_category
ORDER BY AVG(Amount) DESC, SUM(Amount) DESC
;

--Total_spent and Average_spent by account:
SELECT 
	Account,
	ROUND(SUM(Amount),1) AS Total_spent,
	ROUND(AVG(Amount),1) AS AVG_spent,
	COUNT(*) TRANSCITION_COUNT
FROM [finance].[dbo].[Finance Expenses Data 2]
WHERE Amount < 0
GROUP BY Account
ORDER BY AVG(Amount) DESC, SUM(Amount) DESC
;

--Total amount and category tyoe by month
SELECT
	ROUND(SUM(Amount),1) AS TotaL_amount,
	account,
	DATETRUNC(MONTH,Date) Month_date,
	category_type
FROM [finance].[dbo].[Finance Expenses Data 2] 
GROUP BY account,DATETRUNC(MONTH,Date), Category_Type
;
--category_percentage by total_spent:
WITH Total AS (
    SELECT ROUND(SUM(Amount), 1) AS total_spent
    FROM [finance].[dbo].[Finance Expenses Data 2]
    WHERE Amount < 0
)
SELECT 
    f.Category,
    ROUND(SUM(f.Amount), 1) AS Total_category_spent,
   CONCAT(ROUND((SUM(f.Amount) / t.total_spent) * 100, 2),'%') AS Category_Percentage
FROM [finance].[dbo].[Finance Expenses Data 2] f
CROSS JOIN Total t
WHERE f.Amount < 0
GROUP BY f.Category, t.total_spent
ORDER BY Category_Percentage desc;

--COUNT DEVIATION FROM AVG OF AMOUNT BY MONTH  
with spending_anomaly as
(
SELECT
DATETRUNC(MONTH,Date) month_date,
ROUND(SUM(Amount),1) AS Total_spent
from [finance].[dbo].[Finance Expenses Data 2]
WHERE Category_type = 'Expense'
GROUP BY DATETRUNC(MONTH,Date) 
)
select
month_date,
ROUND(Total_spent - AVG(Total_spent) over(),0) AS Deviation_FROM_AVG
FROM spending_anomaly
ORDER BY Deviation_FROM_AVG ASC
;







