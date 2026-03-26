LOAD DATA LOCAL INFILE '/Users/cynthiayu/fintech-fraud-analysis/data/synthetic_financial_datasets_for_fraud_detection.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT COUNT(*)
FROM transactions;