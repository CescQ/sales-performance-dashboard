/*
===============================================================================
DDL Script: Create Sales Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'sales' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'sales' Tables
===============================================================================
*/

IF OBJECT_ID('Sales.dim_customers', 'U') IS NOT NULL
    DROP TABLE Sales.dim_customers;
GO

CREATE TABLE Sales.dim_customers (
    CustomerID		INT NOT NULL PRIMARY KEY,
    Company			VARCHAR(50),
    Country			VARCHAR(50)
);
GO

IF OBJECT_ID('Sales.dim_products', 'U') IS NOT NULL
    DROP TABLE Sales.dim_products;
GO

CREATE TABLE Sales.dim_products (
    ProductID		INT NOT NULL PRIMARY KEY,
    Product			VARCHAR(50),
    Category		VARCHAR(50),
	Price			DECIMAL(10,2)
);
GO

IF OBJECT_ID('Sales.fact_sales', 'U') IS NOT NULL
    DROP TABLE Sales.fact_sales;
GO

CREATE TABLE Sales.fact_sales (
    SalesLineID		INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    OrderID         INT NOT NULL CONSTRAINT FK_Costumer FOREIGN KEY REFERENCES Sales.dim_customers(CustomerID),
    ProductID	    INT NOT NULL CONSTRAINT FK_Product FOREIGN KEY REFERENCES Sales.dim_products(ProductID),
    CustomerID		INT NOT NULL,
    OrderDate		DATE NOT NULL,
    Quantity        INT NOT NULL,
    Sales			DECIMAL(10,2)
);
GO