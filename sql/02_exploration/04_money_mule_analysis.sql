-- =============================================
-- Hypothesis 5: Are destination accounts in fraud transactions also originators of other fraud transactions? (Money Mule Detection)
-- Purpose: Identify accounts acting as intermediaries in fraud networks
-- =============================================

SELECT
    t.nameDest,
    COUNT(*)                             AS total_txn_as_dest,
    SUM(t.isFraud)                       AS times_received_fraud,
    COUNT(DISTINCT t2.nameOrig)          AS times_sent_as_orig,
    SUM(t2.isFraud)                      AS fraud_sent_as_orig
FROM transactions t
LEFT JOIN transactions t2
    ON t.nameDest = t2.nameOrig
    AND t2.type IN ('TRANSFER', 'CASH_OUT')
WHERE t.isFraud = 1
    AND t.type IN ('TRANSFER', 'CASH_OUT')
GROUP BY t.nameDest
HAVING times_received_fraud > 0
    AND times_sent_as_orig > 0
ORDER BY fraud_sent_as_orig DESC
LIMIT 20;