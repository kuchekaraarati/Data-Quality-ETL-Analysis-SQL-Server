use Operations_ETL_DB;

-- Create final cleaned service_request table
-- Raw table remains unchanged

IF OBJECT_ID('dbo.service_request_clean_final', 'U') IS NOT NULL
    DROP TABLE service_request_clean_final;

SELECT
    Request_ID,
    Customer_ID,
    Facility_ID,
    Technician_ID,

    -- Convert valid DD-MM-YYYY dates to DATE
    -- Invalid dates become NULL
    TRY_CONVERT(DATE, Request_Date, 105) AS Clean_Request_Date,

    -- Flag date quality
    CASE
        WHEN TRY_CONVERT(DATE, Request_Date, 105) IS NULL
            THEN 'Invalid Date'
        ELSE 'Valid'
    END AS Date_Quality,

    -- Keep original status
    Status AS Raw_Status,

    -- Standardize status
    CASE
        WHEN LOWER(LTRIM(RTRIM(Status))) = 'open'
            THEN 'Open'
        WHEN LOWER(LTRIM(RTRIM(Status))) IN ('in-progress', 'in progress')
            THEN 'In Progress'
        WHEN LOWER(LTRIM(RTRIM(Status))) IN ('comp', 'completed')
            THEN 'Completed'
        WHEN LOWER(LTRIM(RTRIM(Status))) = 'cancelled'
            THEN 'Cancelled'
        ELSE 'Unknown'
    END AS Clean_Status,

    -- Keep Priority as source value
    Priority

INTO service_request_clean_final

FROM service_request_raw;

-- View final table
SELECT *
FROM service_request_clean_final;


-- ============================================================
-- CLEAN CUSTOMERS TABLE
-- Raw table remains unchanged.
-- ============================================================

IF OBJECT_ID('dbo.customers_clean', 'U') IS NOT NULL
    DROP TABLE customers_clean;


SELECT
    -- Customer ID
    LTRIM(RTRIM(Customer_ID)) AS Customer_ID,

    -- Customer Name
    LTRIM(RTRIM(Customer_Name)) AS Customer_Name,

    -- Customer Type
    LTRIM(RTRIM(Customer_Type)) AS Customer_Type,

    -- City
    LTRIM(RTRIM(City)) AS City,

    -- Email
    LTRIM(RTRIM(Email)) AS Email,

    -- Phone
    LTRIM(RTRIM(Phone)) AS Phone

INTO customers_clean

FROM customers_raw;


-- Check the cleaned table
SELECT *
FROM customers_clean;


IF OBJECT_ID('dbo.customers_clean', 'U') IS NOT NULL
    DROP TABLE customers_clean;

SELECT
    LTRIM(RTRIM(Customer_ID)) AS Customer_ID,
    LTRIM(RTRIM(Customer_Name)) AS Customer_Name,
    LTRIM(RTRIM(Customer_Type)) AS Customer_Type,
    LTRIM(RTRIM(City)) AS City,
    LTRIM(RTRIM(Email)) AS Email,
    LTRIM(RTRIM(Phone)) AS Phone

INTO customers_clean

FROM customers_raw;

-- Basic validation
SELECT COUNT(*) AS Clean_Record_Count
FROM customers_clean;


-- ============================================================
-- CLEAN FACILITIES TABLE
-- Raw table remains unchanged.
-- ============================================================

IF OBJECT_ID('dbo.facilites_clean', 'U') IS NOT NULL
    DROP TABLE facilities_clean;

SELECT
    LTRIM(RTRIM(Facility_ID)) AS Facility_ID,
    LTRIM(RTRIM(Customer_ID)) AS Customer_ID,
    LTRIM(RTRIM(Facility_Name)) AS Facility_Name,
    LTRIM(RTRIM(Facility_Type)) AS Facility_Type,
    LTRIM(RTRIM(City)) AS City

INTO facilities_clean

FROM facilities_raw;


-- Basic validation
SELECT COUNT(*) AS Clean_Record_Count
FROM facilities_clean;


