use retailproject
select * from inventory

-- Count nulls in a specific column
select COUNT(*) AS null_stock_in
from inventory
where stock_in IS NULL;

-- Nulls check
select *
from inventory
where date is null
   or sku_id is null
   or item_name is null
   or category is null
   or warehouse is null
   or opening_stock is null
   or stock_in is null
   or stock_out is null
   or unit_price is null
   or closing_stock is null
   or sales_value is null
   or reorder_level is null
   or supplier is null
   or lead_time_days is null
   or discount_applied is null
   or is_subscriber is null
   or review_rating is null
   or return_rate is null
   or purchase_frequency is null
   or stock_turnover is null;

-- create top sku table

create table top_sku as
select sku_id, item_name, category, sum(stock_out) as total_stock_out
from inventory
group by sku_id, item_name, category
order by total_stock_out desc
limit 10) as temp;

select * from top_sku;

-- create slow skus table
create table slow_skus as
select sku_id, item_name, category, avg(stock_turnover) as avg_turnover
from inventory
group by sku_id, item_name, category
having avg_turnover < (select avg(stock_turnover) from inventory);

select * from slow_skus;

-- create warehouse performance table
create table warehouse_performance as
select warehouse,
       sum(stock_in) as total_stock_in,
       sum(stock_out) as total_stock_out,
       avg(stock_turnover) as avg_turnover
from inventory
group by warehouse;

select * from warehouse_performance;

-- create category summary table
create table category_summary as
select category,
       sum(stock_in) as total_in,
       sum(stock_out) as total_out,
       avg(stock_turnover) as avg_turnover
from inventory
group by category;

select * from category_summary;

-- create monthly sales table
create table monthly_sales as
select date_format(date, '%Y-%m') as month,
       sku_id,
       sum(stock_out) as total_stock_out
from inventory
group by date_format(date, '%Y-%m'), sku_id;

select * from monthly_sales;

-- create reorder analysis table
create table reorder_analysis as
select sku_id, item_name, warehouse, closing_stock, reorder_level
from inventory
where closing_stock < reorder_level;

select * from reorder_analysis;

-- create supplier performance table
create table supplier_performance as
select supplier,
       avg(lead_time_days) as avg_lead_time,
       avg(stock_turnover) as avg_turnover
from inventory
group by supplier;

select * from supplier_performance;

-- create price performance table
create table price_performance as
select sku_id, item_name, unit_price,
       sum(stock_out) as total_stock_out,
       sum(sales_value) as total_sales
from inventory
group by sku_id, item_name, unit_price;

select * from price_performance;

-- create discount effect table
create table discount_effect as
select category,
       avg(discount_applied) as avg_discount,
       sum(stock_out) as total_stock_out
from inventory
group by category;

select * from discount_effect;

-- create warehouse reorder priority table
create table warehouse_reorder_priority as
select warehouse, count(*) as items_to_reorder
from inventory
where closing_stock < reorder_level
group by warehouse
order by items_to_reorder desc;

select * from warehouse_reorder_priority;


