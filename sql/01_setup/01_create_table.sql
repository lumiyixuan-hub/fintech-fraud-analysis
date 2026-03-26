USE fraud_analysis;

CREATE TABLE transactions (
    step            INT,
    type            VARCHAR(10),
    amount          DECIMAL(18,2),
    nameOrig        VARCHAR(20),
    oldbalanceOrg   DECIMAL(18,2),
    newbalanceOrig  DECIMAL(18,2),
    nameDest        VARCHAR(20),
    oldbalanceDest  DECIMAL(18,2),
    newbalanceDest  DECIMAL(18,2),
    isFraud         TINYINT(1),
    isFlaggedFraud  TINYINT(1)
);

SHOW TABLES;