-- ============================================================
-- CLEAN PRODUCTS TABLE
-- Raw table remains unchanged.
-- ============================================================

IF OBJECT_ID('dbo.products_clean', 'U') IS NOT NULL
    DROP TABLE products_clean;

SELECT
    LTRIM(RTRIM(Product_ID)) AS Product_ID,
    LTRIM(RTRIM(Product_Name)) AS Product_Name,
    LTRIM(RTRIM(Category)) AS Category,
    LTRIM(RTRIM(Unit)) AS Unit

INTO products_clean

FROM Products_raw;


-- Basic validation
SELECT COUNT(*) AS Clean_Record_Count
FROM products_clean;


-- ============================================================
-- CLEAN TECHNICIANS TABLE
-- Purpose: Remove extra spaces from text fields.
-- Raw table remains unchanged.
-- ============================================================

-- If the clean table already exists, remove it first
IF OBJECT_ID('dbo.technicians_clean', 'U') IS NOT NULL
    DROP TABLE technicians_clean;


-- Create the cleaned table
SELECT
    LTRIM(RTRIM(Technician_ID)) AS Technician_ID,       -- Remove extra spaces
    LTRIM(RTRIM(Technician_Name)) AS Technician_Name,   -- Clean technician name
    LTRIM(RTRIM(Region)) AS Region,                     -- Clean region
    LTRIM(RTRIM(Status)) AS Status                      -- Clean status
INTO technicians_clean
FROM technicians_raw;


-- Basic validation: check that all 100 records are retained
SELECT COUNT(*) AS Clean_Record_Count
FROM technicians_clean;


-- ============================================================
-- CLEAN SERVICE TRANSACTIONS TABLE
-- Purpose:
-- 1. Remove extra spaces from ID/text fields
-- 2. Convert Service_Date into DATE format
-- 3. Identify invalid dates
-- 4. Convert Quantity into numeric value
-- 5. Standardize Status
-- Raw table remains unchanged.
-- ============================================================


-- Drop the clean table if it already exists
IF OBJECT_ID('dbo.service_transactions_clean', 'U') IS NOT NULL
    DROP TABLE service_transactions_clean;


-- Create the cleaned table
SELECT
    LTRIM(RTRIM(Transaction_ID)) AS Transaction_ID,
    LTRIM(RTRIM(Request_ID)) AS Request_ID,
    LTRIM(RTRIM(Customer_ID)) AS Customer_ID,
    LTRIM(RTRIM(Facility_ID)) AS Facility_ID,
    LTRIM(RTRIM(Product_ID)) AS Product_ID,
    LTRIM(RTRIM(Technician_ID)) AS Technician_ID,

    -- Convert Service_Date from DD-MM-YYYY to DATE
    TRY_CONVERT(DATE, Service_Date, 105) AS Clean_Service_Date,

    -- Identify valid and invalid dates
    CASE
        WHEN TRY_CONVERT(DATE, Service_Date, 105) IS NULL
            THEN 'Invalid Date'
        ELSE 'Valid'
    END AS Date_Quality,

    -- Keep original quantity as numeric value
    TRY_CONVERT(INT, Quantity) AS Clean_Quantity,

    -- Keep original status for traceability
    Status AS Raw_Status,

    -- Standardize status values
    CASE
        WHEN LOWER(LTRIM(RTRIM(Status))) = 'completed'
            THEN 'Completed'

        WHEN LOWER(LTRIM(RTRIM(Status))) IN ('in-progress', 'in progress')
            THEN 'In Progress'

        WHEN LOWER(LTRIM(RTRIM(Status))) = 'open'
            THEN 'Open'

        WHEN LOWER(LTRIM(RTRIM(Status))) = 'cancelled'
            THEN 'Cancelled'

        ELSE 'Unknown'
    END AS Clean_Status

INTO service_transactions_clean

FROM service_transactions_raw;


-- ============================================================
-- BASIC VALIDATION
-- Check that all 5,004 raw records are retained.
-- ============================================================

SELECT COUNT(*) AS Clean_Record_Count
FROM service_transactions_clean;