# 📊 Sales Performance Dashboard

End-to-end Business Intelligence project built using **SQL Server** and **Power BI** to analyze sales performance, customer behavior, and product trends.

---

## 🧠 Project Overview

This project simulates a real-world sales analytics solution.

It includes:

- Data modeling (Star Schema)
- ETL process using SQL
- Analytical views creation
- KPI calculations
- Interactive Power BI dashboard

The goal is to transform raw sales data into actionable business insights.

---

## 🏗️ Data Model

The database is structured using a **Star Schema**:

### Fact Table
- `fact_sales` → transactional sales data

### Dimension Tables
- `dim_customers` → customer information
- `dim_products` → product details

This structure enables efficient analytical queries and reporting.

---

## ⚙️ ETL Process

The ETL workflow includes:

1. Creating database schema and tables
2. Loading dimension tables
3. Loading fact table
4. Handling keys and relationships
5. Creating analytical views for reporting

All ETL scripts are available in the `/scripts` folder.

---

## 📊 Analytical Views

A master analytical view was created for Power BI:

`Sales.V_AnalizeSales`

This view combines fact and dimension data, including:

- Order Date
- Year / Month
- Customer info
- Product info
- Quantity
- Sales

It simplifies reporting and improves performance.

---

## 📈 KPIs Implemented

The dashboard includes the following key metrics:

- **Total Sales**
- **Total Quantity Sold**
- **Number of Orders**
- **Average Order Value (AOV)**

These KPIs help evaluate overall business performance.

---

## 📉 Dashboard Features

Power BI report includes:

- Line chart → Sales trend over time
- Column chart → Sales by product category
- Pie chart → Sales distribution by category
- Column chart → Sales by customer
- KPI Cards
- Interactive slicers:
  - Product Category
  - Customer Country

---
