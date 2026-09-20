Use Operations_ETL_DB;

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN
(
    'customers_raw',
    'facilities_raw',
    'products_raw',
    'technicians_raw',
    'service_request_raw',
    'service_transactions_raw'
)
ORDER BY TABLE_NAME, ORDINAL_POSITION;



SELECT 
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;


select * from customers_raw;

Exec sp_rename 'dbo.customers_raw.State','Email','Column';

Exec sp_rename 'dbo.customers_raw.Country','Phone','Column';


--1.Customer_raw

-- Check total rows and missing/blank values in customers_raw
SELECT
    COUNT(*) AS Total_Rows,

    -- Check if Customer_ID is NULL or empty
    SUM(
        CASE 
            WHEN Customer_ID IS NULL 
              OR LTRIM(RTRIM(Customer_ID)) = '' 
            THEN 1 
            ELSE 0 
        END
    ) AS Missing_Customer_ID,

    -- Check if Customer_Name is NULL or empty
    SUM(
        CASE 
            WHEN Customer_Name IS NULL 
              OR LTRIM(RTRIM(Customer_Name)) = '' 
            THEN 1 
            ELSE 0 
        END
    ) AS Missing_Customer_Name,

    -- Check if Customer_Type is NULL or empty
    SUM(
        CASE 
            WHEN Customer_Type IS NULL 
              OR LTRIM(RTRIM(Customer_Type)) = '' 
            THEN 1 
            ELSE 0 
        END
    ) AS Missing_Customer_Type,

    -- Check if City is NULL or empty
    SUM(
        CASE 
            WHEN City IS NULL 
              OR LTRIM(RTRIM(City)) = '' 
            THEN 1 
            ELSE 0 
        END
    ) AS Missing_City,

    -- Check if Email is NULL or empty
    SUM(
        CASE 
            WHEN Email IS NULL 
              OR LTRIM(RTRIM(Email)) = '' 
            THEN 1 
            ELSE 0 
        END
    ) AS Missing_Email,

    -- Check if Phone is NULL or empty
    SUM(
        CASE 
            WHEN Phone IS NULL 
              OR LTRIM(RTRIM(Phone)) = '' 
            THEN 1 
            ELSE 0 
        END
    ) AS Missing_Phone

FROM customers_raw;

-- Find the customer record where Customer_Name is missing
SELECT *
FROM customers_raw
WHERE Customer_Name IS NULL
   OR LTRIM(RTRIM(Customer_Name)) = '';

-- Find the customer record where Email is missing
SELECT *
FROM customers_raw
WHERE Email IS NULL
   OR LTRIM(RTRIM(Email)) = '';

-- Check for duplicate Customer_ID values
SELECT
    Customer_ID,
    COUNT(*) AS Duplicate_Count
FROM customers_raw
GROUP BY Customer_ID
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;

-- Show all records for the duplicated Customer_IDs
SELECT *
FROM customers_raw
WHERE Customer_ID IN ('C0101', 'C0201', 'C0301')
ORDER BY Customer_ID;


--2.Facility Table

select * from facilities_raw;

-- Check for duplicate Facility_ID values

SELECT
    Facility_ID,
    COUNT(*) AS Duplicate_Count
FROM facilities_raw
GROUP BY Facility_ID
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;

-- Show the duplicated facility records
SELECT *
FROM dbo.facilities_raw
WHERE Facility_ID IN ('F0151', 'F0251')
ORDER BY Facility_ID;


--3.Product table 

select * from Products_raw

-- Check for duplicate Product_ID values

SELECT
    Product_ID,
    COUNT(*) AS Duplicate_Count
FROM Products_raw
GROUP BY Product_ID
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;

-- Show the duplicated product records

SELECT *
FROM Products_raw
WHERE Product_ID IN ('P0046', 'P0071')
ORDER BY Product_ID;



--4.Technician table

SELECT *
FROM technicians_raw;

-- Check whether any Technician_ID appears more than once
SELECT
    Technician_ID,
    COUNT(*) AS Duplicate_Count
FROM technicians_raw
GROUP BY Technician_ID
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;


-- Check NULL or blank values in technician columns

select 
      count(*) as Total_Row,
	  --missing value in technicianID
	       sum(case
	             when Technician_ID IS NULL or LTRIM(RTRIM(Technician_ID)) = ''
	             then 1
			     else 0
	           end
			  ) as Missing_Technician_id,

			sum(case
			      when Technician_Name IS NULL or ltrim(RTRIM(Technician_Name)) = ''
				  then 1
				  else 0
			      end
				  ) as missing_Technician_name,

            sum(case
	              when Region IS NULL or LTRIM(RTRIM(Region)) = ''
	              then 1 
				  else 0
	              end
				  ) as Missing_Region,

			sum(case
	             when Status IS NULL or LTRIM(RTRIM(Status)) = ''
	             then 1 
			     else 0
	             end
			   ) as Missing_Status
    
	from technicians_raw;

-- Find the missing records where region is null

select *
from technicians_raw
where Region is null
or LTRIM(RTRIM(Region)) = '';

-- Check all unique Region values
SELECT
    Region,
    COUNT(*) AS Record_Count
FROM technicians_raw
GROUP BY Region
ORDER BY Region;

-- Check all unique technician Status values
SELECT
    Status,
    COUNT(*) AS Record_Count
