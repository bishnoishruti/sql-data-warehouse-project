/*
========================================================
Stored Procedure : Load Bronze Layer (Source -> Bronze)
========================================================

Script Purpose:
      This script of stored procedure loads the data from the the external CSV files into 'bronze' schema.
      - It truncates the bronze tables before loading data.
      - Uses 'Bulk Insert' command to load data into bronze tables from CSV files.

Parameters:
      None.
      This stored procedure does not accept any parameters or return any value.

Usage:
      EXEC bronze.load_bronze;
========================================================
*/

USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @bronze_batch_start_time DATETIME, @bronze_batch_end_time DATETIME;
	BEGIN TRY
	SET @bronze_batch_start_time = GETDATE()
	PRINT 'Load the Bronze Layer';

	PRINT ''
	PRINT 'Loading the CRM Tables';
	PRINT ''

	SET @start_time = GETDATE();
	PRINT 'Truncated bronze.crm_cust_info and inserted data';

	TRUNCATE TABLE bronze.crm_cust_info;
	BULK INSERT bronze.crm_cust_info
	FROM 'D:\Projects\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_Time) AS NVARCHAR) + 'seconds';
	PRINT ''

	SET @start_time = GETDATE();
	PRINT 'Truncated bronze.crm_prd_info and inserted data';
	TRUNCATE TABLE bronze.crm_prd_info;
	BULK INSERT bronze.crm_prd_info
	FROM 'D:\Projects\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_Time) AS NVARCHAR) + 'seconds';
	PRINT ''

	SET @start_time = GETDATE();
	PRINT 'Truncated bronze.crm_sales_details and inserted data';
	TRUNCATE TABLE bronze.crm_sales_details;
	BULK INSERT bronze.crm_sales_details
	FROM 'D:\Projects\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_Time) AS NVARCHAR) + 'seconds';
	PRINT ''

	PRINT 'Loading the ERP Tables';
	PRINT ''

	SET @start_time = GETDATE();
	PRINT 'Truncated bronze.erp_cust_az12 and inserted data';
	TRUNCATE TABLE bronze.erp_cust_az12;
	BULK INSERT bronze.erp_cust_az12
	FROM 'D:\Projects\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_Time) AS NVARCHAR) + 'seconds';
	PRINT ''

	SET @start_time = GETDATE();
	PRINT 'Truncated bronze.erp_loc_a101 and inserted data';
	TRUNCATE TABLE bronze.erp_loc_a101;
	BULK INSERT bronze.erp_loc_a101
	FROM 'D:\Projects\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_Time) AS NVARCHAR) + 'seconds';
	PRINT ''

	SET @start_time = GETDATE();
	PRINT 'Truncated bronze.erp_px_cat_g1v2 and inserted data';
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	BULK INSERT bronze.erp_px_cat_g1v2
	FROM 'D:\Projects\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_Time) AS NVARCHAR) + 'seconds';
	PRINT ''

	SET @bronze_batch_end_time = GETDATE();

	PRINT 'Total Load time of Bronze Layer Batch:' + CAST(DATEDIFF(second, @bronze_batch_start_time, @bronze_batch_end_time) AS NVARCHAR) + 'seconds';
	PRINT ''

	END TRY
	BEGIN CATCH
	PRINT 'Error Occured during Loading Bronze Layer'
	PRINT 'Error Message:' + ERROR_MESSAGE();
	PRINT 'Error Message:' + CAST(ERROR_NUMBER() AS NVARCHAR);
	PRINT 'Error Message:' + CAST(ERROR_STATE() AS NVARCHAR);
	END CATCH
END;

GO
EXEC bronze.load_bronze;
