create database Operations_ETL_DB;
Use Operations_ETL_DB;

--1.Customers

CREATE TABLE customers_raw
(
    Customer_ID varchar(50),
	Customer_Name varchar(200),
	Customer_Type varchar(100),
	City varchar(100),
	Email varchar(100),
	Phone varchar(100)
);
Go
-- Insert record 
BULK INSERT customers_raw
FROM 'C:\Users\kuche\OneDrive\Desktop\Operation_ETL_DB\customers_raw.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

select * from customers_raw;

--Exec sp_rename 'dbo.customers_raw.State','Email','Column';


--Exec sp_rename 'dbo.customers_raw.Country','Phone','Column';


--2. Facilities_Raw facilities_raw
create table facilities_raw 
(
    Facility_ID varchar(50),
	Customer_ID varchar(50),
	Facility_Name varchar(200),
	Facility_Type varchar(200),
	City varchar(200)
);
--insertin records

bulk insert facilities_raw 
from 'C:\Users\kuche\OneDrive\Desktop\Operation_ETL_DB\facilities_raw.csv'
with
(
   firstrow = 2,
   fieldterminator = ',',
   rowterminator = '0x0a',
   tablock
);
go

select * from facilities_raw;

--3. Pruducts_raw
create table Products_raw
(
    Product_ID varchar(50),	
    Product_Name varchar(200),
    Category varchar(200),
    Unit varchar(100)
);

--inserting records
bulk insert Products_raw
from 'C:\Users\kuche\OneDrive\Desktop\Operation_ETL_DB\Products_raw.csv'
with
(
firstrow = 2,
fieldterminator =',',
rowterminator = '0x0a',
tablock
);
go
 select * from Products_raw;

 --4. service transactions raw

 create table service_transactions_raw
 (
     Transaction_ID varchar(50),
	 Request_ID varchar(50),
	 Customer_ID varchar(50),
	 Facility_ID varchar(50),
	 Product_ID varchar(50),
	 Technician_ID varchar(50),
	 Service_Date varchar(50),
	 Quantity int,
	 Status varchar(100)
);

--inserting records
bulk insert service_transactions_raw
from 'C:\Users\kuche\OneDrive\Desktop\Operation_ETL_DB\service_transactions_raw.csv'
with
(
   firstrow = 2,
   fieldterminator = ',',
   rowterminator ='0x0a',
   tablock
);
go
select * from service_transactions_raw;

--5. technicians raw
 create table technicians_raw
 (
 Technician_ID varchar(50),
 Technician_Name varchar(200),
 Region varchar(100),
 Status varchar(100)
);

--inserting records
bulk insert technicians_raw
from 'C:\Users\kuche\OneDrive\Desktop\Operation_ETL_DB\technicians_raw.csv'
with
(
    firstrow =2,
	fieldterminator = ',',
	rowterminator = '0x0a',
	tablock
);
go

select * from technicians_raw;

--6.service_request_raw
  create table service_request_raw 
  (
  Request_ID varchar(50),
Customer_ID	varchar(50),
Facility_ID	varchar(50),
Technician_ID	varchar(50),
Request_Date varchar(100),
Status	varchar(200),
Priority varchar(100)
);

--inserting records
bulk insert service_request_raw 
from 'C:\Users\kuche\OneDrive\Desktop\Operation_ETL_DB\service_requests_raw.csv'
with
(
  firstrow = 2,
  fieldterminator = ',',
  rowterminator = '0X0a',
  tablock
);
go

select * from service_request_raw;

--find data loaded successfully

select 'Customers_raw' as Table_Name, count(*) as row_count
from customers_raw 

Union all  

select 'facilities_raw', count(*) 
from facilities_raw 

Union all

select 'Products_raw', count(*)
from Products_raw

Union all

select 'service_transactions_raw',count(*)
from service_transactions_raw

union all

select 'technicians_raw',count(*)
from technicians_raw

union all

select 'service_request_raw', count(*)
from service_request_raw;


