--Part to whole analysis:
WITH Total_yearly_expense AS
(
	SELECT 
		SUM(Amount) AS Total_yearly_spent 
	FROM [finance].[dbo].[Finance Expenses Data 2]
	WHERE Category_type = 'Expense'
),
 Performance_analysis AS 
 (
SELECT 
	Sub_category,
	ROUND(
	SUM(AMOUNT),3) AS Total_subcategory_spent,
	ROUND(
	SUM(AMOUNT)/ T.Total_yearly_spent,3)*100 AS Percentage_of_total 
FROM [finance].[dbo].[Finance Expenses Data 2] F
CROSS JOIN Total_yearly_expense T
WHERE F.Category_type = 'Expense'
GROUP BY Sub_category, Total_yearly_spent 
)
SELECT 
	Sub_category,
	Total_subcategory_spent,
	Percentage_of_total,
CASE 
	WHEN Percentage_of_total between 0 and 5 then 'Low_impact'
	WHEN Percentage_of_total between 5 and 15 then 'Medium_impact' 
	ELSE 'High_impact'
	END AS Segmentation_of_subcategory
FROM Performance_analysis
ORDER BY Percentage_of_total DESC
;