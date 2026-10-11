/*
===============================================================================
Create Database and Schemas
===============================================================================
Script Purpose:
    This script initializes the Data Warehouse environment. It creates 
    three schemas within the 'DataWarehouse' database: 'bronze', 'silver', 
    and 'gold' representing the Medallion Architecture.

WARNING:
    In PostgreSQL, databases cannot be dropped while active connections exist.
    Ensure you are connected to the 'DataWarehouse' database before creating 
    the schemas.
===============================================================================
*/

-- Step 1: Create Schemas if they do not exist
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

-- Step 2: Verify created schemas
SELECT 
    schema_name 
FROM 
    information_schema.schemata 
WHERE 
    schema_name IN ('bronze', 'silver', 'gold');