FROM technicians_raw
GROUP BY Status
ORDER BY Status;


--5.Service_Request_raw

select * from service_request_raw;

-- Check total records in service_request_raw
SELECT COUNT(*) AS Total_Rows
FROM service_request_raw;

-- Check NULL or blank values in service request columns

select 
      count(*) as total_Row,
	                sum(case
					    when Request_ID is null or LTRIM(RTRIM(Request_ID)) = ''
						THEN 1 ELSE 0
					end) AS missing_Request_id,

					sum(case
					     when Customer_ID is null or LTRIM(RTRIM(Customer_ID)) = ''
						 then 1 else 0
					end) as missing_customer_id,

					sum(case
					      when Facility_ID is null or LTRIM(RTRIM(Facility_ID)) = ''
						  then 1 else 0
					end) as missing_facility_id,

					 sum(case
					    when Technician_ID is null or LTRIM(RTRIM(Technician_ID)) = ''
						THEN 1 ELSE 0
					end) AS missing_Technician_id,

					 sum(case
					    when Request_Date is null or LTRIM(RTRIM(Request_Date)) = ''
						THEN 1 ELSE 0
					end) AS missing_Request_day,

					 sum(case
					    when Status is null or LTRIM(RTRIM(Status)) = ''
						THEN 1 ELSE 0
					end) AS missing_Status,

					 sum(case
					    when Priority is null or LTRIM(RTRIM(Priority)) = ''
						THEN 1 ELSE 0
					end) AS missing_Priority

from service_request_raw;


-- Find the service request where Technician_ID is missing
SELECT *
FROM service_request_raw
WHERE Technician_ID IS NULL
   OR LTRIM(RTRIM(Technician_ID)) = '';

-- Check whether any Request_ID appears more than once / Duplicte records

select 
     Request_ID,
	    count(*) as Duplicate_count
	from service_request_raw
	group by Request_ID
	having count(*) > 1
	order by Duplicate_count desc;


-- Check the full records for the duplicated Request_IDs

select * 
from service_request_raw
where Request_ID in ('SR00201','SR00401','SR00601')
order by Request_ID;

-- Check all unique Status values in service requests
SELECT
    Status,
    COUNT(*) AS Record_Count
FROM service_request_raw
GROUP BY Status
ORDER BY Status;

-- Find the record where Status is abbreviated as COMP
select *
from service_request_raw
where status = 'COMP';

-- Check all unique Priority values in service requests
SELECT Priority,
      count(*) as Record_count
 from service_request_raw
 group by Priority
 order by Priority;

 -- Find the service request where Priority is missing
 select *
 from service_request_raw
 where Priority is null or
 LTRIM(RTRIM(Priority)) = '';

-- Show Priority values with brackets so spaces/blanks are visible
SELECT
    '[' + ISNULL(Priority, 'NULL') + ']' AS Priority_Check,
    COUNT(*) AS Record_Count
FROM service_request_raw
GROUP BY Priority
ORDER BY Priority_Check;

-- Find the service request where Priority contains only spaces
SELECT *
FROM service_request_raw
WHERE Priority IS NULL
   OR LTRIM(RTRIM(Priority)) = '';

-- Check the actual Priority value and its length
SELECT
    Priority,
    LEN(Priority) AS Value_Length,
    DATALENGTH(Priority) AS Data_Length
FROM service_request_raw
WHERE Priority = ' ';

-- Check the first character of the Priority value
-- This helps identify hidden/special characters
SELECT
    Priority,
    LEN(Priority) AS Value_Length,
    DATALENGTH(Priority) AS Data_Length,
    ASCII(LEFT(Priority, 1)) AS First_Character_Code
FROM service_request_raw
WHERE Priority IS NOT NULL
ORDER BY Value_Length;

-- Find the service request containing the hidden carriage-return character
SELECT *
FROM service_request_raw
WHERE ASCII(LEFT(Priority, 1)) = 13;

-- Check the different Request_Date formats/values
SELECT
    Request_Date,
    COUNT(*) AS Record_Count
FROM service_request_raw
GROUP BY Request_Date
ORDER BY Request_Date;

SELECT
    Request_ID,
    Request_Date,
    TRY_CONVERT(date, Request_Date, 105) AS Clean_Request_Date
FROM service_request_raw;


use Operations_ETL_DB;

-- Step 1: Check the raw Request_Date values
-- TRY_CONVERT converts DD-MM-YYYY text into a proper DATE.
-- If the date is invalid, TRY_CONVERT returns NULL instead of an error.

SELECT
    Request_ID,
    Request_Date,

    TRY_CONVERT(date, Request_Date, 105) AS Clean_Request_Date,

    -- Step 2: Flag invalid dates
    -- NULL means the original date could not be converted.
    CASE
        WHEN TRY_CONVERT(date, Request_Date, 105) IS NULL
            THEN 'Invalid Date'
        ELSE 'Valid'
    END AS Date_Quality
FROM service_request_raw;


--Data validation
-- Check only invalid dates
-- This should return only the 2 problematic records.

SELECT
    Request_ID,
    Request_Date,
    TRY_CONVERT(DATE, Request_Date, 105) AS Clean_Request_Date,
    'Invalid Date' AS Date_Quality
FROM service_request_raw
WHERE TRY_CONVERT(DATE, Request_Date, 105) IS NULL;

