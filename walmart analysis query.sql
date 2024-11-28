select * from walmart

/* What are the total sales for each store? */
create view week_sale as

SELECT store,FLOOR(SUM(weekly_sales)) AS `total sales`
FROM walmart
GROUP BY store
ORDER BY `total sales` DESC;


select*from week_sale

/* How do sales during holiday weeks compare to non-holiday weeks? */
CREATE VIEW total_sales_in_holidays AS  
SELECT FLOOR(SUM(Weekly_Sales)) AS 'total sales',  
    CASE  
        WHEN Holiday_Flag = '0' THEN 'holiday'  
        WHEN Holiday_Flag = '1' THEN 'working hours'  
        ELSE 'unknown'  
    END AS Holiday_Status  
FROM Walmart  
GROUP BY Holiday_Flag;  

SELECT * FROM total_sales_in_holidays;  


/* What is the impact of temperature on sales? */

SELECT CASE 
        WHEN Temperature BETWEEN 30 AND 50 THEN '30-50 temp'
        WHEN Temperature BETWEEN 50 AND 70 THEN '50-70 temp'
        WHEN Temperature BETWEEN 70 AND 90 THEN '70-90 temp'
        ELSE 'above 90'
    END AS tempfall,
AVG(Weekly_Sales) AS Average_Sales
FROM Walmart
GROUP BY 
    CASE 
        WHEN Temperature BETWEEN 30 AND 50 THEN '30-50 temp'
        WHEN Temperature BETWEEN 50 AND 70 THEN '50-70 temp'
        WHEN Temperature BETWEEN 70 AND 90 THEN '70-90 temp'
        ELSE 'above 90'
    END
ORDER BY Average_sales desc

/* How does the cost of fuel in different regions affect sales? */

select max(Fuel_Price),min(Fuel_Price),avg(Fuel_Price) from walmart

SELECT 
case when Fuel_Price between 2 and 2.5 then 'FP 2.5'
	 when Fuel_Price between 2.5 and 3 then 'FP 3'
     when Fuel_Price between 3 and 3.5 then 'FP 3.5'
     when Fuel_Price between 3.5 and 4 then 'FP 4'
     else 'above 4'
end as fuel_price,
avg(Weekly_Sales) as 'average_sales'
from walmart
group by 
case when Fuel_Price between 2 and 2.5 then 'FP 2.5'
	 when Fuel_Price between 2.5 and 3 then 'FP 3'
     when Fuel_Price between 3 and 3.5 then 'FP 3.5'
     when Fuel_Price between 3.5 and 4 then 'FP 4'
     else 'above 4'
end
ORDER BY Average_sales desc

/* How does the unemployment rate affect sales? */ 

SELECT 
    CASE 
        WHEN Unemployment > 5 AND Unemployment < 6 THEN 'Above 5'
        WHEN Unemployment >= 6 AND Unemployment < 7 THEN '6-7 rate'
        WHEN Unemployment >= 7 AND Unemployment < 8 THEN '7-8 rate'
        ELSE 'Above 8'
    END AS unemployment_rate,
   floor(avg(Weekly_Sales)) AS total_sales
FROM Walmart
GROUP BY 
    CASE 
        WHEN Unemployment > 5 AND Unemployment < 6 THEN 'Above 5'
        WHEN Unemployment >= 6 AND Unemployment < 7 THEN '6-7 rate'
        WHEN Unemployment >= 7 AND Unemployment < 8 THEN '7-8 rate'
        ELSE 'Above 8'
    END;
/*What is the total sales for each store where weekly sales are below the overall average?*/
SELECT distinct(Store),sum(Weekly_Sales) as 'sum-week' FROM walmart
where Weekly_Sales < (select avg(Weekly_Sales)as 'avg_sales'from walmart)
group by store

/* What are the average CPI and weekly sales during holiday weeks? */
WITH holi_flag AS (
    SELECT Holiday_flag, CPI, weekly_sales, 
    CASE 
        WHEN Holiday_flag = 0 THEN 'not_holiday'
        WHEN Holiday_flag = 1 THEN 'holiday'
    END AS holiday_listing
    FROM walmart
)
SELECT round(avg(CPI)) as 'cpi in holiday', round(avg(weekly_sales))as 'weeklysales in holiday',holiday_listing FROM holi_flag
where holiday_listing = 'holiday'
group by holiday_listing

 