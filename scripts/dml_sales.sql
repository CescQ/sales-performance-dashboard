/*
===============================================================================
DML Script: Insert Data into Tables
===============================================================================
Script Purpose:
    This script insert data into the tables of 'sales' schema from external CSV files.
	It performs the following actions:
    - Truncates the tables before loading data.
    - Uses the `BULK INSERT` command to load data from CSV Files to tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC sales.load_sales;
===============================================================================
*/

CREATE OR ALTER PROCEDURE sales.load_sales AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '------------------------------------------------';
		PRINT 'Loading Tables';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: sales.dim_customers';
		DELETE FROM sales.dim_customers;
		PRINT '>> Inserting Data Into: sales.dim_customers';
		BULK INSERT sales.dim_customers
		FROM 'C:\Users\cescq\OneDrive\Cesc\Estudi\Cursillos\SQL\Projecte SQL\database\dim_customers.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: sales.dim_products';
		DELETE FROM sales.dim_products;
		PRINT '>> Inserting Data Into: sales.dim_products';
		BULK INSERT sales.dim_products
		FROM 'C:\Users\cescq\OneDrive\Cesc\Estudi\Cursillos\SQL\Projecte SQL\database\dim_products.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: sales.fact_sales';
		TRUNCATE TABLE sales.fact_sales;
		PRINT '>> Inserting Data Into: sales.fact_sales';
		BULK INSERT sales.fact_sales
		FROM 'C:\Users\cescq\OneDrive\Cesc\Estudi\Cursillos\SQL\Projecte SQL\database\fact_sales.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Sales Tables is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING SALES TABLES'
		PRINT 'Error Message ' + ERROR_MESSAGE();
		PRINT 'Error Message ' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message ' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END