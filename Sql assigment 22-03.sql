use  b114
select * from orders;

##Write an SQL query to get all the orders where customers name has
 ##"a" as second character and "d" as fourth character?
SELECT *
FROM orders
WHERE customer_name LIKE '_a_d%';

##write a SQL to get all the orders placed in the month of dec 2020: question:
SELECT *
FROM orders
WHERE (
    STR_TO_DATE(REPLACE(order_date, '/', '-'), '%d-%m-%Y') BETWEEN '2020-12-01' AND '2020-12-31'
);

## write a query to get all the orders where ship mode is neither in 
##'Standard Class' nor in 'First Class' and ship_date is after nov 2020:question:
SELECT *
FROM orders
WHERE ship_mode NOT IN ('Standard Class', 'First Class')
  AND STR_TO_DATE(REPLACE(ship_date, '/', '-'), '%d-%m-%Y') > '2020-11-30'
ORDER BY STR_TO_DATE(REPLACE(ship_date, '/', '-'), '%d-%m-%Y');

##write a query to get all the orders
## where customer name neither start with "A" and nor ends with "n":question:
SELECT *
FROM orders
WHERE customer_name NOT LIKE 'A%' 
  AND customer_name NOT LIKE '%n';
  
## write a query to get all the orders where profit is negative:question:
SELECT *
FROM orders where profit < 0;

##write a query to get all the orders where either quantity is less than 3 or profit is 0
select * from orders
where quantity <3 or profit =0;

##your manager handles the sales for South region and he wants you to 
##create a report of all the orders in his region 
##where some discount is provided to the customers:question:
SELECT *
FROM orders
WHERE region = 'South'
  AND discount > 0;
  
##write a query to find top 5 orders with highest sales in furniture category
SELECT *
FROM orders
WHERE category = 'Furniture'
ORDER BY sales DESC
LIMIT 5;

##write a query to find all the records in technology and furniture category
## for the orders placed in the year 2020 only
SELECT *
FROM orders
WHERE category IN ('Furniture', 'Technology')
  AND YEAR(STR_TO_DATE(REPLACE(order_date, '/', '-'), '%d-%m-%Y')) = 2020
ORDER BY STR_TO_DATE(REPLACE(order_date, '/', '-'), '%d-%m-%Y');

##write a query to find all the orders where order date is in year 2020 but ship date is in 2021:
SELECT *
FROM orders
WHERE YEAR(STR_TO_DATE(REPLACE(order_date, '/', '-'), '%d-%m-%Y')) = 2020
  AND YEAR(STR_TO_DATE(REPLACE(ship_date, '/', '-'), '%d-%m-%Y')) = 2021
ORDER BY STR_TO_DATE(REPLACE(order_date, '/', '-'), '%d-%m-%Y');

##write a update statement to update city as null for order ids : CA-2020-161389 , US-2021-156909
SET SQL_SAFE_UPDATES = 0;
UPDATE orders
SET city = NULL
WHERE order_id IN ('CA-2020-161389', 'US-2021-156909');
SET SQL_SAFE_UPDATES = 1;
SELECT order_id, city
FROM orders
WHERE order_id IN ('CA-2020-161389', 'US-2021-156909');

##write a query to find orders where city is null 
SELECT 
    order_id, city
FROM
    orders
WHERE
    city IS NULL;
    
## write a query to get total profit, first order date and latest order date for each category
SELECT category,
       SUM(profit) AS total_profit,
       MIN(STR_TO_DATE(order_date, '%d-%m-%Y')) AS first_order_date,
       MAX(CASE 
               WHEN order_date LIKE '%/%' THEN STR_TO_DATE(order_date, '%m/%d/%Y')
               ELSE STR_TO_DATE(order_date, '%d-%m-%Y')
           END) AS latest_order_date
FROM orders
GROUP BY category;

##write a query to find sub-categories where average profit 
##is more than the half of the max profit in that sub-category 

SELECT sub_category
FROM orders
GROUP BY sub_category
HAVING AVG(profit) > (MAX(profit) / 2);

SELECT sub_category,
       AVG(profit) AS avg_profit,
       MAX(profit) AS max_profit
FROM orders
GROUP BY sub_category;

## create the exams table with below script; 
##write a query to find students who have got same marks in Physics and Chemistry
DROP TABLE IF EXISTS exams;
CREATE TABLE exams (
    student_id INT,
    student_name VARCHAR(100),
    physics INT,
    chemistry INT,
    maths INT
);

insert into exams values
(0001,'Arun',45,45,25),
(0002,'Vinod',45,35,10),
(0003,'Muthu',75,75,88),
(0004,'Venu',35,55,68);

SELECT student_id, student_name, physics, chemistry
FROM exams
WHERE physics = chemistry;

##Write a query to findout the all the students marks in chemistry subject

select student_id, student_name, chemistry
from exams; 

##write a query to find total number of products in each category
SELECT category, COUNT(*) AS total_products
FROM orders
GROUP BY category;

##write a query to find top 5 sub categories in west region by total quantity sold. ?
SELECT sub_category, SUM(quantity) AS total_quantity
FROM orders
where region='west'
GROUP BY sub_category
ORDER BY total_quantity DESC
limit 5;

