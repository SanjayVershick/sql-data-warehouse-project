


/*

THIS CODE LOADS DATA INTO THE TABLE BY TRUNCATE AND BULK INSERT
To execute this as stored procedure use this
use DataWarehouse;
EXEC bronze.load_bronze;

*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME , @end_time DATETIME , @batch_start_time DATETIME , @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '==========================================='
		PRINT 'Bronze Layer Loading'
		PRINT '==========================================='

		PRINT '-------------------------------------------'
		PRINT 'Loading CRM Table'
		PRINT '-------------------------------------------'

		SET @start_time = GETDATE();
		PRINT 'TRUNCATE AND INSERTING DATA INTO bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info;
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Sanja\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' >> LOAD DURATION : ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' SECONDS. '
		PRINT '----------------------------------------------------'
		SET @start_time = GETDATE();
		PRINT 'TRUNCATE AND INSERTING DATA INTO bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info;
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Sanja\Desktop\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' >> LOAD DURATION : ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' SECONDS. '
		PRINT '----------------------------------------------------'
		SET @start_time = GETDATE();
		PRINT 'TRUNCATE AND INSERTING DATA INTO bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details;
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Sanja\Desktop\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' >> LOAD DURATION : ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' SECONDS. '
		PRINT '----------------------------------------------------'
		
		PRINT 'Loading ERP Table'
		PRINT '-------------------------------------------'
		SET @start_time = GETDATE();
		PRINT 'TRUNCATE AND INSERTING DATA INTO bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12;
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Sanja\Desktop\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' >> LOAD DURATION : ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' SECONDS. '
		PRINT '----------------------------------------------------'
		SET @start_time = GETDATE();
		PRINT 'TRUNCATE AND INSERTING DATA INTO bronze.erp_loc_a101'
		TRUNCATE TABLE bronze.erp_loc_a101;
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Sanja\Desktop\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' >> LOAD DURATION : ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' SECONDS. '
		PRINT '----------------------------------------------------'
		SET @start_time = GETDATE();
		PRINT 'TRUNCATE AND INSERTING DATA INTO bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Sanja\Desktop\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' >> LOAD DURATION : ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' SECONDS. '
		PRINT '----------------------------------------------------'
		SET @batch_end_time = GETDATE();
		PRINT ' >> LOAD DURATION FOR BRONZE LAYER ' + CAST(DATEDIFF(second , @batch_start_time , @batch_end_time) AS NVARCHAR) + ' SECONDS. '
	END TRY
		BEGIN CATCH
			PRINT '---------------------------------------------------'
			PRINT 'ERROR OCCURED DURING BRONZE LAYER LOADING '
			PRINT 'ERROR MESSAGE : '  + ERROR_MESSAGE();
			PRINT '---------------------------------------------------'
		END CATCH
END
 
