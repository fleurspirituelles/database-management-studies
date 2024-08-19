CREATE TABLE teste_priv (
    cod   NUMBER(1),
    texto CHAR(1)
);

ALTER TABLE teste_priv MODIFY
    texto VARCHAR(20);

DROP TABLE teste_priv;

INSERT INTO teste_priv VALUES (
    1,
    'this is a text'
);

CREATE SEQUENCE teste_id_seq INCREMENT BY 1 START WITH 2 NOCACHE;