

-- wragling Method

CREATE TABLE amazonsale (
Invoice_id varchar(35),
branch varchar(5),
city varchar(30),
customer_type varchar(50),
gender varchar(20),
product_line varchar(100),
unit_price decimal(10,2),
quantity int,
VAT float(6,4),
total decimal(10,2),
Date DATE,
time time,
payment_method varchar(50),
cogs decimal(10,2),
gross_margin_per float(11,9),
gross_income decimal(10,2),
rating float(2,1)
);


use amazon;
select * from  amazonsale;
select count(*) from amazonsale;



/*Analysis List
Product Analysis
Conduct analysis on the data to understand the different product lines, the products lines performing best and the product lines 
that need to be improved.
Sales Analysis
This analysis aims to answer the question of the sales trends of product. The result of this can help us measure the effectiveness 
of each sales strategy the business applies and what modifications are needed to gain more sales.
Customer Analysis
This analysis aims to uncover the different customer segments, purchase trends and the profitability of each customer segment.
*/ 

-- Analysis  
select * from amazonsale;
select product_line, sum(total) from amazonsale group by product_line order by sum(total) desc ;
select product_line , sum(quantity) from amazonsale group by product_line order by sum(quantity) desc;
select branch, sum(total) from amazonsale group by branch order by sum(total) desc ;
select payment_method, sum(total) from amazonsale group by payment_method order by sum(total) desc ;
-- Food and bevarages generate high revenue among all product lines i.e. INR 56144.96
-- Electonic assessories are sold highest in terms of quatity
-- Health and beauty need to fix in terms of revenue
-- highest revenue generated in branchwise in C branch  INR 110490.93 
-- case is the best payment method among all 
-- Health and beauty need to fix in terms of revenue.
-- There are 2 types of customer type member and normal out of which Member purchase in high amount compratively so Amazon should think 
-- giving more option to normal regarding member

-- Feature Engineering
select * from amazonsale;
alter table amazonsale
add column timeofday varchar(20),
add column dayname varchar(5),
add column monthname varchar(5);

 set sql_safe_updates=0;
update amazonsale

Set 
timeofday= case
when time between '00:00:01' and '11:59:59' then 'morning'
when time between '12:00:00' and '18:00:00' then 'afternoon'
else 'evening'
end ;

update amazonsale
set 
dayname =date_format(Date,'%a');

update amazonsale
set 
monthname=date_format(Date,'%b');
select * from amazonsale;
select * from amazonsale;

----------------------------------------------------------------
-- Q1 What is the count of distinct cities in the dataset?
select count(distinct city) 
from amazonsale;

--------------------------------------------------------------------
-- Q2 For each branch, what is the corresponding city?
select branch,city from amazonsale 
group by branch,city ;  -- grouping done 

-- Q3 What is the count of distinct product lines in the dataset?
----------------------------------------------------------------------
select count(distinct product_line) product_line_count 
from amazonsale;          

----------------------------------------------------------------------
-- Q4 Which payment method occurs most frequently?
select payment_method as most_frequenctly_method,count(*) as payment_count 
from amazonsale 
group by payment_method 
order by payment_method desc 
limit 1;

-----------------------------------------------------------------------
-- Q5 Which product line has the highest sales?
select product_line ,round(sum(cogs),0) as Highest_sale  
from amazonsale 
group by product_line  
order by Highest_sale 
limit 1 ;

-----------------------------------------------------------------------
-- Q6 How much revenue is generated each month?
select monthname, round(sum(total),0) total_revenue 
from amazonsale
 group by monthname ;

-----------------------------------------------------------------------
--  Q7 In which month did the cost of goods sold reach its peak?
select monthname , round(sum(cogs),0) as cogs_peak  
from amazonsale 
group by monthname 
order by cogs_peak desc 
limit 1; 

-----------------------------------------------------------------------
-- Q8 Which product line generated the highest revenue?
select product_line , round(sum(total),0) highest_revenue 
from amazonsale 
group by product_line 
order by highest_revenue 
limit 1;

-----------------------------------------------------------------------
-- Q9 In which city was the highest revenue recorded?
select city , round(sum(total),0) as Revenue 
from amazonsale 
group by city 
order by Revenue  
limit 1;

