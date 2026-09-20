USE Operations_ETL_DB;

-- ============================================================
-- CUSTOMERS: ROW COUNT VALIDATION
-- Compare Raw table count with Clean table count
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM customers_raw) AS Raw_Record_Count,
    (SELECT COUNT(*) FROM customers_clean) AS Clean_Record_Count;



-- ============================================================
-- FACILITIES: ROW COUNT VALIDATION
-- Compare Raw table count with Clean table count
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM facilities_raw) AS Raw_Record_Count,
    (SELECT COUNT(*) FROM facilities_clean) AS Clean_Record_Count;



-- ============================================================
-- PRODUCTS: ROW COUNT VALIDATION
-- Compare Raw table count with Clean table count
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM Products_raw) AS Raw_Record_Count,
    (SELECT COUNT(*) FROM products_clean) AS Clean_Record_Count;



-- ============================================================
-- TECHNICIANS: ROW COUNT VALIDATION
-- Compare Raw table count with Clean table count
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM technicians_raw) AS Raw_Record_Count,
    (SELECT COUNT(*) FROM technicians_clean) AS Clean_Record_Count;



-- ============================================================
-- SERVICE REQUEST: ROW COUNT VALIDATION
-- Compare Raw table count with Clean table count
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM service_request_raw) AS Raw_Record_Count,
    (SELECT COUNT(*) FROM service_request_clean_final) AS Clean_Record_Count;




-- ============================================================
-- SERVICE TRANSACTIONS: ROW COUNT VALIDATION
-- Compare Raw table count with Clean table count
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM service_transactions_raw) AS Raw_Record_Count,
    (SELECT COUNT(*) FROM service_transactions_clean) AS Clean_Record_Count;