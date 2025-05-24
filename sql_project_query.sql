-- To view entire data in retail_sales
SELECT * FROM dataproject.retail_sales;

-- Total number of records 
select COUNT(*) as Total_count from dataproject.retail_sales

-- data cleaning 
SELECT * FROM dataproject.retail_sales
WHERE 
    ï»¿transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy  IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
DELETE FROM dataproject.retail_sales
WHERE 
    ï»¿transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy  IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- How many unique customers in our retail_sales data
select count(distinct customer_id) as u_customer from dataproject.retail_sales

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is less than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1
select * from dataproject.retail_sales
where sale_date ='2022-11-05'

-- Q.2
select * from dataproject.retail_sales
where category = 'Clothing' and quantiy< 10 and sale_date between '2022-11-01' and '2022-12-01'

-- Q.3
select  category,sum(total_sale) as Total 
from dataproject.retail_sales
group by category

-- Q.4
select round(avg(age),2) as Avg_Aging
from  dataproject.retail_sales
where category = 'Beauty'

-- Q.5
select * from dataproject.retail_sales
where total_sale > 1000

-- Q.6
select category,gender,count(ï»¿transactions_id) as Transaction_count
from dataproject.retail_sales
group by category,gender
order by category

-- Q.7
SELECT year,month,avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as ranking
   FROM dataproject.retail_sales
   group by year, month
) as t1
WHERE ranking = 1

-- Q.8
select customer_id,
 rank() over(order by avg(total_sale) desc) as ranking,
  round(avg(total_sale),2) as Avg_sale
 FROM dataproject.retail_sales
 group by customer_id
 limit 5
 
 -- Q.9
select category,count(distinct customer_id) as Counting
FROM dataproject.retail_sales
group by category

-- Q.10
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM dataproject.retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