##Write a query to find total sales for each region and ship mode combination for orders in year 2020 ?

SELECT region, ship_mode, MIN(order_date) AS first_order_date, ROUND(SUM(sales), 2) AS total_sales
FROM orders
WHERE YEAR(STR_TO_DATE(REPLACE(order_date, '/', '-'), '%d-%m-%Y')) = 2020
GROUP BY region, ship_mode
ORDER BY region DESC;

##Write a query to find total sales for each region ?
SELECT region, round(SUM(sales),2) AS region_sales
FROM orders
GROUP BY region;

##orders table can have multiple rows for a particular order_id
## when customers buy more than 1 product in an order. 
##write a query to find order ids where there is only 1 product bought by the customer?

SELECT order_id
FROM orders
GROUP BY order_id
HAVING COUNT(*) = 1;

 ##write a query to print 3 columns category, 
 ##total_sales_2019(sales in year 2019), total_sales_2020(sales in year 2020)?
SELECT 
    category,
    ROUND(SUM(CASE 
        WHEN YEAR(STR_TO_DATE(REPLACE(order_date, '/', '-'), '%d-%m-%Y')) = 2019 THEN sales 
        ELSE 0 
    END), 2) AS total_sales_2019,
    
    ROUND(SUM(CASE 
        WHEN YEAR(STR_TO_DATE(REPLACE(order_date, '/', '-'), '%d-%m-%Y')) = 2020 THEN sales 
        ELSE 0 
    END), 2) AS total_sales_2020
FROM orders
GROUP BY category;

##write a query print top 5 cities in west region by average no of days between order date and ship date
SELECT 
  city,
  AVG(DATEDIFF(
    STR_TO_DATE(REPLACE(ship_date, '/', '-'), '%d-%m-%Y'),
    STR_TO_DATE(REPLACE(order_date, '/', '-'), '%d-%m-%Y')
  )) AS avg_delivery_days
FROM orders
WHERE region = 'West'
GROUP BY city
ORDER BY avg_delivery_days DESC
LIMIT 5;

create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);

INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup


##write a query to produce team_name, no_of_matches_played , no_of_wins , 
##no_of_losses this output from icc_world_cup table


SELECT 
  Team_name,
  COUNT(*) AS no_of_matches_played,
  SUM(team_name = Winner) AS no_of_wins,
  COUNT(*) - SUM(team_name = Winner) AS no_of_losses
FROM (
  SELECT Team_1 AS team_name, Winner FROM icc_world_cup
  UNION ALL
  SELECT Team_2 AS team_name, Winner FROM icc_world_cup
) AS all_teams
GROUP BY team_name;

##write a query to print first name and last name of a customer using orders table 
##(everything after first space can be considered as last name) customer name, first_name, last_name ?
SELECT 
  customer_name,
  SUBSTRING_INDEX(customer_name, ' ', 1) AS first_name,
  SUBSTRING_INDEX(customer_name, ' ', -1) AS last_name
FROM orders
group by customer_name;

##write a query to print customer name and no of occurrence of character 'n' 
##in the customer name.customer_name , count_of_occurence_of_n 
SELECT 
  customer_name,
  LENGTH(LOWER(customer_name)) - LENGTH(REPLACE(LOWER(customer_name), 'n', '')) AS count_of_occurence_of_n
FROM orders
group by customer_name;

##write a query to print below output from orders data.
##example output - hierarchy type, hierarchy name ,total_sales_in_west_region, total_sales_in_east_region
##--and so on all the category, subcategory and ship mode hierarchies?
 
SELECT 
  'Category' AS hierarchy_type,
  category AS hierarchy_name,
  round(SUM(CASE WHEN region = 'West' THEN sales ELSE 0 END),2) AS total_sales_in_west_region,
  round(SUM(CASE WHEN region = 'East' THEN sales ELSE 0 END),2) AS total_sales_in_east_region,
  round(SUM(CASE WHEN region = 'Central' THEN sales ELSE 0 END),2) AS total_sales_in_central_region,
  round(SUM(CASE WHEN region = 'South' THEN sales ELSE 0 END),2) AS total_sales_in_south_region
FROM orders
GROUP BY category

UNION ALL

SELECT 
  'Sub-Category' AS hierarchy_type,
  sub_category AS hierarchy_name,
  round(SUM(CASE WHEN region = 'West' THEN sales ELSE 0 END),2),
  round(SUM(CASE WHEN region = 'East' THEN sales ELSE 0 END),2),
  round(SUM(CASE WHEN region = 'Central' THEN sales ELSE 0 END),2),
  round(SUM(CASE WHEN region = 'South' THEN sales ELSE 0 END),2)
FROM orders
GROUP BY sub_category

UNION ALL

SELECT 
  'Ship Mode' AS hierarchy_type,
  ship_mode AS hierarchy_name,
  round(SUM(CASE WHEN region = 'West' THEN sales ELSE 0 END),2),
  round(SUM(CASE WHEN region = 'East' THEN sales ELSE 0 END),2),
  round(SUM(CASE WHEN region = 'Central' THEN sales ELSE 0 END),2),
  round(SUM(CASE WHEN region = 'South' THEN sales ELSE 0 END),2)
FROM orders
GROUP BY ship_mode;

