-- =============================================
-- Hypothesis 2: Do fraud transactions drain the origin account balance to zero?
-- Purpose: Identify if balance depletion is a reliable signal for fraud detection
-- =============================================

SELECT
    isFraud,
    COUNT(*)    AS transaction_count,
    SUM(CASE WHEN newbalanceOrig = 0 THEN 1 ELSE 0 END)    AS zero_balance_count,
    ROUND(SUM(CASE WHEN newbalanceOrig = 0 THEN 1 ELSE 0 END) 
        * 100.0 / COUNT(*), 4)                             AS zero_balance_rate
FROM transactions
WHERE type IN ('TRANSFER', 'CASH_OUT')
GROUP BY isFraud
ORDER BY isFraud;