CREATE TABLE teste_priv (
    cod   NUMBER(1),
    texto CHAR(1)
);

ALTER TABLE teste_priv MODIFY
    texto VARCHAR(20);

INSERT INTO teste_priv VALUES (
    1,
    'this is a text'
);

CREATE SEQUENCE teste_id_seq INCREMENT BY 1 START WITH 2 NOCACHE;

INSERT INTO teste_priv VALUES (
    teste_id_seq.NEXTVAL,
    'another text'
);

CREATE VIEW v_teste_priv AS
    SELECT
        texto
    FROM
        teste_priv;

CREATE TABLE woodstock.teste_priv2 (
    id        NUMBER(1),
    descricao CHAR(1)
);

INSERT INTO woodstock.teste_priv2 VALUES (
    5,
    'x'
);