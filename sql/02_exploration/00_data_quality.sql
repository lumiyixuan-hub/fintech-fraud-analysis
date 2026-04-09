-- =============================================
-- Data Quality Check 1: NULL values
-- =============================================
SELECT
    SUM(CASE WHEN step IS NULL THEN 1 ELSE 0 END)              AS null_step,
    SUM(CASE WHEN type IS NULL THEN 1 ELSE 0 END)              AS null_type,
    SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END)            AS null_amount,
    SUM(CASE WHEN nameOrig IS NULL THEN 1 ELSE 0 END)          AS null_nameOrig,
    SUM(CASE WHEN oldbalanceOrg IS NULL THEN 1 ELSE 0 END)     AS null_oldbalanceOrg,
    SUM(CASE WHEN newbalanceOrig IS NULL THEN 1 ELSE 0 END)    AS null_newbalanceOrig,
    SUM(CASE WHEN nameDest IS NULL THEN 1 ELSE 0 END)          AS null_nameDest,
    SUM(CASE WHEN oldbalanceDest IS NULL THEN 1 ELSE 0 END)    AS null_oldbalanceDest,
    SUM(CASE WHEN newbalanceDest IS NULL THEN 1 ELSE 0 END)    AS null_newbalanceDest,
    SUM(CASE WHEN isFraud IS NULL THEN 1 ELSE 0 END)           AS null_isFraud,
    SUM(CASE WHEN isFlaggedFraud IS NULL THEN 1 ELSE 0 END)    AS null_isFlaggedFraud
FROM transactions;

-- =============================================
-- Data Quality Check 2: Duplicate transactions
-- =============================================
SELECT
    COUNT(*)                                        AS total_rows,
    COUNT(DISTINCT CONCAT(step, nameOrig, nameDest, 
        amount, type))                              AS distinct_rows
FROM transactions;

-- =============================================
-- Data Quality Check 3: Negative amounts
-- =============================================
SELECT
    COUNT(*)                                        AS negative_amount_count
FROM transactions
WHERE amount < 0;
