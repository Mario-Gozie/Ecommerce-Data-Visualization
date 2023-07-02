-- viewing the table 
select * from ecommerce_data;

-- Recent Year Sales

 select top(1) Year(order_date) as years, sum (sales_per_order) total_sales
 from ecommerce_data
 group by YEAR(order_date)
 order by years desc;
 
 -- Recent Year Profit
  select top(1) Year(order_date) as years, sum (profit_per_order) total_profit
 from ecommerce_data
 group by YEAR(order_date)
 order by years desc;



 -- Recent year Quantity
   select top(1) Year(order_date) as years, sum (order_quantity) total_quantity
 from ecommerce_data
 group by YEAR(order_date)
 order by years desc;

 -- Profit Margin for current year profit/sales * 100.
    select top(1) Year(order_date) as years, 
	concat(round(sum(profit_per_order)/sum (sales_per_order),4) * 100,' %')as Profit_Margin
    from ecommerce_data
    group by YEAR(order_date)
    order by years desc;

	-- YOY calculations.
	-- YOY sales 
	go
--- it was challenging for me to order by date here so I had to create a row number to take care of it.
with year_sales as (select YEAR(order_date) as years, sum(sales_per_order) as total_sales 
from ecommerce_data
group by YEAR(order_date)),

 YoY_with_year as (select concat(round(((lead(total_sales) over(order by years)/total_sales)-1)*100,2), ' %')
as YoY_sales from year_sales)

select YoY_sales from YoY_with_year
where YoY_sales != ' %';

go
-- yoy Profit 
with year_profit as (select YEAR(order_date) as years, sum(profit_per_order) as total_profit 
from ecommerce_data
group by YEAR(order_date)),

 YoY_with_year as (select concat(round(((lead(total_profit) over(order by years)/total_profit)-1)*100,2), ' %')
as YoY_profit from year_profit)

select YoY_profit from YoY_with_year
where YoY_profit != ' %';
go

-- YoY Quantity
with year_Quantity as (select YEAR(order_date) as years, sum(order_quantity) as total_Quantity 
from ecommerce_data
group by YEAR(order_date)),

 YoY_with_year as (select concat(round(((lead(total_Quantity) over(order by years)/total_Quantity)-1)*100,2), ' %')
as YoY_quantity from year_Quantity)

select YoY_quantity from YoY_with_year
where YoY_quantity != ' %';

-- YoY Profit Margin

go

select YoY_Profit_margin from 
(select years, concat(round(((lead(profit_margin) over(order by years)/profit_margin-1)*100),3),' %') 
as YoY_Profit_margin
from (select years, total_profit/total_sales as Profit_margin
from 

(select distinct Year(order_date) as Years, sum(profit_per_order)
over(partition by Year(order_date) order by Year(order_date)) as total_Profit,
sum (sales_per_order) over(partition by year(order_date)order by Year(order_date))
as total_sales  from ecommerce_data)as profit_margin_per_year )  as YoY_profit_margin_with_null) 
as YoY_Profit_Margin_cleaned
where YoY_Profit_margin != ' %';

-- Sales per region and state for current year
select Year(order_date) as Years,  customer_country, customer_region,  customer_state,
 sales_per_order from ecommerce_data
 where Year(order_date) = (select max(year(order_date)) from ecommerce_data)

 --Alernatively
 go
with Year_region_country_sales as (select Year(order_date) as Years,  customer_country, customer_region,
customer_state, sales_per_order from ecommerce_data), 

ordering_date as(select Years, customer_country, customer_region,  sales_per_order, customer_state,
Dense_rank() over(order by Years) as dense_ranks
from Year_region_country_sales)

select Years, customer_country, customer_region, customer_state, sales_per_order from ordering_date
where Years = (select Max(Year(order_date)) from ecommerce_data)

go

-- YTD (current_Year) propotion of sales per region
select customer_region, concat(round((sum(sales_per_order)/(select sum(sales_per_order) from ecommerce_data
where YEAR(order_date) =
(select max(year(order_date)) from ecommerce_data))*100),2),' %') as customer_region_proportion
from ecommerce_data
where YEAR(order_date) = (select max(year(order_date)) from ecommerce_data)
group by customer_region;

-- YTD (current_Year) propotion of sales per shipping type

select shipping_type, concat(round((sum(sales_per_order)/(select sum(sales_per_order) from ecommerce_data
where YEAR(order_date) =
(select max(year(order_date)) from ecommerce_data))*100),2),' %') as shipping_type_proportion
from ecommerce_data
where YEAR(order_date) = (select max(year(order_date)) from ecommerce_data)
group by shipping_type;

--YTD top product by sales

select top (5) product_name, sum(sales_per_order) as Total_sales from ecommerce_data
where YEAR(order_date) = (select max(year(order_date)) from ecommerce_data)
group by product_name
order by Total_sales desc;

-- YTD bottom 5 product by sales

select top (5) product_name, sum(sales_per_order) as Total_sales from ecommerce_data
where YEAR(order_date) = (select max(year(order_date)) from ecommerce_data)
group by product_name
order by Total_sales asc;

-- YOY poduct category

go
with organized_catgory as (select Year(order_date) as Years, category_name, sum(sales_per_order)as Total_sales, 
ROW_NUMBER() over(partition by category_name order by year(order_date)) as row_num
 from ecommerce_data
group by Year(order_date),category_name),

YoY_calculated as (select years, category_name, Total_sales, case when category_name = category_name then
concat(round(((lead(Total_sales) over(partition by category_name order by category_name)/
Total_sales)-1)*100,2), ' %')
end as YoY_per_category
from organized_catgory)

select category_name, YoY_per_category from YoY_calculated
where YoY_per_category != ' %'

go
-- Previous year and current year performance by category in a pivot table

with Yet_to_pivot as (select YEAR(order_date) as The_Year, category_name, 
sales_per_order from ecommerce_data)

select * from Yet_to_pivot
pivot (sum(sales_per_order) for The_Year in ([2021],[2022])) as Pivoted_details
order by category_name; --optional

--Query for joining geographical data to sales data

select * from ecommerce_data as a 
join us_state_long_lat_codes as b
on a.customer_state = b.name