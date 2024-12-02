-- SQL Sprint 9, Project Part 1

use modelcarsdb;

-- TASK 1 : Customer Data Analysis

-- 1.find the top 10 customers by credit limit
select * from customers 
order by creditlimit desc
limit 10;

-- interpretation : Identified top 10 customers by credit limit

-- 2.find the avg credit limit for customers in each country
select country , avg(creditlimit) as avg_credit_limit from customers
group by country;

-- interpretation : avg credit limit for customers in each country is identified

-- 3.find the number of customers in each state
select state, count(customernumber) as no_of_customers from customers
group by state;

-- interpretation : number of customers in each state is identified

-- 4.find the customers who haven't placed any orders
select * from customers 
where customernumber not in(select customernumber from orders);

-- interpretation : this Query retrieves the data of customers who haven't placed any orders

-- 5.calculate total sales for each customer
select customers.customernumber,customername , SUM(quantityOrdered * priceEach) as total_sales 
from customers
join orders on customers.customernumber = orders.customernumber
join orderdetails on orders.ordernumber = orderdetails.ordernumber 
group by customers.customernumber;

-- interpretation : total sales for each customer is calculated

-- 6.list customers with their assigned sales representatives
select customername , concat(employees.firstname,' ',employees.lastname) as employeename 
from customers
join employees on employees.employeeNumber = customers.salesRepEmployeeNumber;

-- interpretation :this query retrieves the customers with their assigned sales representatives

-- 7.Retrieve cutomers information with their most recent payment details
select customers.customernumber, customername,payments.amount,payments.paymentdate from customers
join payments on customers.customernumber = payments.customernumber
order by payments.paymentdate desc;

-- interpretation : cutomers information with their most recent payment details are identified
                         
-- 8.identify the customers who have exceeded their creditlimit.
select customers.customernumber,customername, creditlimit, payments.amount from customers
 join payments on customers.customernumber = payments.customernumber
where payments.amount > creditlimit;

-- interpretation : customers who have exceeded their creditlimit are identified 

-- 9.find the names of all customers who have placed an order for a product from a specific product line
-- considering "motorcycles" prooductline
select products.productline, customers.customername from customers
join orders on customers.customernumber = orders.customerNumber
join orderdetails on orders.ordernumber = orderdetails.orderNumber
join products on orderdetails.productcode = products.productcode
where products.productline = 'motorcycles';

-- intrepretation : Names of all customers are identified by considering 'Motorscycles' productline

-- 10. find the names of all customers who have placed an order for the most expensive product
select customername , orderdetails.priceeach from customers
join orders on customers.customernumber = orders.customerNumber
join orderdetails on orders.ordernumber = orderdetails.orderNumber
order by priceeach desc
limit 10;

-- interpretation : this query retrieves the names of all customers who have placed an order for the most expensive product

--
-- TASK 2 : office data analysis
--

-- 1.count the number of employees working in each office
select officeCode , count(employeenumber) as no_of_employees from employees
group by officeCode;

-- interpretation : number of employees working in each office is identified

-- 2.identify the offices with less than a certain number of employees
select officeCode , count(employeenumber) as no_of_employees from employees
group by officeCode
having no_of_employees < 4;

-- interpretation : offices with less than a certain number of employees are identified

-- 3.list offices along with their assigned territories
select officecode , territory from offices;

-- interpretation : this query retrieves, offices along with their assigned territories

-- 4.find the offices that have no employees assigned to them
select officecode , count(employeenumber) as no_of_employees from employees
group by officecode 
having no_of_employees = 0;

-- interpretation : this query retrieves, offices that have no employees assigned to them

-- 5.retrieve the most profitable office based on the total sales 
SELECT offices.officeCode, SUM(quantityOrdered * (MSRP - buyPrice)) AS totalProfit
FROM offices 
INNER JOIN employees  ON offices.officeCode = employees.officeCode
inner join customers on employees.employeenumber = customers.salesRepEmployeeNumber
inner join orders on customers.customernumber = orders.customerNumber
INNER JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
INNER JOIN products  ON orderdetails.productCode = products.productCode
GROUP BY offices.officeCode
ORDER BY totalProfit DESC
LIMIT 1;

-- interpretation : Most profitable office based on total sales is identified

-- 6.find the office with the highest number of employees
select officecode , count(employeenumber) as no_of_employees from employees
group by officecode
order by no_of_employees desc
limit 1;

-- interpretation :this query retrieves, office with the highest number of employees 

-- 7.find the avg credit limit for customers in each office
select  offices.officecode, avg(creditlimit) as avg_creditlimit_for_customer from customers
join employees on customers.salesRepEmployeeNumber = employees.employeenumber
join offices on employees.officecode = offices.officecode
group by officecode;

