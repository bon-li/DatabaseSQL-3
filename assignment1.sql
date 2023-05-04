--1. Create a view that selects customer details (Name & Address), Products ordered, Quantity ordered and total amount for all 'Cancelled' and 'Shipped' orders of 2016
select * from ot.customers; --name, address, join customer_id
select name, address from ot.customers;

select * from ot.order_items; --quantity, join order_id + product_id

select * from ot.orders; --join customer_id + order_id
select * from ot.orders where order_date >= '2016-01-01' AND order_date <= '2016-12-31' ;


CREATE VIEW customer_order_details AS
SELECT c.name, c.address, p.product_name, oi.quantity, oi.quantity * oi.unit_price AS Total_amount
FROM ot.customers c 
INNER JOIN ot.orders o ON c.customer_id = o.customer_id
INNER JOIN ot.order_items oi ON o.order_id = oi.order_id
INNER JOIN ot.products p ON oi.product_id = p.product_id
WHERE o.order_date >= '2016-01-01' AND o.order_date <= '2016-12-31' AND o.status = 'Canceled' OR o.status ='Shipped'
ORDER BY c.name;

drop view customer_order_details;

select * from customer_order_details

--2. Using set Operations, list all the Product names which were ordered so far but also available in stock in any warehouse as well.
select * from ot.products where product_id = 47 --product_name, product_id

select * from ot.inventories where quantity = 0 --need quantity, warehouse_id, product_id

SELECT p.product_name
FROM ot.products p
INNER JOIN ot.inventories i ON p.product_id = i.product_id
INTERSECT
SELECT p.product_name
FROM ot.products p
INNER JOIN ot.inventories i ON p.product_id = i.product_id
MINUS 
SELECT p.product_name
FROM ot.products p
INNER JOIN ot.inventories i ON p.product_id = i.product_id
WHERE i.quantity = 0;

--3. Write a query to display number of customers who are served orders by each employee on each date. Make sure to display subtotals using all possible combinations using Grouping sets query
select * from ot.orders --count customer_id, order_id, inner join salesman_id, order_date
select * from ot.employees --inner join employee_id

select o.order_date, e.employee_id, COUNT(o.customer_id)
FROM ot.orders o
INNER JOIN ot.employees e ON o.salesman_id = e.employee_id
GROUP BY ROLLUP(o.order_date, e.employee_id)
ORDER BY o.order_date;


--4. Write a query to print all warehouses and their locations from 'Americas' or 'America' region sorted in descending order of warehouse name
select * from ot.warehouses --warehouse_name, location_id
select * from ot.locations --location_id, country_id, city, address, state
select * from ot.countries --region_id, country_id, country_name
select * from ot.regions --region_id, region_name

SELECT w.warehouse_name, l.address, l.city, l.state, c.country_name
FROM ot.warehouses w
INNER JOIN ot.locations l ON w.location_id = l.location_id
INNER JOIN ot.countries c ON l.country_id = c.country_id
INNER JOIN ot.regions r ON c.region_id = r.region_id
WHERE r.region_name = 'Americas' OR r.region_name = 'America'
ORDER BY w.warehouse_name DESC;



