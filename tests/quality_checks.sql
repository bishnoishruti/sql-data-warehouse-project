-- Check for Null Values or Duplicates in Primary Key (Before Load)

SELECT
	cst_id,
	COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)> 1 OR cst_id IS NULL;

SELECT 
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_recent
FROM bronze.crm_cust_info
WHERE cst_id = 29466;

SELECT
*
FROM (
		SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_recent
		FROM bronze.crm_cust_info
		WHERE cst_id IS NOT NULL
) t WHERE flag_recent = 1;

-- Check for Whitespace
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Fixing Whitespace
SELECT cst_id,
cst_key,
TRIM(cst_firstname),
TRIM(cst_lastname),
cst_marital_status,
cst_gndr,
cst_create_date
FROM bronze.crm_cust_info;

-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info;

-- Check for Null Values or Duplicates in Primary Key (After Load)
SELECT
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)> 1 OR cst_id IS NULL;

SELECT 
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_recent
FROM silver.crm_cust_info
WHERE cst_id = 29466;

-- Check for Whitespace
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

SELECT *
FROM silver.crm_cust_info;

-- Check for Null Values or Duplicates in Primary Key (Before Loading)
SELECT * FROM bronze.crm_prd_info;

SELECT
	prd_id,
	COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)> 1 OR prd_id IS NULL;


-- Check for Whitespace
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLS or Negative Numbers
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data Standardisation & Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- Check for Invalid Date Orders
SELECT 
	CONVERT(DATE, prd_start_dt, 105) AS prd_start_dt,
	CONVERT(DATE, prd_end_dt, 105) AS prd_end_dt
FROM bronze.crm_prd_info
WHERE CONVERT(DATE, prd_end_dt, 105) < CONVERT(DATE, prd_start_dt, 105)

-- Check for Null Values or Duplicates in Primary Key (After Loading)
SELECT * FROM silver.crm_prd_info;

SELECT
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)> 1 OR prd_id IS NULL;


-- Check for Whitespace
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLS or Negative Numbers
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data Standardisation & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Check for Invalid Date Orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- Check (Before Loading)

SELECT * FROM bronze.crm_sales_details

-- Check for Invalid Dates
SELECT 
NULLIF(sls_order_dt, 0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0
OR LEN(sls_order_dt) !=8
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101;

SELECT 
NULLIF(sls_ship_dt, 0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0
OR LEN(sls_ship_dt) !=8
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101;

SELECT 
NULLIF(sls_due_dt, 0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
OR LEN(sls_due_dt) !=8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101

-- Check for Invalid Ddate Orders
SELECT
*
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- Checking Data Consistency: For Sales, Quantity and Price
-- Sales = Quantity * Price
-- Valyes must not be NULL, zero, or negative

SELECT DISTINCT
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,

CASE WHEN sls_price IS NULL OR sls_price <=0
		THEN sls_sales / NULLIF(sls_quantity,0)
	ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <=0
ORDER BY sls_sales, sls_quantity, sls_price;

--After Loading
SELECT * FROM silver.crm_sales_details;

-- Check for Invalid Ddate Orders
SELECT
*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt


-- Checking Data Consistency: For Sales, Quantity and Price
-- Sales = Quantity * Price
-- Valyes must not be NULL, zero, or negative

SELECT DISTINCT
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,

CASE WHEN sls_price IS NULL OR sls_price <=0
		THEN sls_sales / NULLIF(sls_quantity,0)
	ELSE sls_price
END AS sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <=0
ORDER BY sls_sales, sls_quantity, sls_price;

-- Before Loading
--Identifying Out-of-Range Dates

SELECT DISTINCT
CONVERT(DATE, bdate, 105) AS bdate
FROM bronze.erp_cust_az12
WHERE CONVERT(DATE, bdate, 105) < '1924-01-01' 
OR CONVERT(DATE, bdate, 105) > GETDATE();

--Data Standardization & Consistency
SELECT DISTINCT 
gen,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'Female') THEN 'Female'
	 WHEN UPPER(TRIM(gen)) IN ('M', 'Male') THEN 'Male'
	 ELSE 'Unknown'
END AS gen
FROM bronze.erp_cust_az12;

-- After Load
-- Dates Out of Range
SELECT DISTINCT
CONVERT(DATE, bdate, 105) AS bdate
FROM silver.erp_cust_az12
WHERE CONVERT(DATE, bdate, 105) < '1924-01-01' 
OR CONVERT(DATE, bdate, 105) > GETDATE();

--Data Standardization & Consistency
SELECT DISTINCT 
gen
FROM silver.erp_cust_az12;

SELECT * FROM silver.erp_cust_az12;

--Before Load

-- Data Standardization & Consistency
SELECT DISTINCT
cntry
FROM bronze.erp_loc_a101
ORDER BY cntry;

SELECT DISTINCT
cntry AS old_cntry,
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
	 WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
	 WHEN TRIM(cntry) = '' OR cntry is NULL THEN 'Unknown'
	 ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101
ORDER BY old_cntry;

-- After load
SELECT DISTINCT
cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

SELECT * FROM silver.erp_loc_a101;

--Before Load

-- Unwanted Spaces
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

--Data Standardization & Consistency
SELECT DISTINCT
cat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT
subcat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT
maintenance
FROM bronze.erp_px_cat_g1v2;

-- After load
SELECT * FROM silver.erp_px_cat_g1v2;