-- interpretation : avg credit limit for customers in each office is identified

-- 8.find the number of offices in each country
select country, count(officecode) as no_of_offices from offices
group by country;

-- interpretation : this query retrieves, number of offices in each country 

--
-- TASK 3 : product data analysis
--

-- 1.count the number of products in each product line
select productline , count(productcode) as no_of_products from products
group by productLine;

-- interpretation : this query counts the number of products in each product line

-- 2.find the product line with the highest average product price
select productline, avg(buyprice) as avg_product_price from orderdetails
join products on orderdetails.productcode = products.productcode
group by productline
order by avg_product_price desc
limit 1;

-- interpretation : this query retrieves the product line with the highest average product price

-- 3.find all products with a price above or below a certain amount (MSRP between 50 and 100)
select * from products 
where msrp  between 50 and 100;

-- interpretation : this query retrieves all products with a price above or below a certain amount (MSRP between 50 and 100)

-- 4.find the total sales amount for each product line
select productline, SUM(quantityOrdered * priceEach)  as total_sales_amount 
from products
join orderdetails on products.productcode = orderdetails.productcode
join orders on orderdetails.ordernumber = orders.ordernumber
join customers on orders.customernumber = customers.customernumber
join payments on customers.customernumber = payments.customernumber
group by productline;

-- interpretation : total sales amount for each product line is identified

-- 5.identify products with low inventory levels (less than a specific threshold value of 10 for quantity in stock)
select productcode, productname, quantityInStock from products
where quantityInStock < 10;

-- interpretation : products with low inventory levels are identified 

-- 6.Retrieve the most expensive products based on MSRP
select productcode, productname, msrp from products
order by msrp desc
limit 10; 

-- interpretation : most expensive products based on MSRP is identified

-- 7.calculate the total sales for each product
select products.productcode,productname, SUM(quantityOrdered * priceEach)  as total_sales_amount from products
join orderdetails on products.productcode = orderdetails.productcode
join orders on orderdetails.ordernumber = orders.ordernumber
join customers on orders.customernumber = customers.customernumber
join payments on customers.customernumber = payments.customernumber
group by productcode;

-- interpretation : total sales for each product is identified

/* 8.identify the top selling products based on total quantity ordered using stored procedure.The procedure
should accept an input parameter to specify the number of top-selling products to retrieve */

USE `modelcarsdb`;
DROP procedure IF EXISTS `modelcarsdb`.`GetTopSellingProducts`;
;

DELIMITER $$
USE `modelcarsdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTopSellingProducts`(IN numProducts INT)
BEGIN
  SELECT products.productCode, products.productName, SUM(quantityOrdered) AS totalQuantityOrdered
  FROM products 
  INNER JOIN orderdetails  ON products.productCode = orderdetails.productCode
  GROUP BY products.productCode, products.productName
  ORDER BY totalQuantityOrdered DESC
  LIMIT numProducts;
END$$

DELIMITER ;
;

-- calling procedure
call GetTopSellingProducts(20);

-- interpretation : Procedure is created and running successfully

/* 9.Retrieve products with low inventry levels (less than a threshold value of 10 for quantityinstock)
within specific product lines('classic cars','motorcycles') */
select productcode, productname, quantityInStock,productline from products
where productline = 'Classic Cars' or 'Motorcycles'
group by productcode
having quantityInStock < 10;

-- interpretation : products with low inventry levels within specific product lines are identified 

-- 10.find the names of all products that have been ordered by more than 10 customers
select products.productcode,products.productname,count(customers.customernumber) as no_of_customers_ordered from customers
join orders on customers.customernumber = orders.customerNumber
join orderdetails on orders.ordernumber = orderdetails.orderNumber
join products on orderdetails.productcode = products.productcode
group by productcode
having no_of_customers_ordered > 10;

-- interpretation : this query retrieves names of all products that have been ordered by more than 10 customers

/* 11.find the names of all products that have been ordered more than the average number
of orders for their productline */

SELECT products.productName, products.productline
FROM products 
INNER JOIN (
SELECT orderdetails.productCode, AVG(orderNumber) AS avg_Orders_PerLine
FROM orderdetails 
GROUP BY orderdetails.productcode
) AS avg_orders ON products.productCode = avg_orders.productCode
INNER JOIN orderdetails ON products.productCode = orderdetails.productCode
WHERE orderdetails.orderNumber > avg_orders.avg_Orders_PerLine
GROUP BY products.productCode;

-- interpretation : names of all products that have been ordered more than the average number of orders for their productline is identified.

-- Sprint 9, Project part 1 completed.











