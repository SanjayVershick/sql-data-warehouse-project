
/*EXEC silver.load_silver;*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME , @end_time DATETIME , @batch_start_time DATETIME , @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();

		PRINT '==========================================='
		PRINT 'Silver Layer Loading'
		PRINT '==========================================='

		PRINT '-------------------------------------------'
		PRINT 'Loading CRM Table'
		PRINT '-------------------------------------------'

		SET @start_time = GETDATE();
		TRUNCATE TABLE silver.crm_cust_info;
		INSERT INTO silver.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_material_status,
			cst_gndr,
			cst_create_date
		)
		SELECT
			cst_id,
			cst_key,
			TRIM(cst_firstname),
			TRIM(cst_lastname),
			CASE 
				WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
				WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
				ELSE 'n/a'
			END,
			CASE 
				WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				ELSE 'n/a'
			END,
			cst_create_date
		FROM (
			SELECT *,
				ROW_NUMBER() OVER (
					PARTITION BY cst_id
					ORDER BY cst_create_date DESC
				) AS flag_last
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		) T
		WHERE flag_last = 1;
		SET @end_time = GETDATE();
		PRINT ' >> LOAD DURATION : ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' SECONDS. '
		PRINT '----------------------------------------------------'

		SET @start_time = GETDATE();
		TRUNCATE TABLE silver.crm_prd_info;
		INSERT INTO silver.crm_prd_info(
			prd_id ,
			cat_id ,
			prd_key ,
			prd_nm ,
			prd_cost ,
			prd_line ,
			prd_start_dt ,
			prd_end_dt 
		)
		SELECT 
			prd_id,
			REPLACE(SUBSTRING(prd_key , 1 , 5),'-' , '_') as cat_id,
			SUBSTRING(prd_key , 7 , LEN(prd_key)) as prd_key,
			prd_nm,
			ISNULL(prd_cost , 0) AS prd_cost,
			CASE UPPER(TRIM(prd_line))
				 WHEN  'M' THEN 'Mountain'
				 WHEN  'R' THEN 'Road'
				 WHEN  'S' THEN 'Other Sales'
				 WHEN  'T' THEN 'Touring'
			ELSE 'n/a'
			END AS prd_line,
			CAST (prd_start_dt AS DATE) prd_start_dt,
			CAST(LEAD(prd_start_dt)OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
		FROM bronze.crm_prd_info ; 
		SET @end_time = GETDATE();
		PRINT ' >> LOAD DURATION : ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' SECONDS. '
		PRINT '----------------------------------------------------'

		SET @start_time = GETDATE();
		TRUNCATE TABLE silver.crm_sales_details;
		INSERT INTO silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)

		SELECT 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE WHEN LEN(sls_order_dt) != 8 OR sls_order_dt <= 0 THEN NULL
					ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE )
			END AS sls_order_dt,
			CASE WHEN LEN(sls_ship_dt) != 8 OR sls_ship_dt <= 0 THEN NULL
					ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE )
			END AS sls_ship_dt,
			CASE WHEN LEN(sls_due_dt) != 8 OR sls_due_dt <= 0 THEN NULL
					ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE )
			END AS sls_due_dt,
			CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
				THEN sls_quantity * ABS(sls_price)
				ELSE sls_sales
			END AS sls_sales,
			sls_quantity,
			CASE WHEN sls_price IS NULL OR sls_price <= 0
				THEN sls_sales / NULLIF(sls_quantity , 0)
				ELSE sls_price
			END AS sls_price
		FROM bronze.crm_sales_details;
		SET @end_time = GETDATE();
		PRINT ' >> LOAD DURATION : ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' SECONDS. '
		PRINT '----------------------------------------------------'

		
		PRINT '-------------------------------------------'
		PRINT 'Loading ERP Table'
		PRINT '-------------------------------------------'

		SET @start_time = GETDATE();
		TRUNCATE TABLE silver.erp_cust_az12;
		INSERT INTO silver.erp_cust_az12(
			cid,
			bdate,
			gen
		)
		SELECT 
		SUBSTRING(cid , 4 , LEN(CID)) AS  cid,
		CASE 
		WHEN bdate > GETDATE() THEN NULL
		ELSE bdate
		END AS bdate,
		CASE WHEN gen = 'M' or gen = 'Male' THEN 'Male'
			 WHEN gen = 'F' or gen = 'Female' THEN 'Female'
			 ELSE 'n/a'
		END AS gen
		FROM bronze.erp_cust_az12;
		SET @end_time = GETDATE();
		PRINT ' >> LOAD DURATION : ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' SECONDS. '
		PRINT '----------------------------------------------------'

		SET @start_time = GETDATE();
		TRUNCATE TABLE silver.erp_loc_a101;
		INSERT INTO silver.erp_loc_a101(
			cid,
			cntry
		)
		SELECT
			REPLACE(cid , '-' ,'') as cid,
			CASE WHEN TRIM(cntry) IN ('USA' , 'US') THEN 'United States'
				 WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
			ELSE TRIM(cntry)
			END AS cntry
		FROM bronze.erp_loc_a101;
		SET @end_time = GETDATE();
		PRINT ' >> LOAD DURATION : ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' SECONDS. '
		PRINT '----------------------------------------------------'

		SET @start_time = GETDATE();
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		INSERT INTO silver.erp_px_cat_g1v2(
			id,
			cat,
			subcat,
			Maintenance
		)
		SELECT
			id,
			cat,
			subcat,
			Maintenance
		FROM bronze.erp_px_cat_g1v2;
		SET @end_time = GETDATE();
		PRINT ' >> LOAD DURATION : ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' SECONDS. '
		PRINT '----------------------------------------------------'

		SET @batch_end_time = GETDATE();
		PRINT ' >> LOAD DURATION FOR SILVER LAYER ' + CAST(DATEDIFF(second , @batch_start_time , @batch_end_time) AS NVARCHAR) + ' SECONDS. '
	END TRY
	BEGIN CATCH
			PRINT '---------------------------------------------------'
			PRINT 'ERROR OCCURED DURING SILVER LAYER LOADING '
			PRINT 'ERROR MESSAGE : '  + ERROR_MESSAGE();
			PRINT '---------------------------------------------------'
	END CATCH
END
