 ==========================================================
   PROJECT : E-Commerce Order Management System
   DATABASE: MySQL
 ========================================================== 


 ----------------------------------------------------------
   PART A : DATABASE AND TABLES
 ---------------------------------------------------------- 

CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE Categories (
  category_id   INT PRIMARY KEY AUTO_INCREMENT,
  category_name VARCHAR(100) NOT NULL
);

CREATE TABLE Products (
  product_id     INT PRIMARY KEY AUTO_INCREMENT,
  name           VARCHAR(150) NOT NULL,
  category_id    INT,
  price          DECIMAL(10,2) NOT NULL,
  stock_quantity INT DEFAULT 0,
  added_date     DATE,
  FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Customers (
  customer_id       INT PRIMARY KEY AUTO_INCREMENT,
  name              VARCHAR(100) NOT NULL,
  email             VARCHAR(100),
  phone_number      VARCHAR(15),
  address           VARCHAR(255),
  registration_date DATE
);

CREATE TABLE Orders (
  order_id     INT PRIMARY KEY AUTO_INCREMENT,
  customer_id  INT,
  order_date   DATE,
  total_amount DECIMAL(10,2),
  status       ENUM('Pending','Shipped','Delivered','Cancelled'),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
  order_item_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id      INT,
  product_id    INT,
  quantity      INT,
  subtotal      DECIMAL(10,2),
  FOREIGN KEY (order_id)   REFERENCES Orders(order_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
  payment_id     INT PRIMARY KEY AUTO_INCREMENT,
  order_id       INT,
  payment_date   DATE,
  payment_method ENUM('Credit Card','PayPal','UPI'),
  payment_status ENUM('Paid','Pending','Failed'),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Shipping (
  shipping_id     INT PRIMARY KEY AUTO_INCREMENT,
  order_id        INT,
  shipping_date   DATE,
  delivery_date   DATE,
  shipping_status ENUM('Dispatched','In Transit','Delivered'),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);


 ----------------------------------------------------------
   PART B : SAMPLE DATA
 ---------------------------------------------------------- 

INSERT INTO Categories (category_name) VALUES
('Electronics'),
('Clothing'),
('Books');

INSERT INTO Products (name, category_id, price, stock_quantity, added_date) VALUES
('Smartphone', 1, 25000, 50,  '2024-01-10'),
('Headphones', 1, 2000,  0,   '2024-02-15'),
('T-Shirt',    2, 500,   200, '2024-03-01'),
('Novel Book', 3, 300,   100, '2024-03-10'),
('Laptop',     1, 60000, 10,  '2024-04-01');

INSERT INTO Customers (name, email, phone_number, address, registration_date) VALUES
('  Amit Shah ', 'amit@mail.com',  '9990001111', 'Bhuj',   '2021-05-10'),
('Priya Patel',  NULL,             '9990002222', 'Anjar',  '2023-02-20'),
('Rahul Mehta',  'rahul@mail.com', '9990003333', 'Mundra', '2022-12-01'),
('Neha Joshi',   'neha@mail.com',  '9990004444', 'Bhuj',   '2024-01-15');

INSERT INTO Orders (customer_id, order_date, total_amount, status) VALUES
(1, '2026-08-01', 25500, 'Delivered'),
(1, '2026-09-05', 2000,  'Pending'),
(2, '2026-09-10', 60000, 'Shipped'),
(3, '2025-01-10', 500,   'Cancelled'),
(1, '2026-09-20', 300,   'Pending'),
(1, '2026-10-01', 500,   'Pending');

INSERT INTO Order_Items (order_id, product_id, quantity, subtotal) VALUES
(1, 1, 1, 25000),
(1, 3, 1, 500),
(2, 2, 1, 2000),
(3, 5, 1, 60000),
(4, 3, 1, 500),
(5, 4, 1, 300),
(6, 3, 1, 500);

INSERT INTO Payments (order_id, payment_date, payment_method, payment_status) VALUES
(1, '2026-08-01', 'UPI',         'Paid'),
(2, '2026-09-05', 'PayPal',      'Paid'),
(3, '2026-09-10', 'Credit Card', 'Paid'),
(5, '2026-09-20', 'UPI',         'Pending');

INSERT INTO Shipping (order_id, shipping_date, delivery_date, shipping_status) VALUES
(1, '2026-08-02', '2026-08-06', 'Delivered'),
(3, '2026-09-11', NULL,         'In Transit');


 ----------------------------------------------------------
   PART C : QUERIES AND OUTPUTS
 ---------------------------------------------------------- 


 ===== TASK 1 : CRUD OPERATIONS ===== 


 ===== QUERY 1 : INSERT PRODUCT =====
   Insert a new product into the Products table 

INSERT INTO Products (name, category_id, price, stock_quantity, added_date)
VALUES ('Smart Watch', 1, 5000, 30, CURDATE());

 OUTPUT:

Query OK, 1 row affected (0.074 sec)




 ===== QUERY 2 : INSERT CUSTOMER =====
   Insert a new customer into the Customers table 

INSERT INTO Customers (name, email, phone_number, address, registration_date)
VALUES ('Karan Desai', 'karan@mail.com', '9990005555', 'Gandhidham', CURDATE());

 OUTPUT:

Query OK, 1 row affected (0.073 sec)




 ===== QUERY 3 : INSERT ORDER AND UPDATE STOCK =====
   Place a new order and reduce the stock of the product.
   A transaction keeps all steps together 

START TRANSACTION;

INSERT INTO Orders (customer_id, order_date, total_amount, status)
VALUES (4, CURDATE(), 1000, 'Pending');

INSERT INTO Order_Items (order_id, product_id, quantity, subtotal)
VALUES (LAST_INSERT_ID(), 3, 2, 1000);

UPDATE Products
SET stock_quantity = stock_quantity - 2
WHERE product_id = 3;

COMMIT;

 OUTPUT:

Query OK, 0 rows affected (0.062 sec)





 ===== QUERY 4 : DELETE CANCELLED ORDERS =====
   Delete orders cancelled more than 30 days ago.
   Child rows are deleted first because of foreign keys 

DELETE FROM Order_Items
WHERE order_id IN (
  SELECT order_id FROM (
    SELECT order_id FROM Orders
    WHERE status = 'Cancelled'
      AND order_date < CURDATE() - INTERVAL 30 DAY
  ) AS t
);

DELETE FROM Payments
WHERE order_id IN (
  SELECT order_id FROM (
    SELECT order_id FROM Orders
    WHERE status = 'Cancelled'
      AND order_date < CURDATE() - INTERVAL 30 DAY
  ) AS t
);

DELETE FROM Shipping
WHERE order_id IN (
  SELECT order_id FROM (
    SELECT order_id FROM Orders
    WHERE status = 'Cancelled'
      AND order_date < CURDATE() - INTERVAL 30 DAY
  ) AS t
);

DELETE FROM Orders
WHERE status = 'Cancelled'
  AND order_date < CURDATE() - INTERVAL 30 DAY;

 OUTPUT:

Query OK, 1 row affected (0.083 sec)




 ===== TASK 2 : WHERE, HAVING, LIMIT ===== 


 ===== QUERY 5 : ORDERS IN LAST 6 MONTHS =====
   Find all orders placed in the last 6 months 

SELECT *
FROM Orders
WHERE order_date >= CURDATE() - INTERVAL 6 MONTH;

 OUTPUT:

+----------+-------------+------------+--------------+-----------+
| order_id | customer_id | order_date | total_amount | status    |
+----------+-------------+------------+--------------+-----------+
|        1 |           1 | 2026-08-01 |     25500.00 | Delivered |
|        2 |           1 | 2026-09-05 |      2000.00 | Pending   |
|        3 |           2 | 2026-09-10 |     60000.00 | Shipped   |
|        5 |           1 | 2026-09-20 |       300.00 | Pending   |
|        6 |           1 | 2026-10-01 |       500.00 | Pending   |
|        7 |           4 | 2026-10-13 |      1000.00 | Pending   |
+----------+-------------+------------+--------------+-----------+
6 rows in set (0.079 sec)




 ===== QUERY 6 : TOP 5 PRICED PRODUCTS =====
   Get the top 5 highest-priced products 

SELECT *
FROM Products
ORDER BY price DESC
LIMIT 5;

 OUTPUT:

+------------+-------------+-------------+----------+----------------+------------+
| product_id | name        | category_id | price    | stock_quantity | added_date |
+------------+-------------+-------------+----------+----------------+------------+
|          5 | Laptop      |           1 | 60000.00 |             10 | 2024-04-01 |
|          1 | Smartphone  |           1 | 25000.00 |             50 | 2024-01-10 |
|          6 | Smart Watch |           1 |  5000.00 |             30 | 2026-10-13 |
|          7 | Smart Watch |           1 |  5000.00 |             30 | 2026-10-13 |
|          2 | Headphones  |           1 |  2000.00 |              0 | 2024-02-15 |
+------------+-------------+-------------+----------+----------------+------------+
5 rows in set (0.051 sec)




 ===== QUERY 7 : CUSTOMERS WITH MORE THAN 3 ORDERS =====
   Find customers who have placed more than 3 orders 

SELECT customer_id, COUNT(order_id) AS total_orders
FROM Orders
GROUP BY customer_id
HAVING COUNT(order_id) > 3;

 OUTPUT:

+-------------+--------------+
| customer_id | total_orders |
+-------------+--------------+
|           1 |            4 |
+-------------+--------------+
1 row in set (0.098 sec)




 ===== TASK 3 : AND, OR, NOT ===== 


 ===== QUERY 8 : PENDING ORDERS WITH PAID PAYMENT =====
   Get all orders where status is Pending AND payment_status is Paid 

SELECT o.*
FROM Orders o
JOIN Payments p ON o.order_id = p.order_id
WHERE o.status = 'Pending'
  AND p.payment_status = 'Paid';

 OUTPUT:

+----------+-------------+------------+--------------+---------+
| order_id | customer_id | order_date | total_amount | status  |
+----------+-------------+------------+--------------+---------+
|        2 |           1 | 2026-09-05 |      2000.00 | Pending |
+----------+-------------+------------+--------------+---------+
1 row in set (0.063 sec)




 ===== QUERY 9 : PRODUCTS NOT OUT OF STOCK =====
   Find all products that are NOT out of stock 

SELECT *
FROM Products
WHERE NOT stock_quantity = 0;

 OUTPUT:

+------------+-------------+-------------+----------+----------------+------------+
| product_id | name        | category_id | price    | stock_quantity | added_date |
+------------+-------------+-------------+----------+----------------+------------+
|          1 | Smartphone  |           1 | 25000.00 |             50 | 2024-01-10 |
|          3 | T-Shirt     |           2 |   500.00 |            198 | 2024-03-01 |
|          4 | Novel Book  |           3 |   300.00 |            100 | 2024-03-10 |
|          5 | Laptop      |           1 | 60000.00 |             10 | 2024-04-01 |
|          6 | Smart Watch |           1 |  5000.00 |             30 | 2026-10-13 |
|          7 | Smart Watch |           1 |  5000.00 |             30 | 2026-10-13 |
+------------+-------------+-------------+----------+----------------+------------+
6 rows in set (0.049 sec)




 ===== QUERY 10 : REGISTERED AFTER 2022 OR PURCHASE ABOVE 10000 =====
   Retrieve customers who registered after 2022 OR
   have made purchases above 10,000 rupees 

SELECT DISTINCT c.*
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE YEAR(c.registration_date) > 2022
   OR o.total_amount > 10000;

 OUTPUT:

+-------------+--------------+----------------+--------------+------------+-------------------+
| customer_id | name         | email          | phone_number | address    | registration_date |
+-------------+--------------+----------------+--------------+------------+-------------------+
|           1 |   Amit Shah  | amit@mail.com  | 9990001111   | Bhuj       | 2021-05-10        |
|           2 | Priya Patel  | NULL           | 9990002222   | Anjar      | 2023-02-20        |
|           4 | Neha Joshi   | neha@mail.com  | 9990004444   | Bhuj       | 2024-01-15        |
|           5 | Karan Desai  | karan@mail.com | 9990005555   | Gandhidham | 2026-10-13        |
+-------------+--------------+----------------+--------------+------------+-------------------+
4 rows in set (0.123 sec)




 ===== TASK 4 : ORDER BY, GROUP BY ===== 


 ===== QUERY 11 : PRODUCTS SORTED BY PRICE =====
   List all products sorted by price in descending order 

SELECT *
FROM Products
ORDER BY price DESC;

 OUTPUT:

+------------+-------------+-------------+----------+----------------+------------+
| product_id | name        | category_id | price    | stock_quantity | added_date |
+------------+-------------+-------------+----------+----------------+------------+
|          5 | Laptop      |           1 | 60000.00 |             10 | 2024-04-01 |
|          1 | Smartphone  |           1 | 25000.00 |             50 | 2024-01-10 |
|          6 | Smart Watch |           1 |  5000.00 |             30 | 2026-10-13 |
|          7 | Smart Watch |           1 |  5000.00 |             30 | 2026-10-13 |
|          2 | Headphones  |           1 |  2000.00 |              0 | 2024-02-15 |
|          3 | T-Shirt     |           2 |   500.00 |            198 | 2024-03-01 |
|          4 | Novel Book  |           3 |   300.00 |            100 | 2024-03-10 |
+------------+-------------+-------------+----------+----------------+------------+
7 rows in set (0.044 sec)




 ===== QUERY 12 : ORDERS PER CUSTOMER =====
   Display the number of orders placed by each customer 

SELECT customer_id, COUNT(order_id) AS number_of_orders
FROM Orders
GROUP BY customer_id;

 OUTPUT:

+-------------+------------------+
| customer_id | number_of_orders |
+-------------+------------------+
|           1 |                4 |
|           2 |                1 |
|           4 |                1 |
+-------------+------------------+
3 rows in set (0.035 sec)




 ===== QUERY 13 : REVENUE PER CATEGORY =====
   Show total revenue generated per category 

SELECT c.category_name, SUM(oi.subtotal) AS total_revenue
FROM Order_Items oi
JOIN Products p   ON oi.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id
GROUP BY c.category_name;

 OUTPUT:

+---------------+---------------+
| category_name | total_revenue |
+---------------+---------------+
| Electronics   |      87000.00 |
| Clothing      |       2000.00 |
| Books         |        300.00 |
+---------------+---------------+
3 rows in set (0.075 sec)




 ===== TASK 5 : AGGREGATE FUNCTIONS ===== 


 ===== QUERY 14 : TOTAL REVENUE =====
   Find the total revenue generated by the store 

SELECT SUM(total_amount) AS total_revenue
FROM Orders;

 OUTPUT:

+---------------+
| total_revenue |
+---------------+
|      89300.00 |
+---------------+
1 row in set (0.007 sec)




 ===== QUERY 15 : MOST PURCHASED PRODUCT =====
   Identify the most purchased product 

SELECT p.name, SUM(oi.quantity) AS total_quantity
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY total_quantity DESC
LIMIT 1;

 OUTPUT:

+---------+----------------+
| name    | total_quantity |
+---------+----------------+
| T-Shirt |              4 |
+---------+----------------+
1 row in set (0.005 sec)





 ===== QUERY 16 : AVERAGE ORDER VALUE =====
   Calculate the average order value 

SELECT AVG(total_amount) AS average_order_value
FROM Orders;

 OUTPUT:

+---------------------+
| average_order_value |
+---------------------+
|        14883.333333 |
+---------------------+
1 row in set (0.016 sec)




 ===== TASK 6 : PRIMARY AND FOREIGN KEY RELATIONSHIPS ===== 


 ===== QUERY 17 : ORDERS LINKED TO CUSTOMERS AND PRODUCTS =====
   Show that every order is linked to its customer and products 

SELECT o.order_id, c.name AS customer_name,
       p.name AS product_name, oi.quantity
FROM Orders o
JOIN Customers c    ON o.customer_id = c.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p     ON oi.product_id = p.product_id
ORDER BY o.order_id;

 OUTPUT:

+----------+---------------+--------------+----------+
| order_id | customer_name | product_name | quantity |
+----------+---------------+--------------+----------+
|        1 |   Amit Shah   | Smartphone   |        1 |
|        1 |   Amit Shah   | T-Shirt      |        1 |
|        2 |   Amit Shah   | Headphones   |        1 |
|        3 | Priya Patel   | Laptop       |        1 |
|        5 |   Amit Shah   | Novel Book   |        1 |
|        6 |   Amit Shah   | T-Shirt      |        1 |
|        7 | Neha Joshi    | T-Shirt      |        2 |
+----------+---------------+--------------+----------+
7 rows in set (0.050 sec)




 ===== QUERY 18 : PAYMENTS LINKED TO ORDERS =====
   Show the relationship between payments and orders 

SELECT p.payment_id, o.order_id, o.total_amount,
       p.payment_method, p.payment_status
FROM Payments p
JOIN Orders o ON p.order_id = o.order_id;

 OUTPUT:

+------------+----------+--------------+----------------+----------------+
| payment_id | order_id | total_amount | payment_method | payment_status |
+------------+----------+--------------+----------------+----------------+
|          1 |        1 |     25500.00 | UPI            | Paid           |
|          2 |        2 |      2000.00 | PayPal         | Paid           |
|          3 |        3 |     60000.00 | Credit Card    | Paid           |
|          4 |        5 |       300.00 | UPI            | Pending        |
+------------+----------+--------------+----------------+----------------+
4 rows in set (0.036 sec)




 ===== TASK 7 : JOINS ===== 


 ===== QUERY 19 : INNER JOIN =====
   Retrieve products along with their category names 

SELECT p.product_id, p.name, c.category_name
FROM Products p
INNER JOIN Categories c ON p.category_id = c.category_id;

 OUTPUT:

+------------+-------------+---------------+
| product_id | name        | category_name |
+------------+-------------+---------------+
|          1 | Smartphone  | Electronics   |
|          2 | Headphones  | Electronics   |
|          5 | Laptop      | Electronics   |
|          6 | Smart Watch | Electronics   |
|          7 | Smart Watch | Electronics   |
|          3 | T-Shirt     | Clothing      |
|          4 | Novel Book  | Books         |
+------------+-------------+---------------+
7 rows in set (0.037 sec)




 ===== QUERY 20 : LEFT JOIN =====
   Get all orders with customer details 

SELECT o.order_id, o.order_date, o.total_amount,
       c.name, c.email, c.phone_number
FROM Orders o
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

 OUTPUT:

+----------+------------+--------------+--------------+---------------+--------------+
| order_id | order_date | total_amount | name         | email         | phone_number |
+----------+------------+--------------+--------------+---------------+--------------+
|        1 | 2026-08-01 |     25500.00 |   Amit Shah  | amit@mail.com | 9990001111   |
|        2 | 2026-09-05 |      2000.00 |   Amit Shah  | amit@mail.com | 9990001111   |
|        3 | 2026-09-10 |     60000.00 | Priya Patel  | NULL          | 9990002222   |
|        5 | 2026-09-20 |       300.00 |   Amit Shah  | amit@mail.com | 9990001111   |
|        6 | 2026-10-01 |       500.00 |   Amit Shah  | amit@mail.com | 9990001111   |
|        7 | 2026-10-13 |      1000.00 | Neha Joshi   | neha@mail.com | 9990004444   |
+----------+------------+--------------+--------------+---------------+--------------+
6 rows in set (0.041 sec)




 ===== QUERY 21 : RIGHT JOIN =====
   Find orders that have not been shipped 

SELECT o.order_id, o.status
FROM Shipping s
RIGHT JOIN Orders o ON s.order_id = o.order_id
WHERE s.shipping_id IS NULL;

 OUTPUT:

+----------+---------+
| order_id | status  |
+----------+---------+
|        2 | Pending |
|        5 | Pending |
|        6 | Pending |
|        7 | Pending |
+----------+---------+
4 rows in set (0.038 sec)




 ===== QUERY 22 : FULL OUTER JOIN =====
   Show customers who have never placed an order.
   MySQL has no FULL OUTER JOIN, so LEFT JOIN + UNION + RIGHT JOIN is used 

SELECT c.customer_id, c.name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
UNION
SELECT c.customer_id, c.name
FROM Customers c
RIGHT JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;

 OUTPUT:

+-------------+-------------+
| customer_id | name        |
+-------------+-------------+
|           3 | Rahul Mehta |
|           5 | Karan Desai |
+-------------+-------------+
2 rows in set (0.097 sec)




 ===== TASK 8 : SUBQUERIES ===== 


 ===== QUERY 23 : ORDERS OF CUSTOMERS REGISTERED AFTER 2022 =====
   Find orders placed by customers who registered after 2022 

SELECT *
FROM Orders
WHERE customer_id IN (
  SELECT customer_id
  FROM Customers
  WHERE YEAR(registration_date) > 2022
);

 OUTPUT:

+----------+-------------+------------+--------------+---------+
| order_id | customer_id | order_date | total_amount | status  |
+----------+-------------+------------+--------------+---------+
|        3 |           2 | 2026-09-10 |     60000.00 | Shipped |
|        7 |           4 | 2026-10-13 |      1000.00 | Pending |
+----------+-------------+------------+--------------+---------+
2 rows in set (0.007 sec)




 ===== QUERY 24 : CUSTOMER WHO SPENT THE MOST =====
   Identify the customer who has spent the most 

SELECT name
FROM Customers
WHERE customer_id = (
  SELECT customer_id
  FROM Orders
  GROUP BY customer_id
  ORDER BY SUM(total_amount) DESC
  LIMIT 1
);

 OUTPUT:

+-------------+
| name        |
+-------------+
| Priya Patel |
+-------------+
1 row in set (0.077 sec)




 ===== QUERY 25 : PRODUCTS NEVER ORDERED =====
   Get products that have never been ordered 

SELECT *
FROM Products
WHERE product_id NOT IN (
  SELECT product_id FROM Order_Items
);

 OUTPUT:

+------------+-------------+-------------+---------+----------------+------------+
| product_id | name        | category_id | price   | stock_quantity | added_date |
+------------+-------------+-------------+---------+----------------+------------+
|          6 | Smart Watch |           1 | 5000.00 |             30 | 2026-10-13 |
|          7 | Smart Watch |           1 | 5000.00 |             30 | 2026-10-13 |
+------------+-------------+-------------+---------+----------------+------------+
2 rows in set (0.063 sec)




 ===== TASK 9 : DATE AND TIME FUNCTIONS ===== 


 ===== QUERY 26 : ORDERS PER MONTH =====
   Extract the month from order_date to count orders per month 

SELECT MONTH(order_date) AS order_month,
       COUNT(order_id)   AS total_orders
FROM Orders
GROUP BY MONTH(order_date);

 OUTPUT:

+-------------+--------------+
| order_month | total_orders |
+-------------+--------------+
|           8 |            1 |
|           9 |            3 |
|          10 |            2 |
+-------------+--------------+
3 rows in set (0.049 sec)




 ===== QUERY 27 : DELIVERY TIME =====
   Calculate delivery time in days using shipping_date and delivery_date 

SELECT order_id, shipping_date, delivery_date,
       DATEDIFF(delivery_date, shipping_date) AS delivery_days
FROM Shipping
WHERE delivery_date IS NOT NULL;

 OUTPUT:

+----------+---------------+---------------+---------------+
| order_id | shipping_date | delivery_date | delivery_days |
+----------+---------------+---------------+---------------+
|        1 | 2026-08-02    | 2026-08-06    |             4 |
+----------+---------------+---------------+---------------+
1 row in set (0.054 sec)




 ===== QUERY 28 : DATE FORMAT =====
   Format order_date as DD-MM-YYYY 

SELECT order_id, DATE_FORMAT(order_date, '%d-%m-%Y') AS formatted_date
FROM Orders;

 OUTPUT:

+----------+----------------+
| order_id | formatted_date |
+----------+----------------+
|        1 | 01-08-2026     |
|        2 | 05-09-2026     |
|        3 | 10-09-2026     |
|        5 | 20-09-2026     |
|        6 | 01-10-2026     |
|        7 | 13-10-2026     |
+----------+----------------+
6 rows in set (0.025 sec)




 ===== TASK 10 : STRING FUNCTIONS ===== 


 ===== QUERY 29 : UPPERCASE PRODUCT NAMES =====
   Convert all product names to uppercase 

SELECT product_id, UPPER(name) AS product_name
FROM Products;

 OUTPUT:

+------------+--------------+
| product_id | product_name |
+------------+--------------+
|          1 | SMARTPHONE   |
|          2 | HEADPHONES   |
|          3 | T-SHIRT      |
|          4 | NOVEL BOOK   |
|          5 | LAPTOP       |
|          6 | SMART WATCH  |
|          7 | SMART WATCH  |
+------------+--------------+
7 rows in set (0.052 sec)




 ===== QUERY 30 : TRIM CUSTOMER NAMES =====
   Trim whitespace from customer names 

SELECT customer_id, TRIM(name) AS customer_name
FROM Customers;

 OUTPUT:

+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
|           1 | Amit Shah     |
|           2 | Priya Patel   |
|           3 | Rahul Mehta   |
|           4 | Neha Joshi    |
|           5 | Karan Desai   |
+-------------+---------------+
5 rows in set (0.053 sec)




 ===== QUERY 31 : REPLACE MISSING EMAIL =====
   Replace missing email values with "Not Provided" 

SELECT customer_id, name,
       IFNULL(email, 'Not Provided') AS email
FROM Customers;

 OUTPUT:

+-------------+--------------+----------------+
| customer_id | name         | email          |
+-------------+--------------+----------------+
|           1 |   Amit Shah  | amit@mail.com  |
|           2 | Priya Patel  | Not Provided   |
|           3 | Rahul Mehta  | rahul@mail.com |
|           4 | Neha Joshi   | neha@mail.com  |
|           5 | Karan Desai  | karan@mail.com |
+-------------+--------------+----------------+
5 rows in set (0.023 sec)




 ===== TASK 11 : WINDOW FUNCTIONS ===== 


 ===== QUERY 32 : RANK CUSTOMERS BY SPENDING =====
   Rank customers based on their total spending 

SELECT customer_id,
       SUM(total_amount) AS total_spending,
       RANK() OVER (ORDER BY SUM(total_amount) DESC) AS spending_rank
FROM Orders
GROUP BY customer_id;

 OUTPUT:

+-------------+----------------+---------------+
| customer_id | total_spending | spending_rank |
+-------------+----------------+---------------+
|           2 |       60000.00 |             1 |
|           1 |       28300.00 |             2 |
|           4 |        1000.00 |             3 |
+-------------+----------------+---------------+
3 rows in set (0.095 sec)




 ===== QUERY 33 : CUMULATIVE REVENUE PER MONTH =====
   Show the cumulative total revenue per month 

SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month,
       SUM(total_amount) AS monthly_revenue,
       SUM(SUM(total_amount)) OVER (
         ORDER BY DATE_FORMAT(order_date, '%Y-%m')
       ) AS cumulative_revenue
FROM Orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m');

 OUTPUT:

+-------------+-----------------+--------------------+
| order_month | monthly_revenue | cumulative_revenue |
+-------------+-----------------+--------------------+
| 2026-08     |        25500.00 |           25500.00 |
| 2026-09     |        62300.00 |           87800.00 |
| 2026-10     |         1500.00 |           89300.00 |
+-------------+-----------------+--------------------+
3 rows in set (0.094 sec)




 ===== QUERY 34 : RUNNING TOTAL OF ORDERS =====
   Display the running total of orders placed 

SELECT order_id, order_date,
       COUNT(order_id) OVER (ORDER BY order_date, order_id) AS running_total_orders
FROM Orders;

 OUTPUT:

+----------+------------+----------------------+
| order_id | order_date | running_total_orders |
+----------+------------+----------------------+
|        1 | 2026-08-01 |                    1 |
|        2 | 2026-09-05 |                    2 |
|        3 | 2026-09-10 |                    3 |
|        5 | 2026-09-20 |                    4 |
|        6 | 2026-10-01 |                    5 |
|        7 | 2026-10-13 |                    6 |
+----------+------------+----------------------+
6 rows in set (0.025 sec)




 ===== TASK 12 : CASE EXPRESSIONS ===== 


 ===== QUERY 35 : LOYALTY STATUS =====
   Gold = above 50,000 | Silver = 20,000 to 50,000 | Bronze = others 

SELECT c.customer_id, c.name,
       IFNULL(SUM(o.total_amount), 0) AS total_spent,
  CASE
    WHEN IFNULL(SUM(o.total_amount), 0) > 50000 THEN 'Gold'
    WHEN IFNULL(SUM(o.total_amount), 0) BETWEEN 20000 AND 50000 THEN 'Silver'
    ELSE 'Bronze'
  END AS Loyalty_Status
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

 OUTPUT:

+-------------+--------------+-------------+----------------+
| customer_id | name         | total_spent | Loyalty_Status |
+-------------+--------------+-------------+----------------+
|           1 |   Amit Shah  |    28300.00 | Silver         |
|           2 | Priya Patel  |    60000.00 | Gold           |
|           3 | Rahul Mehta  |        0.00 | Bronze         |
|           4 | Neha Joshi   |     1000.00 | Bronze         |
|           5 | Karan Desai  |        0.00 | Bronze         |
+-------------+--------------+-------------+----------------+
5 rows in set (0.076 sec)





 ===== QUERY 36 : PRODUCT CATEGORY BY UNITS SOLD =====
   Best Seller = more than 500 | Popular = 200 to 500 | Regular = others 

SELECT p.product_id, p.name,
       IFNULL(SUM(oi.quantity), 0) AS units_sold,
  CASE
    WHEN IFNULL(SUM(oi.quantity), 0) > 500 THEN 'Best Seller'
    WHEN IFNULL(SUM(oi.quantity), 0) BETWEEN 200 AND 500 THEN 'Popular'
    ELSE 'Regular'
  END AS Product_Category
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name;

 OUTPUT:

+------------+-------------+------------+------------------+
| product_id | name        | units_sold | Product_Category |
+------------+-------------+------------+------------------+
|          1 | Smartphone  |          1 | Regular          |
|          2 | Headphones  |          1 | Regular          |
|          3 | T-Shirt     |          4 | Regular          |
|          4 | Novel Book  |          1 | Regular          |
|          5 | Laptop      |          1 | Regular          |
|          6 | Smart Watch |          0 | Regular          |
|          7 | Smart Watch |          0 | Regular          |
+------------+-------------+------------+------------------+
7 rows in set (0.065 sec)



 ==================== END OF PROJECT ==================== 