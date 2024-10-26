create database Akintayo;
use Akintayo;
select *from accounts;
select *from products;
select *from sales_pipeline;
select *from sales_teams;

-- Total Revenue generated
select sum(revenue) as total_revenue from accounts;

-- Which Sector generates the largest revenue
select sector,sum(revenue) as total_revenue_sector FROM accounts group by sector order by total_revenue_sector Desc limit 1;

-- TOP 2 companies that generate the largest revenue
select account,sum(revenue) as total_revenue_companies from accounts group by account order by total_revenue_companies Desc limit 2; 

-- Which company has the most employees and what is there employee count
select account,max(employees) as max_employees_company from accounts group by account order by max_employees_company Desc limit 1;

-- Which country has the most number of offices
select distinct office_location, count(*) as no_of_office from accounts group by office_location order by no_of_office desc limit 1;

-- Oldest Company 
select account,min(year_established)AS Oldest_year from accounts group by account order by Oldest_year ASC LIMIT 1;
select * from accounts where year_established in (select min(year_established) from accounts);

-- Youngest Company 
select * from accounts where year_established in (select max(year_established) from accounts);
select account,max(year_established)AS Youngest_year from accounts group by account order by Youngest_year DESC LIMIT 1;

-- Top 3 products that generates the most revenue
with cte as (select product,sum(close_value) as total_revenue,dense_rank() over(order by sum(close_value)desc)as rnk from sales_pipeline group by 1) 
select * from cte where rnk <=3;

-- Which Manager made the highest revenue
with cte as (select st.manager,sum(close_value) as total_revenue,dense_rank() over(order by sum(close_value)desc) as rnk from sales_pipeline sp join
sales_teams st on sp.sales_agent=st.sales_agent where sp.deal_stage='won' group by 1)
select * from cte where rnk=1;


-- Average engaging time to close a deal
select round(avg(timestampdiff(day,engage_date,close_date)),0) AS average_time_to_close from sales_pipeline;


-- which product has the most lost deals?
select product, concat(round(sum(case when deal_stage='Lost' then 1 else 0 end)*100/count(*),1),'%') as Lost_rate from sales_pipeline group by 1
order by 2 desc limit 1;



