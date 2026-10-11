/*
===============================================================================
Stored Procedure: Load Bronze Layer
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema tables from
    external CSV files using full refresh (TRUNCATE & LOAD).
    It includes execution duration tracking and robust error handling.

Usage:
    CALL bronze.load_bronze();
===============================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    -- Timing Variables
    batch_start_time   TIMESTAMP;
    batch_end_time     TIMESTAMP;
    total_duration_sec NUMERIC(10, 2);

    -- Error Handling Variables
    v_error_msg        TEXT;
    v_error_state      TEXT;
BEGIN
    batch_start_time := clock_timestamp();

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Bronze Layer Started';
    RAISE NOTICE '================================================';

    ---------------------------------------------------------------------------
    -- 1. Loading CRM Tables
    ---------------------------------------------------------------------------
    RAISE NOTICE '>> Truncating & Loading CRM Tables...';

    -- bronze.crm_cust_info
    TRUNCATE TABLE bronze.crm_cust_info;
    COPY bronze.crm_cust_info 
    FROM 'C:/DATA ENGNIEER PROJECT CSV FILES/datasets/source_crm/cust_info.csv' 
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    -- bronze.crm_prd_info
    TRUNCATE TABLE bronze.crm_prd_info;
    COPY bronze.crm_prd_info 
    FROM 'C:/DATA ENGNIEER PROJECT CSV FILES/datasets/source_crm/prd_info.csv' 
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    -- bronze.crm_sales_details
    TRUNCATE TABLE bronze.crm_sales_details;
    COPY bronze.crm_sales_details 
    FROM 'C:/DATA ENGNIEER PROJECT CSV FILES/datasets/source_crm/sales_details.csv' 
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    ---------------------------------------------------------------------------
    -- 2. Loading ERP Tables
    ---------------------------------------------------------------------------
    RAISE NOTICE '>> Truncating & Loading ERP Tables...';

    -- bronze.erp_cust_az12
    TRUNCATE TABLE bronze.erp_cust_az12;
    COPY bronze.erp_cust_az12 
    FROM 'C:/DATA ENGNIEER PROJECT CSV FILES/datasets/source_erp/CUST_AZ12.csv' 
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    -- bronze.erp_loc_a101
    TRUNCATE TABLE bronze.erp_loc_a101;
    COPY bronze.erp_loc_a101 
    FROM 'C:/DATA ENGNIEER PROJECT CSV FILES/datasets/source_erp/LOC_A101.csv' 
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    -- bronze.erp_px_cat_g1v2
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    COPY bronze.erp_px_cat_g1v2 
    FROM 'C:/DATA ENGNIEER PROJECT CSV FILES/datasets/source_erp/PX_CAT_G1V2.csv' 
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    -- Execution Tracking
    batch_end_time := clock_timestamp();
    total_duration_sec := ROUND(EXTRACT(EPOCH FROM (batch_end_time - batch_start_time))::NUMERIC, 2);

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Bronze Layer Loading Completed Successfully';
    RAISE NOTICE 'Total Batch Duration: % Seconds (% Interval)', 
                 total_duration_sec, 
                 (batch_end_time - batch_start_time);
    RAISE NOTICE '================================================';

---------------------------------------------------------------------------
-- Error Handling
---------------------------------------------------------------------------
EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            v_error_msg   = MESSAGE_TEXT,
            v_error_state = RETURNED_SQLSTATE;

        RAISE NOTICE '================================================';
        RAISE WARNING 'ERROR OCCURRED WHILE LOADING BRONZE LAYER!';
        RAISE WARNING 'Error Message: %', v_error_msg;
        RAISE WARNING 'SQL State Code: %', v_error_state;
        RAISE NOTICE '================================================';
END;
$$;
