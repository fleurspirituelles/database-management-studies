CREATE TABLE pessoa (
    id        NUMBER,
    nome      VARCHAR2(30),
    sexo      CHAR(1),
    cor_olhos CHAR(1),
    categ_id  NUMBER(2),
    CONSTRAINT pessoa_pk PRIMARY KEY ( id )
);

CREATE TABLE categoria (
    categ_id  NUMBER(2),
    descricao VARCHAR2(20),
    CONSTRAINT categoria_pk PRIMARY KEY ( categ_id )
);

ALTER TABLE pessoa
    ADD CONSTRAINT pessoa_categ_fk FOREIGN KEY ( categ_id )
        REFERENCES categoria ( categ_id );

BEGIN
    INSERT INTO categoria VALUES (
        1,
        'Nivel A'
    );

    INSERT INTO categoria VALUES (
        2,
        'Nivel B'
    );

    INSERT INTO categoria VALUES (
        3,
        'Nivel C'
    );

    INSERT INTO categoria VALUES (
        4,
        'Nivel D'
    );

    INSERT INTO categoria VALUES (
        5,
        'Nivel E'
    );

    INSERT INTO categoria VALUES (
        6,
        'Nivel F'
    );

    INSERT INTO categoria VALUES (
        7,
        'Nivel G'
    );

    INSERT INTO categoria VALUES (
        8,
        'Nivel H'
    );

    INSERT INTO categoria VALUES (
        9,
        'Nivel I'
    );

    INSERT INTO categoria VALUES (
        10,
        'Nivel J'
    );

    INSERT INTO categoria VALUES (
        11,
        'Nivel K'
    );

    INSERT INTO categoria VALUES (
        12,
        'Nivel L'
    );

    INSERT INTO categoria VALUES (
        13,
        'Nivel M'
    );

    INSERT INTO categoria VALUES (
        14,
        'Nivel N'
    );

    INSERT INTO categoria VALUES (
        15,
        'Nivel O'
    );

    INSERT INTO categoria VALUES (
        16,
        'Nivel P'
    );

    INSERT INTO categoria VALUES (
        17,
        'Nivel Q'
    );

    INSERT INTO categoria VALUES (
        18,
        'Nivel R'
    );

    INSERT INTO categoria VALUES (
        19,
        'Nivel S'
    );

    INSERT INTO categoria VALUES (
        20,
        'Nivel T'
    );

    COMMIT;
    FOR i IN 1..100000 LOOP
        INSERT INTO pessoa (
            id,
            nome
        ) VALUES (
            i,
            'Joao' || to_char(i, '000000')
        );

        IF MOD(i, 10000) = 0 THEN
            COMMIT;
        END IF;
    END LOOP;

    COMMIT;
    UPDATE pessoa
    SET
        cor_olhos = 'A'
    WHERE
        mod(id, 4) = 0;

    UPDATE pessoa
    SET
        cor_olhos = 'V'
    WHERE
        mod(id, 4) = 1;

    UPDATE pessoa
    SET
        cor_olhos = 'C'
    WHERE
        mod(id, 4) = 2;

    UPDATE pessoa
    SET
        cor_olhos = 'P'
    WHERE
        mod(id, 4) = 3;

    COMMIT;
    UPDATE pessoa
    SET
        sexo = 'M'
    WHERE
        mod(id, 2) = 0;

    UPDATE pessoa
    SET
        sexo = 'F'
    WHERE
        mod(id, 2) = 1;

    COMMIT;
    UPDATE pessoa
    SET
        categ_id = 1
    WHERE
        mod(id, 20) = 0;

    UPDATE pessoa
    SET
        categ_id = 2
    WHERE
        mod(id, 20) = 1;

    UPDATE pessoa
    SET
        categ_id = 3
    WHERE
        mod(id, 20) = 2;

    UPDATE pessoa
    SET
        categ_id = 4
    WHERE
        mod(id, 20) = 3;

    UPDATE pessoa
    SET
        categ_id = 5
    WHERE
        mod(id, 20) = 4;

    UPDATE pessoa
    SET
        categ_id = 6
    WHERE
        mod(id, 20) = 5;

    UPDATE pessoa
    SET
        categ_id = 7
    WHERE
        mod(id, 20) = 6;

    UPDATE pessoa
    SET
        categ_id = 8
    WHERE
        mod(id, 20) = 7;

    UPDATE pessoa
    SET
        categ_id = 9
    WHERE
        mod(id, 20) = 8;

    UPDATE pessoa
    SET
        categ_id = 10
    WHERE
        mod(id, 20) = 9;

    UPDATE pessoa
    SET
        categ_id = 11
    WHERE
        mod(id, 20) = 10;

    UPDATE pessoa
    SET
        categ_id = 12
    WHERE
        mod(id, 20) = 11;

    UPDATE pessoa
    SET
        categ_id = 13
    WHERE
        mod(id, 20) = 12;

    UPDATE pessoa
    SET
        categ_id = 14
    WHERE
        mod(id, 20) = 13;

    UPDATE pessoa
    SET
        categ_id = 15
    WHERE
        mod(id, 20) = 14;

    UPDATE pessoa
    SET
        categ_id = 16
    WHERE
        mod(id, 20) = 15;

    UPDATE pessoa
    SET
        categ_id = 17
    WHERE
        mod(id, 20) = 16;

    UPDATE pessoa
    SET
        categ_id = 18
    WHERE
        mod(id, 20) = 17;

    UPDATE pessoa
    SET
        categ_id = 19
    WHERE
        mod(id, 20) = 18;

    UPDATE pessoa
    SET
        categ_id = 20
    WHERE
        mod(id, 20) = 19;

    COMMIT;
END;
/

CREATE INDEX pessoa_nome_ix ON
    pessoa (
        nome
    );

SELECT
    *
FROM
    pessoa
WHERE
    nome = 'Joao 062000';

CREATE INDEX pessoa_sexo_ix ON
    pessoa (
        sexo
    );

SELECT
    *
FROM
    pessoa
WHERE
    sexo = 'M';

SELECT
    p.nome,
    c.descricao
FROM
    pessoa    p,
    categoria c
WHERE
    p.categ_id = c.categ_id;

SELECT
    p.nome,
    c.descricao
FROM
    pessoa    p,
    categoria c
WHERE
        p.categ_id = c.categ_id
    AND p.categ_id = 12;

CREATE INDEX pessoa_nome2_ix ON
    pessoa ( upper(nome) );

SELECT
    *
FROM
    pessoa
WHERE
    upper(nome) = 'JOAO 062000';

CREATE INDEX pessoa_cat_nome_ix ON
    pessoa (
        categ_id,
        nome
    );

SELECT
    *
FROM
    pessoa
WHERE
        categ_id = 1
    AND nome LIKE 'Joao 09%';

CREATE BITMAP INDEX pessoa_olhos_bmix ON
    pessoa (
        cor_olhos
    );

SELECT
    *
FROM
    pessoa
WHERE
    cor_olhos = 'A';