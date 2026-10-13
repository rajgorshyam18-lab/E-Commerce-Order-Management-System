 # 🛒 E-Commerce Order Management System

> A MySQL project to manage products, customers, orders, payments and shipping, and to analyze sales data.

---

## 📌 Project Overview

Every online store keeps its data in tables. The real value comes when that data is stored safely, linked together and turned into answers.

**E-Commerce Order Management System** is a small database project built in MySQL. It helps an administrator manage products, customers, orders, payments and shipping, and it uses 36 queries to work with that data.

The project includes:

- ✏️ CRUD operations (insert, update, delete)
- 🔍 WHERE, HAVING and LIMIT clauses
- ⚙️ AND, OR, NOT operators
- 📊 Sorting, grouping and aggregate functions
- 🔑 Primary and foreign key relationships
- 🔗 Joins to combine tables
- 🧩 Subqueries
- 📅 Date and time functions
- ✂️ String functions
- 📈 Window functions
- 🏷️ CASE expressions

---

## 🎯 Objectives

1. Create a database with seven connected tables.
2. Insert sample data into every table.
3. Insert new records and update stock when an order is placed.
4. Delete orders that were cancelled more than 30 days ago.
5. Filter and sort data using clauses and operators.
6. Group data and use aggregate functions to find revenue and averages.
7. Link tables using primary and foreign keys.
8. Combine tables using INNER, LEFT, RIGHT and FULL OUTER joins.
9. Use subqueries, date functions and string functions.
10. Use window functions for rankings and running totals.
11. Create loyalty status and product categories using CASE.
12. Show the output of every query.

---

## 🗂️ Database Schema

| Table | Purpose | Columns |
|-------|---------|---------|
| 🗃️ **Categories** | Product categories | category_id (PK), category_name |
| 📦 **Products** | Product details | product_id (PK), name, category_id (FK), price, stock_quantity, added_date |
| 👤 **Customers** | Customer details | customer_id (PK), name, email, phone_number, address, registration_date |
| 🧾 **Orders** | Customer orders | order_id (PK), customer_id (FK), order_date, total_amount, status |
| 🛍️ **Order_Items** | Products inside each order | order_item_id (PK), order_id (FK), product_id (FK), quantity, subtotal |
| 💳 **Payments** | Payment details | payment_id (PK), order_id (FK), payment_date, payment_method, payment_status |
| 🚚 **Shipping** | Shipping details | shipping_id (PK), order_id (FK), shipping_date, delivery_date, shipping_status |

**Order status values:** Pending, Shipped, Delivered, Cancelled

**Payment methods:** Credit Card, PayPal, UPI

**Payment status values:** Paid, Pending, Failed

**Shipping status values:** Dispatched, In Transit, Delivered

---

## 🔑 Relationships

- One category has many products (`Products.category_id` → `Categories.category_id`).
- One customer can place many orders (`Orders.customer_id` → `Customers.customer_id`).
- One order can have many order items (`Order_Items.order_id` → `Orders.order_id`).
- One product can appear in many order items (`Order_Items.product_id` → `Products.product_id`).
- One order is linked to its payments (`Payments.order_id` → `Orders.order_id`).
- One order is linked to its shipping record (`Shipping.order_id` → `Orders.order_id`).

---

## 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| 🐬 MySQL | Database and query language |
| 🖥️ MySQL Workbench | Writing and running queries |
| 🐙 GitHub | Hosting the project |

---

## 🔍 Queries Performed

### ✏️ 1. CRUD Operations (Queries 1 to 4)
Insert a product, insert a customer, place an order and reduce stock, and delete orders cancelled more than 30 days ago.

### 🔍 2. WHERE, HAVING, LIMIT (Queries 5 to 7)
Orders from the last 6 months, top 5 highest-priced products, and customers with more than 3 orders.

### ⚙️ 3. AND, OR, NOT (Queries 8 to 10)
Pending orders with paid payment, products that are not out of stock, and customers who registered after 2022 or purchased above ₹10,000.

### 📊 4. ORDER BY, GROUP BY (Queries 11 to 13)
Products sorted by price, number of orders per customer, and revenue per category.

