create database sales;
use sales;

create table customers(
customer_id int primary key,
name varchar(20),
email varchar(25),
phone varchar(20),
city varchar(30)
);

insert into customers(customer_id,name,email,phone,city)values
(1001,"maina","maina@gmail.com",6382667070,"erode"),
(1002,"girija","girija@gmail.com",9082667070,"pondicherry"),
(1003,"dyana","dyana@gmail.com",8782667070,"delhi"),
(1004,"prasanth","prasanth@gmail.com",9782667070,"erode"),
(1005,"shri","shri@gmail.com",8282667070,"villupuram")

select* from customers

create table products(
product_id int primary key,
customer_id int,
product varchar(25),
category varchar(30),
price int,
foreign key (customer_id) references customers (customer_id)
);

insert into products(product_id,customer_id,product,category,price) values
(101,1001,"e-bike","electronics",55000),
(102,1002,"laptop","electronics",80000),
(103,1003,"printers","electronics",35000),
(104,1004,"smartphone","electronics",30000),
(105,1005,"tab","electronics",65000)

select* from products

create table orders(
order_id int primary key,
product_id int,
customer_id int,
product varchar(25),
foreign key (product_id) references products (product_id)
);

insert into orders(order_id,product_id,customer_id,product) values
(001,101,1001,"e-bike"),
(002,102,1002,"laptop"),
(003,103,1003,"printers"),
(004,104,1004,"smartphone"),
(005,105,1005,"tab")

select* from orders

create table orderdetails(
order_detail int primary key,
order_id int,
product varchar(25),
quantity int,
price int,
foreign key (order_id) references orders (order_id)
);

insert into orderdetails(order_detail,order_id,product,quantity,price) values
(1,001,"e-bike",1,55000),
(2,002,"laptop",2,80000),
(3,003,"printers",2,35000),
(4,004,"smartphone",1,30000),
(5,005,"tab",1,65000)

select* from orderdetails

create table sales(
sales_id int primary key,
order_detail int,
name varchar(20),
email varchar(25),
phone varchar(20),
product varchar(25),
city varchar(30)
);

insert into sales(sales_id,order_detail,name,email,phone,product,city)values
(21,1,"maina","maina@gmail.com",6382667070,"e-bike","erode"),
(22,2,"girija","girija@gmail.com",9082667070,"laptop","pondicherry"),
(23,3,"dyana","dyana@gmail.com",8782667070,"printers","delhi"),
(24,4,"prasanth","prasanth@gmail.com",9782667070,"smartphone","erode"),
(25,5,"shri","shri@gmail.com",8282667070,"tab","villupuram")

select* from sales

<---inner join--->

select c.customer_id,c.name,c.city,p.product,p.price from customers c inner join products p 
on c.customer_id = p.customer_id;

select o.order_id,o.product_id,od.quantity,od.price from orders o inner join orderdetails od 
on o.order_id=od.order_id;

<--left join-->

select c.customer_id,c.name,c.city,o.order_id,o.product from customers c left join orders o 
on c.customer_id = o.customer_id;

select o.order_id,o.product_id,od.quantity,od.price from orders o left join orderdetails od 
on o.order_id=od.order_id;

<--right join-->

select c.customer_id,c.name,c.city,o.order_id,o.product from customers c right join orders 
o on c.customer_id = o.customer_id;

select od.order_detail,od.order_id,od.product,od.quantity,od.price,s.sales_id,s.name,s.city 
from orderdetails od right join sales s on od.order_detail=s.order_detail;

<--full join-->

select c.customer_id,c.name,c.email,c.phone,c.city,o.order_id,o.product from customers c left join orders 
o on c.customer_id = o.customer_id;

select c.customer_id, c.name, c.email, c.phone, c.city,o.order_id, o.product
from customers c right join orders o on c.customer_id = o.customer_id;

<--QUERY-->

select name from customers where customer_id in (select customer_id from orders where product ="laptop");

select name from customers where customer_id in (select customer_id from products where price>3);

select name from customers where customer_id=(select customer_id from orders where 
product=(select max(product)from orders))

select name from customers c where exists(select 1 from orders o where o.customer_id=c.customer_id);