-----------------------------------------------------------------------
-- Q10 Which product line incurred the highest Value Added Tax?
select product_line , round(sum(VAT),0) as highest_VAT 
from amazonsale 
group by product_line 
order by highest_VAT 
limit 1;

-----------------------------------------------------------------------
-- Q11 For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
select product_line , 
case 
	when cogs > (select avg(cogs) from amazonsale) then 'Good' 
	else 'bad' end as status 
from amazonsale;

-----------------------------------------------------------------------
-- Q12 Identify the branch that exceeded the average number of products sold.
select Distinct branch 
from amazonsale 
where cogs > (select avg(cogs)from amazonsale  ) ;

-----------------------------------------------------------------------
-- Q13 Which product line is most frequently associated with each gender?
with cte_productline as (
	select product_line, gender, count(*) as product_line_count ,
	rank() over(partition by gender order by count(*)  desc) as rank_number 
	from amazonsale
	group by product_line, gender)
select product_line, gender,product_line_count  
from cte_productline 
where rank_number=1;


-------------------------------------------------------------------------
-- Q14 Calculate the average rating for each product line.
select product_line,round(avg(rating),2) as average_rating  
from amazonsale 
group by product_line;

-----------------------------------------------------------------------
-- Q15 Count the sales occurrences for each time of day on every weekday.
select  timeofday,dayname ,count(*) as sale_occurance 
from amazonsale 
group by timeofday,dayname 
order by sale_occurance desc;

-----------------------------------------------------------------------
-- Q16 Identify the customer type contributing the highest revenue.
select customer_type , sum(total) as highest_revenue_value 
from amazonsale 
group by customer_type 
order by highest_revenue_value desc 
limit 1;

-----------------------------------------------------------------------
-- Q17 Determine the city with the highest VAT percentage
select city, round(sum(vat),0) highest_VAT 
from amazonsale
 group by city 
 order by highest_VAT desc 
 limit 1;

-----------------------------------------------------------------------
-- Q18 Identify the customer type with the highest VAT payments.
select customer_type,round(sum(vat),0) highest_VAT 
from amazonsale 
group by customer_type
order by highest_VAT desc 
limit 1;


-----------------------------------------------------------------------
-- Q19 What is the count of distinct customer types in the dataset? 
select count(distinct customer_type) as count 
from amazonsale ;

-----------------------------------------------------------------------
-- Q20 What is the count of distinct payment methods in the dataset?
select count(distinct payment_method) as count 
from amazonsale ;

-----------------------------------------------------------------------
-- Q21 Which customer type occurs most frequently?
select customer_type ,count(*) as most_frequent 
from amazonsale 
group by  customer_type 
order by most_frequent desc 
limit 1 ; 


-----------------------------------------------------------------------
-- Q22 Identify the customer type with the highest purchase frequency.
select customer_type , count(*) as highest_purchase 
from amazonsale 
group by  customer_type 
order by  highest_purchase desc 
limit 1;

-----------------------------------------------------------------------
-- Q23 Determine the predominant gender among customers.
select gender , round(sum(total),0) as highest_revenue 
from amazonsale 
group by gender 
order by highest_revenue desc 
limit 1;

-----------------------------------------------------------------------
-- Q24 Examine the distribution of genders within each branch.
select gender , branch ,count(*) as distribution 
from amazonsale 
group by gender , branch 
order by gender;

-----------------------------------------------------------------------
-- Q25 Identify the time of day when customers provide the most ratings.
select * from amazonsale;
select timeofday, max(rating) 
from amazonsale 
group by timeofday;

-----------------------------------------------------------------------
-- Q26 Determine the time of day with the highest customer ratings for each branch.
select branch, timeofday,max(rating) 
from amazonsale 
group by branch,timeofday;

-----------------------------------------------------------------------
-- Q27 Identify the day of the week with the highest average ratings.
select dayname , avg(rating) 
from amazonsale 
group by dayname ;

-----------------------------------------------------------------------
-- Q28 Determine the day of the week with the highest average ratings for each branch.
select dayname , branch, 
avg(rating) 
from amazonsale 
group by dayname,branch;



