## INTRODUCTION

![Alt Text](https://github.com/Mario-Gozie/Ecommerce-Data-Visualization/blob/main/Images/introoo.png)


This is a Project on Ecommerce dataset. The dataset came in to forms, an excel sheet containing transaction details and a csv file containing geographical detail (logitudes and latitudes). The Geographical data is what will let me create maps seemlessly.

## THE TASK

**Obiwezy** is an E-commerce firm that supplies various items, with its head office in **Carlifonia USA**,
and many regional offices in The United States. **Bharin Patel** is the sales director of this establishment. He knows the business is growing dynamically but his challenge is that he can't track the sales and insights about the business. He has regional managers for **East**, **West**,**South** and **Central** Region in the United State. Whenever he calls them, they will tell him their region's sales per quater and sometimes send spread sheet to him. unfortunately, he finds it difficult as every other human to process these verbal conversation and spreadsheet. He also feel that these managers do sugar-coat details about sales to make him feel everything is fine. Bharin Patel gets frustrated with all these because he senses that sales is declining but he cant have a clear picture. He wants to know weak regions in sales to decide on promotional offers and other measures to engage customers in other to boost sales. Hence, he feels he would appreciate a dashboard where he could see how numbers are trending daily and also get a monthly reminder at the end of the month.

## PROJECT PLANNING

The project planning for this task was carried out using **AIMS grid** which include,
* Purpose
* Stakeholders
* End Result
* Success Criteria

### PURPOSE

* To unlock sales insight that are not visible before sales team for decision support and automate them to reduce manual time spent in data gathering.

### STAKEHOLDERS

* Sales Directior
* Marketing Team
* Customer Service Team
* Data & Analytics Team (Data Masters)
* Software Engineers (Falcons)
* Data Engineers (Data Miners)


### END RESULT

An automated dashboard providing quick & latest sales insight in order to support data driven decision making.

### SUCCESS CRITERIA

* Dashboard(s) uncovering sales order insights with latest available data.
* sales team able to make better decisions.
* Sales Analysts stop data gathering manually in other to save 20% of their business time and reinvest in value added activity.

## BRIEF EXPLANATION OF THE PROCESS.

The Software Engineers (Falcons) have a simple software they developed known as a **sales management system** that keeps track of all sales number so whenever their is sale on anything in any region this software prints an invoice and stores the record in an SQL Database. The Data Analyst Team (Data Masters) will have to meet the Falcons telling them they need to use the SQL Database which has all they record needed for analytics so they will integrate it with their visualization tool which is tableau in this situation. 

Most times, The Project team will want to make sure the SQL Database is not affected by the Querries fired in tableau. This is where the Data Engineers (Data Miners) come in. They design a Data warehouse which basically take and stores data from an SQL Data base which is also an **Online Transaction Processing System (OLTP)**. Doing this is necessary because SQL Database is a critical system you can't afford to let go down otherwise regular sales operation will be hampered, and everyone business means a lot to him. 

once the data is pulled from SQL data base they (Data Miners) transform the data which will include reformatting data to ease querying and analysis, because some times data gotten from a data base won't be in the fomat you want. This process is called **Extract Transfrom and Load (ETL)**. After extraction, the data is stored in a data warehouse such as Tera Data, Oracle 12c, snowflake, Apache Kylin some people even use pandas in python.

After Transformation and loading in the Data warhouse, The Data Masters (Data Analysts) will come in, pull the data they need and build a dashboard using a visualization tool (Tableau, Power BI etc)

### DISADVANTAGES OF FIRING QUERIES DIRECT IN SQL DATABASE

* it will make database to slow down and the mainstream business will be affected.
* The data is not usually in the right format so there will be need for transformation such as removing unnecessay columns, number transformation etc.

**NB :** The ETL process is the responsibility of Data Miners (Data Engineers). They transform and maintain the data warhouse. For this task, I wont be using a data warehouse since my data base is not active for business, I can fire queries directly. sometimes I have to go source for the data I need if they are not in the data base.

## TOOL USED

* SQL
* TABLEAU


## USE OF SQL FOR TASK

### VIEWING TABLE

`select * from ecommerce_data;`

![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\first view Table.png)

## YTD SALES

`select top(1) Year(order_date) as years, sum (sales_per_order) total_sales`
 `from ecommerce_data`
 `group by YEAR(order_date)`
 `order by years desc;`

 ![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\Total_sales.png)
 
## YTD PROFIT
 
  `select top(1) Year(order_date) as years, sum (profit_per_order) total_profit`
 `from ecommerce_data`
 `group by YEAR(order_date)`
 `order by years desc;`

 ![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\Total_Profit.png)
 
 ## YTD QUANTITY

  ` select top(1) Year(order_date) as years, sum (order_quantity) total_quantity`
 `from ecommerce_data`
` group by YEAR(order_date)`
` order by years desc;`

![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\Total_quantity_sold.png)

## YTD PROFIT MARGIN

* (Profit/Sales) * 100

` select top(1) Year(order_date) as years,`
	`concat(round(sum(profit_per_order)/sum (sales_per_order),4) * 100,' %') as Profit_Margin`
  `from ecommerce_data`
    `group by YEAR(order_date)`
    `order by years desc;`

    ![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\YoY_Profit_Margin.png)

## YEAR OVER YEAR SALES (YOY SALES)

`with year_sales as (select YEAR(order_date) as years, sum(sales_per_order) as total_sales `
`from ecommerce_data`
`group by YEAR(order_date)),`

 `YoY_with_year as (select concat(round(((lead(total_sales) over(order by years)/total_sales)-1)*100,2), ' %')`
`as YoY_sales from year_sales)`

`select YoY_sales from YoY_with_year`
`where YoY_sales != ' %';`

![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\YoY_Total_sales.png)

## YEAR OVER YEAR PROFIT (YOY PROFIT)

`with year_profit as (select YEAR(order_date) as years, sum(profit_per_order) as total_profit` 
`from ecommerce_data`
`group by YEAR(order_date)),`

` YoY_with_year as (select concat(round(((lead(total_profit) over(order by years)/total_profit)-1)*100,2), ' %')`
`as YoY_profit from year_profit)`

`select YoY_profit from YoY_with_year`
`where YoY_profit != ' %';`

![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\YoY_Profit.png)

## YEAR OVER YEAR QUANTITIY OF ITEMS SOLD (YOY QUANTITY)
`with year_Quantity as (select YEAR(order_date) as years, sum(order_quantity) as total_Quantity `
`from ecommerce_data`
`group by YEAR(order_date)),`

 `YoY_with_year as (select concat(round(((lead(total_Quantity) over(order by years)/total_Quantity)-1)*100,2), ' %')`
`as YoY_quantity from year_Quantity)`

`select YoY_quantity from YoY_with_year`
`where YoY_quantity != ' %';`

![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\YoY_Quantity.png)

## YOY PROFIT MARGIN

`select YoY_Profit_margin from `
`(select years, concat(round(((lead(profit_margin) over(order by years)/profit_margin-1)*100),3),' %') `
`as YoY_Profit_margin`
`from (select years, total_profit/total_sales as Profit_margin`
`from `

`(select distinct Year(order_date) as Years, sum(profit_per_order)`
`over(partition by Year(order_date) order by Year(order_date)) as total_Profit,`
`sum (sales_per_order) over(partition by year(order_date)order by Year(order_date))`
`as total_sales  from ecommerce_data)as profit_margin_per_year )  as YoY_profit_margin_with_null) `
`as YoY_Profit_Margin_cleaned`
`where YoY_Profit_margin != ' %';`

![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\YoY_Profit_Margin.png)

## YTD SALES PER REGION

### First Method

`select Year(order_date) as Years,  customer_country, customer_region,  customer_state,`
 `sales_per_order from ecommerce_data`
 `where Year(order_date) = (select max(year(order_date)) from ecommerce_data)`

 ![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\sales Per region per state short.png)

 ### Alternatively

`with Year_region_country_sales as (select Year(order_date) as Years,  customer_country, customer_region,`
`customer_state, sales_per_order from ecommerce_data),` 

`ordering_date as(select Years, customer_country, customer_region,  sales_per_order, customer_state,`
`Dense_rank() over(order by Years) as dense_ranks`
`from Year_region_country_sales)`

`select Years, customer_country, customer_region, customer_state, sales_per_order from ordering_date`
`where Years = (select Max(Year(order_date)) from ecommerce_data)`

![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\sales Per region per state long.png)

### YTD PROPOTION OF SALES PER REGION

`select customer_region, concat(round((sum(sales_per_order)/(select sum(sales_per_order) from ecommerce_data`
`where YEAR(order_date) =`
`(select max(year(order_date)) from ecommerce_data))*100),2),' %') as customer_region_proportion`
`from ecommerce_data`
`where YEAR(order_date) = (select max(year(order_date)) from ecommerce_data)`
`group by customer_region;`

![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\Customer Region Propotion.png)

## YTD SALES PER SHIPPING TYPE

`select shipping_type, concat(round((sum(sales_per_order)/(select sum(sales_per_order) from ecommerce_data`
`where YEAR(order_date) =`
`(select max(year(order_date)) from ecommerce_data))*100),2),' %') as shipping_type_proportion`
`from ecommerce_data`
`where YEAR(order_date) = (select max(year(order_date)) from ecommerce_data)`
`group by shipping_type;`

![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\shipping_type_propotion.png)

## YTD TOP 5 PRODUCT BY SALES

`select top (5) product_name, sum(sales_per_order) as Total_sales from ecommerce_data`
`where YEAR(order_date) = (select max(year(order_date)) from ecommerce_data)`
`group by product_name`
`order by Total_sales desc;`

![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\Top5 sales.png)

## YTD BOTTOM 5 PRODUCT BY SALES

`select top (5) product_name, sum(sales_per_order) as Total_sales from ecommerce_data`
`where YEAR(order_date) = (select max(year(order_date)) from ecommerce_data)`
`group by product_name`
`order by Total_sales asc;`

![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\Bottom5 products.png)

## YOY PRODUCT BY CATEGORY

`go`
`with organized_catgory as (select Year(order_date) as Years, category_name, sum(sales_per_order)as` `Total_sales,`
`ROW_NUMBER() over(partition by category_name order by year(order_date)) as row_num`
`from ecommerce_data`
`group by Year(order_date),category_name),`

`YoY_calculated as (select years, category_name, Total_sales, case when category_name = category_name then`
`concat(round(((lead(Total_sales) over(partition by category_name order by category_name)/`
`Total_sales)-1)*100,2), ' %')`
`end as YoY_per_category`
`from organized_catgory)`

`select category_name, YoY_per_category from YoY_calculated`
`where YoY_per_category != ' %'`

![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\YoY_per_category.png)

## PREVIOUS AND CURRENT YEAR PERFORMANCE IN A PIVOT TABLE

`with Yet_to_pivot as (select YEAR(order_date) as The_Year, category_name,`
`sales_per_order from ecommerce_data)`

`select * from Yet_to_pivot`
`pivot (sum(sales_per_order) for The_Year in ([2021],[2022])) as Pivoted_details`
`order by category_name;`

![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\Pivot table sale per category per year.png)


## PREPARATION FOR VISUALIZATION WITH TABLEAU.

  I used **Sql** query to join the two tables (The Transaction table and the Geographical Data) however since Tableau has **Relationship** feature tha can join data from different data source, I used it to join the transaction detail (Excel file) and the Geographical data (CSV file).

### SQL JOIN

* Query for joing geographical data to sales data

`select * from ecommerce_data as a`
`join us_state_long_lat_codes as b`
`on a.customer_state = b.name`


![Alt Text](https://github.com/Mario-Gozie/Ecommerce-Data-Visualization/blob/main/Images/Screenshot%20(389).png)


### TABLEAU RELATIONSHIP

![Alt Text](C:\Users\Mario Gozie\Desktop\New folder\Projects\Ecommerce Data Project\Images\Tableau Relationship.png)

## DASHBOARD KEY FEATURES
* A **Segment Filter** for filtering the data by either consumer, Home office or cooperate segment
* Four **KPI's** with one for Sales, Quantity, Profit, and Profit Margin.
* A **Map** for sales by state.
* A **Bar Chart** for Top Products by sales and another for Bottom Products by sales.
* A **Doughnut Chart** for Sale Per shipping method.
* A **detail table** for Year over Year sales per Category
* There are Action filters for the Map for filtering by state, and another for the region dougnut chart for filtering based on Region


## THE DASHBOARD

![Alt Text](https://github.com/Mario-Gozie/Ecommerce-Data-Visualization/blob/main/Images/The%20Dashboard%20(2).png)


To interact with the Dashboard, here is my Tableau public [link](https://public.tableau.com/app/profile/chigozirim.nwasinachi.oguedoihu/viz/SalesDashboard_16844527244190/TheDashboard)

## GENERAL INSIGHTS

* The Ecommerce data showed that sales of over **11 thousand dollars** was made for the year 2022 with a drop of less than **1%** when compared with the previous year. interestingly, the business made a profit of over a thousand dollars which is **4.5%** higher that the previous year's Profit.
* The **West Region (32.22%)** Performed better than other Regions in the United states with Califonia being the main contributor to their success.
* For shipping Type, **Standard Class** tops the list as it contributed **60.51%** while **Same Day** is the least with **5.17%**

## A VIDEO OF THE INTERACTIVE DASHBOARD

To watch a video of the interactive dashbord, I have add the video to a video folder. you could download and watch. If you want to interact with the dashboard in my tableau public account, here is the [link](https://public.tableau.com/app/profile/chigozirim.nwasinachi.oguedoihu/viz/SalesDashboard_16844527244190/TheDashboard)

## THANK YOU!

![Alt Text](https://github.com/Mario-Gozie/Ecommerce-Data-Visualization/blob/main/Images/thanks.jpg)