### 🧮 5. Aggregate Functions (Queries 14 to 16)
Total revenue, most purchased product, and average order value.

### 🔑 6. Key Relationships (Queries 17 and 18)
Orders linked to customers and products, and payments linked to orders.

### 🔗 7. Joins (Queries 19 to 22)
INNER, LEFT, RIGHT and FULL OUTER joins.

### 🧩 8. Subqueries (Queries 23 to 25)
Orders of customers registered after 2022, the customer who spent the most, and products never ordered.

### 📅 9. Date and Time Functions (Queries 26 to 28)
Orders per month, delivery time in days, and DD-MM-YYYY format.

### ✂️ 10. String Functions (Queries 29 to 31)
Uppercase product names, trimmed customer names, and missing emails replaced with "Not Provided".

### 📈 11. Window Functions (Queries 32 to 34)
Customer spending rank, cumulative revenue per month, and running total of orders.

### 🏷️ 12. CASE Expressions (Queries 35 and 36)
Loyalty status (Gold, Silver, Bronze) and product category (Best Seller, Popular, Regular).

---

## 💡 Key Observations

- Foreign keys make sure an order always belongs to a real customer and a real product.
- A transaction keeps the order and the stock update together, so both happen or neither happens.
- Child rows (order items, payments, shipping) must be deleted before the order, because of foreign keys.
- INNER JOIN shows only matching rows, while LEFT and RIGHT joins also show unmatched rows as **NULL**.
- Window functions add ranks and running totals without removing any rows.
- CASE turns plain numbers into easy labels like Gold, Silver and Best Seller.

---

## ⚠️ Assumptions & Limitations

**Assumptions**

- Database used: **MySQL** (version 8.0 or above, needed for window functions).
- Sample data was added so every query gives a clear result.
- One customer name has extra spaces, to show `TRIM()`.
- One customer has no email, to show the "Not Provided" replacement.
- One product is out of stock, to show the NOT operator.
- Loyalty status: above ₹50,000 = Gold, ₹20,000 to ₹50,000 = Silver, otherwise Bronze.
- Product category: more than 500 units = Best Seller, 200 to 500 units = Popular, otherwise Regular.

**Limitations**

- MySQL has no direct FULL OUTER JOIN, so it is built with LEFT JOIN + UNION + RIGHT JOIN.
- The data is small and made for practice, not real store data.
- Queries that use the current date (`CURDATE()`) give different results on different days.
- Because the sample data is small, no product reaches 200 units, so all products show as Regular.

---

## 📁 Project Structure

```
E-Commerce-Order-Management-System/
│
├── 📄 ecommerce_management.sql   → tables, sample data, 36 queries and outputs
└── 📄 README.md                  → project documentation
```

---

## ▶️ How to Run the Project

1. Download or clone the repository.
2. Open **MySQL Workbench**.
3. Open the file `ecommerce_management.sql`.
4. Click the ⚡ **Execute** button.
5. Check the result of each query in the results panel.

---

## 📚 What I Learned

- How primary and foreign keys connect tables.
- How to insert, update and delete data safely.
- How different joins decide which rows appear in the result.
- How subqueries can feed their answer into another query.
- How to group data and calculate totals and averages.
- How window functions work without grouping rows.
- How CASE creates clear categories from numbers.

One main lesson: **a good query is not about writing more code, it is about asking the right question.**

---

## 📌 Conclusion

This project shows how SQL can run a complete order management system. It covers the full flow:

**Create Tables → Insert Data → Filter → Group → Join → Compare → Clean → Rank → Categorize**

---

## 👨‍💻 Author

**shyam gor**

SQL Learner

Currently learning SQL and building practical skills through hands-on projects.

---

## 🙏 Acknowledgement

This project was created for learning purposes, based on the E-Commerce Order Management System project assignment.

---

## ⭐ Project Summary

| | |
|---|---|
| **Project** | E-Commerce Order Management System |
| **Author** | Your Name |
| **Language** | SQL |
| **Database** | MySQL |
| **Total Tables** | 7 |
| **Total Queries** | 36 |
| **Topics** | CRUD • Clauses • Operators • Joins • Subqueries • Date & String Functions • Window Functions • CASE |

*Thank you for reviewing my project.*