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

GRANT SELECT, INSERT ON woodstock.clube TO garfield;

SELECT
    id,
    nome,
    salario
FROM
    woodstock.atleta
WHERE
    nome LIKE 'Miquela Malloy';

SELECT
    *
FROM
    woodstock.atleta
WHERE
    id = 199;

SELECT
    salario
FROM
    woodstock.atleta
WHERE
    nome = 'Lambert Taffs';

UPDATE woodstock.atleta
SET
    salario = 9000
WHERE
    nome = 'Lambert Taffs';

COMMIT;

DESC woodstock.emp_temp;

SELECT
    *
FROM
    woodstock.emp_temp;

DESC woodstock.dep_temp;

SELECT
    *
FROM
    woodstock.emp_temp
WHERE
    nome = 'Mía Colucci';

SAVEPOINT sp1;

DELETE FROM woodstock.emp_temp
WHERE
    nome = 'Giovanni López';

SAVEPOINT sp2;

DELETE FROM woodstock.emp_temp
WHERE
    nome = 'Diego Bustamante';

SELECT
    *
FROM
    woodstock.emp_temp;

ROLLBACK;

ROLLBACK TO sp2;

COMMIT;

UPDATE woodstock.emp_temp
SET
    sal = 5500
WHERE
    nome = 'Guadalupe Fernández';

COMMIT;