# Data Quality & ETL Analysis using SQL Server

## Project Overview

This project demonstrates a practical **data quality and ETL workflow using SQL Server**.

The project starts with raw CSV data and follows these steps:

**Raw Data → Data Quality Checks → Data Cleaning → Clean Tables → Validation**

The main goal was to identify common data quality problems, clean the data using SQL, and keep the raw data unchanged for traceability.

---

## Tools Used

* SQL Server
* SQL Server Management Studio (SSMS)
* SQL
* CSV

---

## Dataset

The project contains 6 raw datasets:

| Table                | Records |
| -------------------- | ------: |
| Customers            |     503 |
| Facilities           |     802 |
| Products             |     102 |
| Technicians          |     100 |
| Service Requests     |   2,503 |
| Service Transactions |   5,004 |

---

## 1. Data Quality Analysis

Before cleaning the data, the raw tables were checked for common data quality issues.

### Checks Performed

* Missing and blank values
* Duplicate IDs
* Inconsistent status values
* Invalid dates
* Extra spaces
* Hidden/special characters
* Data type conversion issues
* Different formats in date fields

---

## 2. Issues Found

### Duplicate Records

Duplicate IDs were identified and investigated in multiple tables.

Examples included:

* Customer IDs: `C0101`, `C0201`, `C0301`
* Facility IDs: `F0151`, `F0251`
* Product IDs: `P0046`, `P0071`
* Service Request IDs: `SR00201`, `SR00401`, `SR00601`

The duplicate records were **identified and investigated but not deleted**.

The raw data was kept unchanged to preserve the original source records and maintain traceability.

---

### Status Inconsistency

Service request status contained different formats such as:

* `COMP`
* `Completed`
* `open`
* `in-progress`

These values were standardized in the clean table.

For example:

| Raw Status    | Clean Status  |
| ------------- | ------------- |
| `COMP`        | `Completed`   |
| `Completed`   | `Completed`   |
| `open`        | `Open`        |
| `in-progress` | `In Progress` |

---

### Invalid Dates

The `Request_Date` field contained invalid dates.

Examples:

* `2026-02-30`
* `31/04/2026`

`TRY_CONVERT()` was used to safely convert the date values.

Invalid dates returned `NULL` and were marked as **Invalid Date** using a date quality flag.

---

### Hidden Character

One Priority value contained a hidden carriage-return character.

The value was investigated using:

* `LEN()`
* `DATALENGTH()`
* `ASCII()`

The character code was identified as **13**, which represents a carriage return.

---

### Extra Spaces

Leading and trailing spaces were handled using:

```sql
LTRIM(RTRIM())
```

This was applied to ID and text fields in the clean tables.

---

## 3. Data Cleaning

The raw tables were **not modified**.

Instead, separate clean tables were created.

### Cleaning Techniques Used

* `LTRIM()` / `RTRIM()` for extra spaces
* `TRY_CONVERT()` for safe date conversion
* `CASE` statements for status standardization
* Numeric conversion for transaction quantities
* Date quality flags for valid and invalid dates

### Clean Tables Created

* `customers_clean`
* `facilites_clean`
* `products_clean`
* `technicians_clean`
* `service_request_clean_final`
* `service_transactions_clean`

---

## 4. Data Validation

After cleaning, raw and clean record counts were compared.

| Dataset              |   Raw | Clean |
| -------------------- | ----: | ----: |
| Customers            |   503 |   503 |
| Facilities           |   802 |   802 |
| Products             |   102 |   102 |
| Technicians          |   100 |   100 |
| Service Requests     | 2,503 | 2,503 |
| Service Transactions | 5,004 | 5,004 |

The matching record counts confirmed that records were retained during the cleaning process.

---

## 5. ETL Flow

```text
CSV Files
    ↓
Raw SQL Server Tables
    ↓
Data Quality Analysis
    ↓
Data Cleaning & Transformation
    ↓
Clean SQL Server Tables
    ↓
Row Count Validation
```

---

## 6. SQL Concepts Used

* `SELECT INTO`
* `CASE WHEN`
* `LTRIM()` / `RTRIM()`
* `TRY_CONVERT()`
* `COUNT()`
* `SUM()`
* `GROUP BY`
* `HAVING`
* `INFORMATION_SCHEMA`
* `ASCII()`
* `LEN()`
* `DATALENGTH()`

---

## 7. Project Structure

```text
Data-Quality-ETL-Analysis-SQL-Server/
│
├── README.md
│
├── SQL/
│   ├── 01_Raw_Data_Analysis.sql
│   ├── 02_Data_Cleaning.sql
│   ├── 03_Data_Validation.sql
│   └── 04_Data_Quality_Investigation.sql
│
└── Raw_Data/
    ├── customers.csv
    ├── facilities.csv
    ├── products.csv
    ├── technicians.csv
    ├── service_request.csv
    └── service_transactions.csv
```

---

## Outcome

This project demonstrates an end-to-end SQL Server workflow for **data quality analysis, data cleaning, transformation, and validation** while maintaining the original raw data for traceability.
