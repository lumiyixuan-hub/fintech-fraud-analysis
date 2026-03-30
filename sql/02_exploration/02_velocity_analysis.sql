-- =============================================
-- Hypothesis 1: Do fraud accounts transact more frequently within the same time period (step)?
-- Step 1: Compare average transaction frequency per step between fraud and normal accounts
-- =============================================

WITH account_activity AS (
    SELECT
        nameOrig,
        step,
        COUNT(*)        AS txn_count,
        MAX(isFraud)    AS is_fraud_account
    FROM transactions
    WHERE type IN ('TRANSFER', 'CASH_OUT')
    GROUP BY nameOrig, step
)
SELECT
    is_fraud_account,
    COUNT(*)     AS account_step_combinations,
    ROUND(AVG(txn_count), 4)    AS avg_txn_per_step,
    MAX(txn_count)    AS max_txn_per_step
FROM account_activity
GROUP BY is_fraud_account
ORDER BY is_fraud_account;