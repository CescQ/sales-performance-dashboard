/*
1. Calcular ventas totales y cantidad por cliente
*/
SELECT 
s.CustomerID, 
c.Company, 
sum(s.quantity) as TotalQuantity, 
sum(s.sales) as TotalSales 
FROM Sales.fact_sales as s 
join Sales.dim_customers as c on s.customerid = c.customerid 
group by s.customerid, c.company;

/* 
2. Calcular ventas totales por producto y categoria 
*/ 
SELECT 
s.ProductID, 
p.Product, 
p.Category, 
sum(s.sales) as TotalSales 
FROM Sales.fact_sales as s 
join Sales.dim_products as p on s.productid = p.productid 
group by s.productid, p.product, p.category; 

/* 
3. Top 5 clientes por ventas 
*/ 
select top 5 
s.CustomerID, 
c.Company, 
sum(s.sales) as TotalSales 
FROM Sales.fact_sales as s 
join Sales.dim_customers as c on s.customerid = c.customerid 
group by s.customerid, c.company 
order by sum(s.sales) desc; 

/* 
4. 
Top 5 productos por cantidad vendida 
*/ 
SELECT top 5 
s.ProductID, 
p.Product, 
p.Category, 
sum(s.quantity) as TotalQuantity 
FROM Sales.fact_sales as s 
join Sales.dim_products as p on s.productid = p.productid 
group by s.productid, p.product, p.category 
order by sum(s.quantity) desc; 

/* 
5. Ventas mensuales y tendencias 
*/ 
select 
datename(year, orderdate) as Year, 
datename(month, orderdate) as Month, 
sum(sales) as MonthTotalSales, 
avg(sales) as MonthAvgSales 
from Sales.fact_sales 
group by datename(month, orderdate), datename(year, orderdate); 

/*
6. Ranking clientes 
*/ 
select 
s.CustomerID, 
c.Company, 
rank() over (order by sum(s.sales) desc) as RankCustomersSales, 
sum(s.sales) as TotalSales 
from Sales.fact_sales as s 
join sales.dim_customers as c on s.customerid = c.customerid 
group by s.CustomerID, c.Company; 

/* 
7. Ranking productos por categoria 
*/ 
select 
s.ProductID, 
p.Product, 
p.Category, 
rank() over (partition by p.category order by sum(s.sales) desc) as RankCustomersSales, 
sum(s.sales) as TotalSales 
from Sales.fact_sales as s 
join sales.dim_products as p on s.productid = p.productid 
group by s.productid,p.Product, p.category;

/* 
8. Porcentaje contribución por cliente 
*/ 
select s.CustomerID, 
c.Company, 
sum(quantity) * 100 / (select sum(quantity) as TotalQuantity from sales.fact_sales) as ContributionQuantity, 
sum(sales) * 100 / (select sum(sales) as TotalSales from sales.fact_sales) as ContributionSales 
from Sales.fact_sales as s 
join sales.dim_customers as c on s.customerid = c.customerid 
group by s.CustomerID, c.Company; 

/* 
8. Acumulado ventas mes a mes 
*/ 
with CTE_MonthSum as ( 
	select 
	MONTH(orderdate) as OrderMonth, 
	sum(sales) as TotalSales 
	from Sales.fact_sales 
	group by MONTH(orderdate) 
); 
select 
OrderMonth, 
TotalSales, 
sum(totalsales) over (order by ordermonth) as AcumSales 
from CTE_MonthSum; 

-- Hecho con VIEWS 
create view Sales.V_MonthSum as ( 
	select 
	MONTH(orderdate) as OrderMonth, 
	sum(sales) as TotalSales, 
	count(orderid) as TotalOrders, 
	sum(quantity) as TotalQuantity 
	from Sales.fact_sales 
	group by MONTH(orderdate) 
); 
select 
OrderMonth, 
TotalSales, 
sum(totalsales) over (order by ordermonth) as AcumSales 
from Sales.V_MonthSum; 

/* 
9. Ventas acomuladas en el año 
*/ 
with CTE_YearSum as ( 
	select 
	year(orderdate) as OrderYear, 
	sum(sales) as TotalSales 
	from Sales.fact_sales 
	group by year(orderdate) 
); 
select 
OrderYear, 
TotalSales, 
sum(totalsales) over (order by orderyear) as AcumSales 
from CTE_YearSum; 

-- Hecho con VIEWS 
create view Sales.V_YearSum as ( 
	select 
	Year(orderdate) as OrderYear, 
	sum(sales) as TotalSales, 
	count(orderid) as TotalOrders, 
	sum(quantity) as TotalQuantity 
	from Sales.fact_sales 
	group by Year(orderdate) 
); 
select 
OrderYear, 
TotalSales, 
sum(totalsales) over (order by orderyear) as AcumSales 
from Sales.V_YearSum;

/*
Crear una vista maestra de análisis para Power BI
*/
alter view Sales.V_AnalizeSales as (
	select 
	s.OrderID as OrderID,
	s.OrderDate as OrderDate,
	year(s.OrderDate) as OrderYear,
	month(s.OrderDate) as OrderMonth,
	datename(month,s.OrderDate) as OrderMonthName,
	format(s.OrderDate, 'yyyy-MM') as OrderYearMonth,
	c.CustomerID as CustomerID,
	c.Company as CustomerCompany,
	c.Country as CustomerCountry,
	p.ProductID as ProductID,
	p.Product as ProductName,
	p.Category as ProductCategory,
	s.Quantity as Quantity,
	s.Sales as Sales
	from Sales.fact_sales as s
	join Sales.dim_customers as c on s.CustomerID = c.CustomerID
	join Sales.dim_products as p on s.ProductID = p.ProductID
);

/*
KPI: Average Order Value (AOV)
*/
select
cast(sum(Sales) as decimal(18,2)) / count(distinct(OrderID)) as AOV
from Sales.fact_sales

/*
KPI: Sales per Customer
*/
select
sum(s.sales) / count(distinct(c.company)) as SalesXCustomer
from Sales.fact_sales as s
join Sales.dim_customers as c on s.CustomerID = c.CustomerID;