CREATE TABLE teste_priv (
    cod   NUMBER(1),
    texto CHAR(1)
);

ALTER TABLE teste_priv MODIFY
    texto VARCHAR(10);
    
DROP TABLE teste_priv;