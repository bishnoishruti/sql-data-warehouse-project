/*
==================================================
Creating Database and Schema
==================================================

Script Purpose:
    This script creates a new Database called "DataWarehouse" after checking if it already exists.
    Id the database already exists, it is dropped and recreated. Further, the script sets up three
    schemas within the database, 'bronze','silver' and 'gold'.

WARNING:
    Running this script will drop the "DataWarehouse" database if it already exists. 
    All data in the database will be permanently deleted. Procees with caution and
    ensure to have a proper backup before running this script.
*/

USE master;
GO 

--Drop and Recreate the "DataWarehouse" Database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = "DataWarehouse")
BEGIN
  ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE DataWarehouse;
END;
GO

--- Creating the new 'DataWarehouse' Database 
CREATE DATABASE DataWarehouse;
GO
  
USE DataWarehouse;
GO

--- Creating Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
