-- 1. to get total revenue which is sum of total_price
select * from pizza_sales
select sum(total_price) as Total_Revenue from pizza_sales
--2. Average order value= total revenue/total no of order
select sum(total_price)/count(distinct(order_id)) as Avg_order_value from pizza_sales 

--3 total pizza sold
select sum(quantity) as total_pizza_sold from pizza_sales
--4 total order placed
select count(distinct order_id) as total_order_placed from pizza_sales
--5 Avg pizza per order: sum of quantity/ distinct order_id
select cast(sum(quantity) as decimal(10,2))/cast(count(distinct order_id) as decimal (10,2)) as avg_pizza_per_order from pizza_sales

--lets create some charts
--1. daily trend for total order :draw a bar chart which display daily trend of
--total orders over a specific time period
--we will use datename function and inside that DW (day of week) from order_date
--total_orders, day
select datename(DW,order_date) as order_day, count(distinct order_id) as total_orders 
from pizza_sales
group by datename(DW, order_date)
order by total_orders desc
--2. monthly chart for total order
--it will be line chart which will tell hourly trend throughout the day to analyze high order activity
--month_name, total_orders
select datename(month,order_date) as month_name,
count(distinct(order_id)) as total_order
from pizza_sales
group by datename(month,order_date) 
order by total_order desc

--3. percentage of sales by pizza category
--will create a pie chart to show distribution of sales across diff pizza
--in num sum of total price is only for that specific pizza category whereas in denominator sum of total_price for all pizzas
select pizza_category, sum(total_price)*100/(select sum(total_price) from pizza_sales) as PCT
from pizza_sales
group by pizza_category

--3(ii) percentage of sales by pizza category in january month
select pizza_category, sum(total_price)*100/(select sum(total_price) from pizza_sales where month(order_date)=1) as PCT
from pizza_sales
group by pizza_category

--4. percentage of sales by pizza size in january month
select pizza_size, sum(total_price) as total_sales,sum(total_price)*100/(select sum(total_price) from pizza_sales where datepart(quarter,order_date)=1) as PCT
from pizza_sales
where datepart(quarter,order_date)=1
group by pizza_size

--5. top 5 best sellers by revenue, total quantity, total orders
select top 5 pizza_name,sum(total_price) as total_revenue from pizza_sales
group by pizza_name
order by total_revenue desc