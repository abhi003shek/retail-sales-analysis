create database retail_project;
use retail_project;
select * from superstore limit 10;
describe superstore;
select *
from superstore
where sales is null or sales = '';
select *
from superstore
where 
sales is null 
or profit is null
or quantity is null
or category is null;
select count(*) as total_rows,
count(sales) as sales_count
from superstore;
select *,
count(*) as cnt
from superstore 
group by 
`Ship Mode`,
Segment,
Country,
City,
State,
`Postal Code`,
Region,
Category,
products,
Sales,
Quantity,
Discount,
Profit
having cnt > 1;                          # total 17 rows duplicated are there.
select count(*) as total_rows
from superstore;                         # 9994 row are there around 10k
select distinct region
from superstore;
select distinct category
from superstore;
select distinct `ship mode`
from superstore;
select min(sales) as min_sales,
max(sales) as max_sales
from superstore ;                              # 0.444	22638.48

select
 round(sum(sales),2) as total_sales
 from superstore;                 # total_sales = 2297200.86
 
select
 round(sum(profit),2) as total_profit
from superstore;                      # total_profit = 286397.02

select
 sum(quantity) as total_quantity
from superstore;                     # total_quantity = 37873

select
products,
round(sum(sales),2) as total_sales
from superstore
group by products
order by total_sales desc
limit 10;

select
state,
round(sum(sales),2) as total_sales
from superstore
group by state
order by total_sales desc
limit 10;    
select 
category,
round(sum(profit),2) as total_profit
from superstore
group by category
order by total_profit desc;

select region, round(sum(sales),2) as total_sales
from superstore
group by Region
order by total_sales desc;

select `ship mode`,
count(*) as total_orders
from superstore
group by `ship mode`
order by total_orders desc;

select products,
round(sum(profit),2) as total_profit
from superstore
group by products
having total_profit < 0
order by total_profit;

select products,
round(sum(sales),2) as total_Sales,
rank() over( order by sum(sales) desc ) as rnk
from superstore
group by products;

with cte as (
select region,
products,
round(sum(sales),2) as total_sales,
rank() over(partition by region
			order by sum(sales) desc
) as rnk
from superstore
group by region,products
)
select * from cte
where rnk = 1;

select category,
round(sum(sales),2) as total_sales,

round(sum(sales) * 100 /
sum(sum(sales)) over(),
2 ) as sales_percentage
from superstore
group by Category;

select 
products,
round(sum(profit),2) as total_profit,

case
	when sum(profit) > 0 then 'Profit'
    else 'Loss'
end as profit_status
from superstore
group by products
order by total_profit desc;

select products,
round(sum(sales),2) as total_sales,
dense_rank() over(order by sum(sales) desc ) as dns_rnk
from superstore
group by products;

select 
products,
round(sum(sales),2) as total_sales,
row_number() over(
order by sum(sales) desc
) as row_num
from superstore
group by products;

select 
products,
round(sum(sales),2) as total_sales
from superstore
group by products
having sum(sales) >
(  select avg(product_sales)
from (
		select 
        sum(sales) as product_sales
        from superstore
        group by products
	)t
);
with cte as (
select region,
products,
round(sum(sales),2) as total_sales
from superstore
group by Region,products
) 
select * from cte
where total_sales >
( select avg(total_sales) from cte);

with cte as (
select region,
products,
round(sum(sales),2) as top_sales,
dense_rank() over(partition by region 
				order by sum(sales) desc ) as rnk
from superstore 
group by region,products )
select * from cte
where rnk <= 3;

select 
region,
round(sum(profit),2) as total_profit
from superstore
group by region
order by total_profit desc; 

select 

round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit,
sum(quantity) as total_quantity,
round(avg(discount),2) as avg_discount
from superstore;