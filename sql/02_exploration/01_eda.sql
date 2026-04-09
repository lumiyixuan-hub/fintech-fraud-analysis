-- =============================================
-- EDA Query 1: Transaction Type Distribution
-- Purpose: Understand the volume and proportion of each transaction type
-- =============================================

SELECT 
    type, 
    COUNT(*) AS transaction_count,
    round( COUNT(*) * 100.0 / sum(count(*)) OVER (), 2) AS percentage
FROM transactions
GROUP BY type
ORDER BY transaction_count DESC; 


-- =============================================
-- EDA Query 2: Fraud Distribution by Transaction Type
-- Purpose: Identify which transaction types are associated with fraud
-- =============================================

SELECT
    type,
    count(*) AS transaction_count,
    sum(isFraud) AS fraud_count,
    round( sum(isFraud) * 100.0 / count(*) , 4) AS fraud_rate
FROM transactions
GROUP BY type
ORDER BY fraud_count DESC;


-- =============================================
-- EDA Query 3: Transaction Amount - Fraud vs Normal
-- Purpose: Determine if fraudulent transactions differ in amount from normal transactions within TRANSFER and CASH_OUT
-- =============================================

SELECT 
    type,
    isFraud,
    count(*) AS transaction_count,
    round(MIN(amount), 2) AS min_amount,
    round(avg(amount), 2) AS avg_amount,
    round(MAX(amount), 2) AS max_amount
FROM transactions
WHERE type in ('TRANSFER', 'CASH_OUT')
GROUP BY type, isFraud
ORDER BY type, isFraud;


-- =============================================
-- EDA Query 4a: Amount Distribution with Percentiles
-- Purpose: Understand amount spread before defining fraud buckets
-- =============================================

WITH ranked AS (
    SELECT
        type,
        amount,
        ROW_NUMBER() OVER (PARTITION BY type ORDER BY amount)   AS row_num,
        COUNT(*) OVER (PARTITION BY type)                       AS total_count
    FROM transactions
    WHERE type IN ('TRANSFER', 'CASH_OUT')
),
percentiles AS (
    SELECT
        type,
        MAX(CASE WHEN row_num <= total_count * 0.25 THEN amount END)    AS p25,
        MAX(CASE WHEN row_num <= total_count * 0.50 THEN amount END)    AS p50_median,
        MAX(CASE WHEN row_num <= total_count * 0.75 THEN amount END)    AS p75,
        MAX(CASE WHEN row_num <= total_count * 0.90 THEN amount END)    AS p90,
        MAX(amount)                                                      AS max_amount
    FROM ranked
    GROUP BY type
)
SELECT * FROM percentiles
ORDER BY type;


-- =============================================
-- EDA Query 4b: Fraud Rate by Amount Bucket
-- Purpose: Test whether higher amount transactions have disproportionately higher fraud rates
-- Buckets defined based on percentile distribution from Query 4a
-- =============================================

SELECT
    type,
    CASE
        WHEN amount >= 5000000  THEN '4. Near Limit (>=5M)'
        WHEN amount >= 1000000  THEN '3. High (1M-5M)'
        WHEN amount >= 247000   THEN '2. Medium (247K-1M)'
        ELSE                         '1. Low (<247K)'
    END                                             AS amount_bucket,
    COUNT(*)                                        AS transaction_count,
    SUM(isFraud)                                    AS fraud_count,
    ROUND(SUM(isFraud) * 100.0 / COUNT(*), 4)      AS fraud_rate
FROM transactions
WHERE type IN ('TRANSFER', 'CASH_OUT')
GROUP BY type, amount_bucket
ORDER BY type, amount_bucket;

-- =============================================
-- EDA Query 5a: Fraud Distribution Over Time
-- Purpose: Identify whether fraud concentrates in specific time periods (steps)
-- =============================================

SELECT
    step,
    COUNT(*)                                        AS total_txn,
    SUM(isFraud)                                    AS fraud_count,
    ROUND(SUM(isFraud) * 100.0 / COUNT(*), 4)      AS fraud_rate
FROM transactions
WHERE type IN ('TRANSFER', 'CASH_OUT')
GROUP BY step
ORDER BY step;


-- =============================================
-- EDA Query 5b: Fraud Distribution by Hour of Day
-- Purpose: Identify whether fraud concentrates at specific hours regardless of which day
-- =============================================

SELECT
    (step-1) % 24                                       AS hour_of_day,
    COUNT(*)                                        AS total_txn,
    SUM(isFraud)                                    AS fraud_count,
    ROUND(SUM(isFraud) * 100.0 / COUNT(*), 4)      AS fraud_rate
FROM transactions
WHERE type IN ('TRANSFER', 'CASH_OUT')
GROUP BY hour_of_day
ORDER BY hour_of_day;


-- =============================================
-- EDA Query 6: isFlaggedFraud vs isFraud Analysis
-- Purpose: Measure how well the existing rule-based system detects actual fraud
-- =============================================

SELECT
    isFraud,
    isFlaggedFraud,
    COUNT(*)                                        AS transaction_count
FROM transactions
GROUP BY isFraud, isFlaggedFraud
ORDER BY isFraud, isFlaggedFraud;