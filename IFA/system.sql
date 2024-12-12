ALTER SESSION SET "_ORACLE_SCRIPT" = true;

DROP TABLE centro_treinamento;

DROP TABLE participa;

DROP TABLE esporte;

DROP TABLE pratica;

DROP TABLE campeonato;

DROP TABLE modalidade;

DROP TABLE olimpico;

DROP TABLE paraolimpico;

DROP TABLE atleta_contato;

DROP TABLE atleta;

DROP TABLE clube;

DROP TABLE presidente;

CREATE TABLE atleta (
    id       NUMBER(4) NOT NULL,
    cpf      VARCHAR2(14) NOT NULL,
    nome     VARCHAR2(60) NOT NULL,
    sexo     CHAR(1),
    datanasc DATE,
    endereco VARCHAR2(50),
    salario  NUMBER(10, 2) NOT NULL,
    id_clube NUMBER(4),
    CONSTRAINT atleta_pk PRIMARY KEY ( id ),
    CONSTRAINT atleta_uk UNIQUE ( cpf ),
    CONSTRAINT atleta_sexo_ck CHECK ( sexo IN ( 'M', 'F', 'm', 'f' ) ),
    CONSTRAINT atleta_salario_ck CHECK ( salario > 0 )
);

CREATE TABLE presidente (
    id       NUMBER(4),
    cpf      VARCHAR2(14) NOT NULL,
    nome     VARCHAR2(50) NOT NULL,
    email    VARCHAR2(80),
    telefone VARCHAR2(20),
    CONSTRAINT presidente_pk PRIMARY KEY ( id ),
    CONSTRAINT presidente_cpf_uk UNIQUE ( cpf )
);

CREATE TABLE clube (
    id            NUMBER(4) NOT NULL,
    nome          VARCHAR2(40) NOT NULL,
    data_fundacao DATE,
    id_presidente NUMBER(4),
    CONSTRAINT clube_pk PRIMARY KEY ( id ),
    CONSTRAINT clube_nome_pk UNIQUE ( nome ),
    CONSTRAINT clube_presidente_fk FOREIGN KEY ( id_presidente )
        REFERENCES presidente ( id )
);

ALTER TABLE atleta
    ADD CONSTRAINT atleta_clube_fk FOREIGN KEY ( id_clube )
        REFERENCES clube ( id );

CREATE TABLE modalidade (
    id        NUMBER(3),
    descricao VARCHAR2(30),
    olimpica  CHAR(1) DEFAULT 'n',
    CONSTRAINT modalidade_pk PRIMARY KEY ( id ),
    CONSTRAINT modalidade_olimpica_ck CHECK ( olimpica IN ( 'S', 's', 'N', 'n' ) )
);

CREATE TABLE olimpico (
    id_atleta         NUMBER(4),
    incentivo_governo CHAR(1),
    CONSTRAINT olimpico_pk PRIMARY KEY ( id_atleta ),
    CONSTRAINT olimpico_incentivo_ck CHECK ( incentivo_governo IN ( 'S', 's', 'N', 'n' ) ),
    CONSTRAINT olimpico_atleta_fk FOREIGN KEY ( id_atleta )
        REFERENCES atleta ( id )
);

CREATE TABLE paraolimpico (
    id_atleta   NUMBER(4),
    deficiencia VARCHAR2(30),
    nivel       NUMBER,
    CONSTRAINT paraolimpico_pk PRIMARY KEY ( id_atleta ),
    CONSTRAINT paraolimpico_nivel_ck CHECK ( nivel BETWEEN 1 AND 5 ),
    CONSTRAINT paraolimpico_atleta_fk FOREIGN KEY ( id_atleta )
        REFERENCES atleta ( id )
);

CREATE TABLE campeonato (
    id          NUMBER(3),
    nome        VARCHAR2(70) NOT NULL,
    local       VARCHAR2(40),
    data_inicio DATE,
    data_fim    DATE,
    CONSTRAINT campeonato_pk PRIMARY KEY ( id )
);

CREATE TABLE centro_treinamento (
    id_clube  NUMBER(4),
    id_centro NUMBER(4),
    fone      VARCHAR2(20),
    rua       VARCHAR2(50),
    nro       NUMBER,
    bairro    VARCHAR2(50),
    cep       VARCHAR2(9),
    cidade    VARCHAR2(50),
    uf        CHAR(2),
    CONSTRAINT ct_pk PRIMARY KEY ( id_clube,
                                   id_centro ),
    CONSTRAINT ct_clube_fk FOREIGN KEY ( id_clube )
        REFERENCES clube ( id )
);

CREATE TABLE atleta_contato (
    id_atleta NUMBER(4),
    contato   VARCHAR(50),
    CONSTRAINT atleta_contato_pk PRIMARY KEY ( id_atleta,
                                               contato ),
    CONSTRAINT atleta_contato_fk FOREIGN KEY ( id_atleta )
        REFERENCES atleta ( id )
);

CREATE TABLE pratica (
    id_atleta     NUMBER(4),
    id_modalidade NUMBER(3),
    data_inicio   DATE,
    experiencia   NUMBER,
    CONSTRAINT pratica_pk PRIMARY KEY ( id_atleta,
                                        id_modalidade ),
    CONSTRAINT pratica_atleta_fk FOREIGN KEY ( id_atleta )
        REFERENCES atleta ( id ),
    CONSTRAINT pratica_modalidade_fk FOREIGN KEY ( id_modalidade )
        REFERENCES modalidade ( id )
);

CREATE TABLE esporte (
    registro_atleta NUMBER(8),
    id_atleta       NUMBER(4),
    id_modalidade   NUMBER(3),
    CONSTRAINT esporte_pk PRIMARY KEY ( registro_atleta ),
    CONSTRAINT esporte_pratica_fk FOREIGN KEY ( id_atleta,
                                                id_modalidade )
        REFERENCES pratica ( id_atleta,
                             id_modalidade )
);

CREATE TABLE participa (
    registro_atleta NUMBER(8),
    id_campeonato   NUMBER(3),
    colocacao       NUMBER(5),
    valor_premiacao NUMBER(10, 2) DEFAULT 0,
    CONSTRAINT participa_pk PRIMARY KEY ( registro_atleta,
                                          id_campeonato ),
    CONSTRAINT participa_registro_fk FOREIGN KEY ( registro_atleta )
        REFERENCES esporte ( registro_atleta ),
    CONSTRAINT participa_campeonato_fk FOREIGN KEY ( id_campeonato )
        REFERENCES campeonato ( id )
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    1,
    '987.654.321-00',
    'Shepherd',
    'shepherd@shadowco.com',
    '+1-800-123-4567'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    2,
    '876.543.210-00',
    'Price',
    'price@taskforce141.com',
    '+44-700-987-6543'
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    1,
    'Shadow Company',
    TO_DATE('2002-05-15', 'YYYY-MM-DD'),
    1
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    2,
    'Task Force 141',
    TO_DATE('1999-07-20', 'YYYY-MM-DD'),
    2
);

INSERT INTO atleta (
    id,
    cpf,
    nome,
    sexo,
    datanasc,
    endereco,
    salario,
    id_clube
) VALUES (
    1,
    '123.456.789-01',
    'König',
    'M',
    TO_DATE('1989-01-15', 'YYYY-MM-DD'),
    'Austria Base',
    850000.00,
    1
);

INSERT INTO atleta (
    id,
    cpf,
    nome,
    sexo,
    datanasc,
    endereco,
    salario,
    id_clube
) VALUES (
    2,
    '234.567.890-12',
    'Ghost',
    'M',
    TO_DATE('1987-08-17', 'YYYY-MM-DD'),
    'UK Base',
    950000.00,
    2
);

INSERT INTO atleta (
    id,
    cpf,
    nome,
    sexo,
    datanasc,
    endereco,
    salario,
    id_clube
) VALUES (
    3,
    '345.678.901-23',
    'Krueger',
    'M',
    TO_DATE('1990-03-29', 'YYYY-MM-DD'),
    'Germany Base',
    870000.00,
    1
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    1,
    'konig@shadowco.com'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    2,
    'ghost@taskforce141.com'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    3,
    'krueger@shadowco.com'
);

INSERT INTO paraolimpico (
    id_atleta,
    deficiencia,
    nivel
) VALUES (
    2,
    'Combat Readiness',
    3
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    1,
    's'
);

INSERT INTO modalidade (
    id,
    descricao,
    olimpica
) VALUES (
    1,
    'Stealth Operations',
    's'
);

INSERT INTO modalidade (
    id,
    descricao,
    olimpica
) VALUES (
    2,
    'Tactical Assault',
    'n'
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    1,
    'Warfare Pro League',
    'Global Arena',
    TO_DATE('2024-05-10', 'YYYY-MM-DD'),
    TO_DATE('2024-05-20', 'YYYY-MM-DD')
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    2,
    'Spec Ops Championship',
    'Classified Zone',
    TO_DATE('2024-07-15', 'YYYY-MM-DD'),
    TO_DATE('2024-07-25', 'YYYY-MM-DD')
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    1,
    1,
    TO_DATE('2020-01-10', 'YYYY-MM-DD'),
    5
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    2,
    2,
    TO_DATE('2019-06-15', 'YYYY-MM-DD'),
    4
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    3,
    1,
    TO_DATE('2021-09-20', 'YYYY-MM-DD'),
    3
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    10001,
    1,
    1
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    10002,
    2,
    2
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    10003,
    3,
    1
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    10001,
    1,
    1,
    100000.0
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    10002,
    2,
    2,
    50000.0
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    10003,
    1,
    3,
    25000.0
);

INSERT INTO centro_treinamento (
    id_clube,
    id_centro,
    fone,
    rua,
    nro,
    bairro,
    cep,
    cidade,
    uf
) VALUES (
    1,
    1,
    '+1-800-555-0199',
    'Alpha Road',
    10,
    'Sector A',
    '12345-678',
    'Undisclosed',
    'UX'
);

INSERT INTO centro_treinamento (
    id_clube,
    id_centro,
    fone,
    rua,
    nro,
    bairro,
    cep,
    cidade,
    uf
) VALUES (
    2,
    1,
    '+1-800-555-0200',
    'Bravo Street',
    20,
    'Sector B',
    '23456-789',
    'Classified',
    'UX'
);

SET SERVEROUTPUT ON;

/*
UNDEFINE v_atleta_id;

DECLARE
    v_atleta_id      atleta.id%TYPE;
    v_atleta_salario atleta.salario%TYPE;
BEGIN
    v_atleta_id := &id;
    SELECT
        salario
    INTO v_atleta_salario
    FROM
        atleta
    WHERE
        id = v_atleta_id;

    IF v_atleta_salario >= 95000 THEN
        dbms_output.put_line('This is Ghost.');
    ELSIF v_atleta_salario >= 87000 THEN
        dbms_output.put_line('This is Krueger.');
    ELSE
        dbms_output.put_line('This is König.');
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('No athlete found with the given ID.');
    WHEN OTHERS THEN
        dbms_output.put_line('Oh, no! An unexpected error occurred! ' || sqlerrm);
END;
/

DECLARE
    v_atleta_nome     atleta.nome%TYPE;
    v_atleta_datanasc atleta.datanasc%TYPE;
    v_atleta_idade    NUMBER;
BEGIN
    SELECT
        nome,
        datanasc
    INTO
        v_atleta_nome,
        v_atleta_datanasc
    FROM
        atleta
    WHERE
        atleta.id = &id;

    v_atleta_idade := trunc((sysdate - v_atleta_datanasc) / 365);
    dbms_output.put_line(v_atleta_nome
                         || ' is '
                         || v_atleta_idade
                         || ' years old.');
END;
/

DECLARE
    v_atleta_id      atleta.id%TYPE;
    v_atleta_nome    atleta.nome%TYPE;
    v_atleta_salario atleta.salario%TYPE;
    CURSOR c_atleta IS
    SELECT
        id,
        nome,
        salario
    FROM
        atleta
    ORDER BY
        id;

BEGIN
    OPEN c_atleta;
    LOOP
        FETCH c_atleta INTO
            v_atleta_id,
            v_atleta_nome,
            v_atleta_salario;
        EXIT WHEN c_atleta%notfound;
        dbms_output.put_line(v_atleta_nome
                             || ', who goes by the ID '
                             || v_atleta_id
                             || ', has the wage of R$'
                             || v_atleta_salario
                             || ',00.');

    END LOOP;

    CLOSE c_atleta;
END;
/

DECLARE
    v_atleta atleta%rowtype;
    CURSOR c_atleta IS
    SELECT
        *
    FROM
        atleta
    ORDER BY
        id;

BEGIN
    OPEN c_atleta;
    LOOP
        FETCH c_atleta INTO v_atleta;
        EXIT WHEN c_atleta%notfound;
        dbms_output.put_line(v_atleta.nome
                             || ', who goes by the ID '
                             || v_atleta.id
                             || ', has the wage of R$'
                             || v_atleta.salario
                             || ',00.');

    END LOOP;

    CLOSE c_atleta;
END;
/

DECLARE
    CURSOR c_atleta IS
    SELECT
        *
    FROM
        atleta
    ORDER BY
        id;

BEGIN
    FOR v_atleta IN c_atleta LOOP
        dbms_output.put_line(v_atleta.nome
                             || ', who goes by the ID '
                             || v_atleta.id
                             || ', has the wage of R$'
                             || v_atleta.salario
                             || ',00.');
    END LOOP;
END;
/

DECLARE
    fator NUMBER := 5;
BEGIN
    dbms_output.put_line('Tabuada do '
                         || fator
                         || ':');
    FOR i IN 1..10 LOOP
        dbms_output.put_line(fator
                             || ' x '
                             || i
                             || ' = '
                             || fator * i);
    END LOOP;

END;
/

BEGIN
    FOR j IN 1..10 LOOP
        dbms_output.put_line('Tabuada do '
                             || j
                             || ':');
        FOR i IN 1..10 LOOP
            dbms_output.put_line(j
                                 || ' x '
                                 || i
                                 || ' = '
                                 || j * i);
        END LOOP;

        dbms_output.put_line('');
    END LOOP;
END;
/

DECLARE
    lado1 NUMBER := 5;
    lado2 NUMBER := 5;
    lado3 NUMBER := 5;
BEGIN
    IF
        ( lado1 = lado2 )
        AND ( lado2 = lado3 )
    THEN
        dbms_output.put_line('Triângulo equilátero.');
    ELSIF
        ( lado1 != lado2 )
        AND ( lado2 != lado3 )
    THEN
        dbms_output.put_line('Triângulo escaleno.');
    ELSE
        dbms_output.put_line('Triângulo isósceles.');
    END IF;
END;
/

DECLARE
    v_atleta_nome     atleta.nome%TYPE;
    v_atleta_datanasc atleta.datanasc%TYPE;
    v_atleta_idade    NUMBER;
BEGIN
    SELECT
        nome,
        datanasc
    INTO
        v_atleta_nome,
        v_atleta_datanasc
    FROM
        atleta
    WHERE
        id = 2;

    v_atleta_idade := trunc((sysdate - v_atleta_datanasc) / 365);
    IF v_atleta_idade >= 18 THEN
        dbms_output.put_line(v_atleta_nome
                             || ' is an adult born in '
                             || v_atleta_datanasc
                             || '. He is '
                             || v_atleta_idade
                             || ' years old.');
    ELSE
        dbms_output.put_line(v_atleta_nome
                             || 'is a minor born in '
                             || v_atleta_datanasc
                             || '. He is '
                             || v_atleta_idade
                             || ' years old.');
    END IF;

END;
/

DECLARE
    v_atleta_id      atleta.id%TYPE;
    v_atleta_nome    atleta.nome%TYPE;
    v_atleta_cpf     atleta.cpf%TYPE;
    v_atleta_salario atleta.salario%TYPE;
    v_media_salarial NUMBER;
    CURSOR c_atleta IS
    SELECT
        id,
        nome,
        cpf,
        salario
    FROM
        atleta
    ORDER BY
        id;

BEGIN
    SELECT
        AVG(salario)
    INTO v_media_salarial
    FROM
        atleta;

    dbms_output.put_line('The avarage salary is R$'
                         || v_media_salarial
                         || ',00.');
    dbms_output.put_line('');
    OPEN c_atleta;
    LOOP
        FETCH c_atleta INTO
            v_atleta_id,
            v_atleta_nome,
            v_atleta_cpf,
            v_atleta_salario;
        EXIT WHEN c_atleta%notfound;
        dbms_output.put_line('Name: '
                             || v_atleta_nome
                             || '. ID: '
                             || v_atleta_id
                             || '. CPF: '
                             || v_atleta_cpf
                             || '. Salary: R$'
                             || v_atleta_salario
                             || ',00.');

        IF v_atleta_salario > v_media_salarial THEN
            dbms_output.put_line('Salary is above avarage.');
            dbms_output.put_line('');
        ELSE
            dbms_output.put_line('Salary is below avarage.');
            dbms_output.put_line('');
        END IF;

    END LOOP;

    CLOSE c_atleta;
END;
/

DECLARE
    v_clube_media_salarial NUMBER;
    CURSOR c_atleta IS
    SELECT
        id,
        nome,
        cpf,
        salario,
        id_clube
    FROM
        atleta
    WHERE
        id_clube IS NOT NULL;

BEGIN
    FOR v_atleta IN c_atleta LOOP
        SELECT
            AVG(salario)
        INTO v_clube_media_salarial
        FROM
            atleta
        WHERE
            id_clube = v_atleta.id_clube;

        dbms_output.put_line('The avarage salary is R$'
                             || round(v_clube_media_salarial, 2)
                             || ',00.');
        dbms_output.put_line('Name: '
                             || v_atleta.nome
                             || '. ID: '
                             || v_atleta.id
                             || '. CPF: '
                             || v_atleta.cpf
                             || '. Salary: R$'
                             || v_atleta.salario
                             || ',00.');

        IF v_atleta.salario > v_clube_media_salarial THEN
            dbms_output.put_line('Salary is above avarage.');
        ELSIF v_atleta.salario < v_clube_media_salarial THEN
            dbms_output.put_line('Salary is below avarage.');
        ELSE
            dbms_output.put_line('Salary is equal the avarage.');
        END IF;

        dbms_output.put_line('');
    END LOOP;
END;
/

DECLARE
    v_atleta_salario_1 atleta.salario%TYPE;
    v_atleta_salario_3 atleta.salario%TYPE;
BEGIN
    SELECT
        salario
    INTO v_atleta_salario_1
    FROM
        atleta
    WHERE
        id = 1;

    dbms_output.put_line('First salary: R$'
                         || v_atleta_salario_1
                         || ',00.');
    SELECT
        salario
    INTO v_atleta_salario_3
    FROM
        atleta
    WHERE
        id = 3;

    dbms_output.put_line('Second salary: R$'
                         || v_atleta_salario_3
                         || ',00.');
    UPDATE atleta
    SET
        salario = v_atleta_salario_3
    WHERE
        id = 1;

    dbms_output.put_line('Updated first salary: R$'
                         || v_atleta_salario_3
                         || ',00.');
    UPDATE atleta
    SET
        salario = v_atleta_salario_1
    WHERE
        id = 3;

    dbms_output.put_line('Updated second salary: R$'
                         || v_atleta_salario_1
                         || ',00.');
END;
/

DECLARE
    v_atleta_salario_1     atleta.salario%TYPE;
    v_atleta_endereco_1    atleta.endereco%TYPE;
    v_atleta_salario_4     atleta.salario%TYPE;
    v_atleta_endereco_4    atleta.endereco%TYPE;
    v_atleta_salario_medio NUMBER;
BEGIN
    SELECT
        salario,
        endereco
    INTO
        v_atleta_salario_1,
        v_atleta_endereco_1
    FROM
        atleta
    WHERE
        id = 1;

    SELECT
        salario,
        endereco
    INTO
        v_atleta_salario_4,
        v_atleta_endereco_4
    FROM
        atleta
    WHERE
        id = 4;

    UPDATE atleta
    SET
        salario = v_atleta_salario_4
    WHERE
        id = 1;

    UPDATE atleta
    SET
        endereco = v_atleta_endereco_4
    WHERE
        id = 1;

EXCEPTION
    WHEN no_data_found THEN
        SELECT
            AVG(salario)
        INTO v_atleta_salario_medio
        FROM
            atleta;

        v_atleta_endereco_1 := NULL;
        UPDATE atleta
        SET
            salario = v_atleta_salario_medio
        WHERE
            id = 1;

        UPDATE atleta
        SET
            endereco = v_atleta_endereco_1
        WHERE
            id = 1;

END;
/

CREATE OR REPLACE PROCEDURE pr_change_clube (
    p_atleta_id       IN atleta.id%TYPE,
    p_atleta_clube_id IN OUT atleta.id_clube%TYPE
) IS
BEGIN
    UPDATE atleta
    SET
        id_clube = p_atleta_clube_id
    WHERE
        id = p_atleta_id;

END;
/

DECLARE
    v_clube_id atleta.id_clube%TYPE := 1;
BEGIN
    pr_change_clube(3, v_clube_id);
END;
/

CREATE OR REPLACE PROCEDURE pr_update_salario (
    p_atleta_id_clube IN atleta.id_clube%TYPE
) AS

    p_atleta_salario atleta.salario%TYPE := 0;
    p_atleta_idade   NUMBER := 0;
    CURSOR c_atleta IS
    SELECT
        id,
        datanasc,
        salario
    FROM
        atleta
    WHERE
        id_clube = p_atleta_id_clube;

BEGIN
    FOR atleta IN c_atleta LOOP
        p_atleta_salario := atleta.salario;
        p_atleta_idade := ( sysdate - atleta.datanasc ) / 365;
        IF p_atleta_id_clube > 35 THEN
            p_atleta_salario := p_atleta_salario * 1.2;
        ELSE
            p_atleta_salario := p_atleta_salario * 1.1;
        END IF;

        UPDATE atleta
        SET
            salario = p_atleta_salario;

    END LOOP;
END;
/

DECLARE
    p_atleta_id_clube atleta.id_clube%TYPE := 1;
BEGIN
    pr_update_salario(p_atleta_id_clube);
END;
/

CREATE OR REPLACE FUNCTION fu_calculate_age (
    p_datanasc IN atleta.datanasc%TYPE
) RETURN NUMBER AS
    v_idade NUMBER;
BEGIN
    v_idade := round((sysdate - p_datanasc) / 365);
    RETURN v_idade;
END;
/

CREATE OR REPLACE FUNCTION fu_calculate_atleta_age (
    p_atleta_id IN atleta.id%TYPE
) RETURN NUMBER AS
    v_datanasc atleta.datanasc%TYPE;
    v_idade    NUMBER;
BEGIN
    SELECT
        datanasc
    INTO v_datanasc
    FROM
        atleta
    WHERE
        id = p_atleta_id;

    v_idade := round((sysdate - v_datanasc) / 365);
    RETURN v_idade;
END;
/

CREATE OR REPLACE FUNCTION fu_get_premiacao_atleta_periodo (
    p_atleta_nome  IN atleta.nome%TYPE,
    p_data_inicial IN DATE,
    p_data_final   IN DATE
) RETURN NUMBER AS
    v_atleta_id             atleta.id%TYPE;
    v_valor_total_premiacao NUMBER;
BEGIN
    SELECT
        id
    INTO v_atleta_id
    FROM
        atleta
    WHERE
        nome = p_atleta_nome;

    SELECT
        SUM(p.valor_premiacao)
    INTO v_valor_total_premiacao
    FROM
             participa p
        JOIN esporte    e ON p.registro_atleta = e.registro_atleta
        JOIN campeonato c ON p.id_campeonato = c.id
    WHERE
            e.id_atleta = v_atleta_id
        AND nvl(c.data_inicio, TO_DATE('01/01/1900', 'dd/mm/yyyy')) >= p_data_inicial
        AND nvl(c.data_fim, sysdate) <= p_data_final;

    RETURN v_valor_total_premiacao;
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20001, 'Atleta não encontrado!');
    WHEN OTHERS THEN
        raise_application_error(-20999, 'Erro encontrado: ' || sqlerrm);
END fu_get_premiacao_atleta_periodo;
/

SELECT
    nome,
    fu_get_premiacao_atleta_periodo(nome, TO_DATE('01/01/2014', 'dd/mm/yyyy'), TO_DATE('31/12/2025', 'dd/mm/yyyy')) AS premiacao
FROM
    atleta;

SELECT
    fu_get_premiacao_atleta_periodo('König', TO_DATE('01/01/2014', 'dd/mm/yyyy'), TO_DATE('31/12/2025', 'dd/mm/yyyy')) AS premiacao
FROM
    dual;

CREATE OR REPLACE PROCEDURE pr_get_info_clube (
    p_nome_clube        IN clube.nome%TYPE,
    p_media_idade       OUT NUMBER,
    p_folha_salarial    OUT NUMBER,
    p_quantidade_atleta OUT NUMBER
) IS
    v_id_clube clube.id%TYPE;
BEGIN
    SELECT
        id
    INTO v_id_clube
    FROM
        clube
    WHERE
        nome = p_nome_clube;

    SELECT
        round(AVG((sysdate - a.datanasc) / 365)),
        round(SUM(a.salario),
              2),
        COUNT(*)
    INTO
        p_media_idade,
        p_folha_salarial,
        p_quantidade_atleta
    FROM
             atleta a
        JOIN clube c ON a.id_clube = c.id
    WHERE
        c.id = v_id_clube;

    dbms_output.put_line('A média de idade dos atletas do clube '
                         || p_nome_clube
                         || ' é '
                         || p_media_idade
                         || ' anos.');

    dbms_output.put_line('A folha salarial desse clube é R$'
                         || p_folha_salarial
                         || ',00.');
    dbms_output.put_line('O número de atletas desse clube é '
                         || p_quantidade_atleta
                         || '.');
    dbms_output.put_line('');
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Clube não encontrado!');
    WHEN OTHERS THEN
        dbms_output.put_line(sqlerrm);
END pr_get_info_clube;
/

DECLARE
    v_clube clube.nome%TYPE := 'Task Force 141';
    v_idade NUMBER;
    v_sal   NUMBER;
    v_qtde  NUMBER;
BEGIN
    pr_get_info_clube(v_clube, v_idade, v_sal, v_qtde);
END;
/

DECLARE
    v_idade NUMBER;
    v_sal   NUMBER;
    v_qtde  NUMBER;
    CURSOR c_clube IS
    SELECT
        nome
    FROM
        clube;

BEGIN
    FOR reg_clube IN c_clube LOOP
        pr_get_info_clube(reg_clube.nome, v_idade, v_sal, v_qtde);
    END LOOP;
END;
/
*/

CREATE OR REPLACE FUNCTION fu_calcula_reajuste (
    p_id         IN atleta.id%TYPE,
    p_percentual IN NUMBER
) RETURN NUMBER IS
    v_salario        atleta.salario%TYPE;
    v_valor_reajuste atleta.salario%TYPE;
BEGIN
    SELECT
        salario
    INTO v_salario
    FROM
        atleta
    WHERE
        id = p_id;

    v_valor_reajuste := v_salario * ( 1 + p_percentual / 100 );
    RETURN v_valor_reajuste;
END fu_calcula_reajuste;
/

SELECT
    salario
FROM
    atleta
WHERE
    id = 1;

CREATE OR REPLACE PROCEDURE pr_altera_salario_atleta (
    p_atleta_id  IN atleta.id%TYPE,
    p_percentual IN NUMBER
) AS

    v_atleta_nome        atleta.nome%TYPE;
    v_salario_atual      atleta.salario%TYPE;
    v_salario_atualizado atleta.salario%TYPE;
BEGIN
    SELECT
        nome,
        salario
    INTO
        v_atleta_nome,
        v_salario_atual
    FROM
        atleta
    WHERE
        id = p_atleta_id;

    dbms_output.put_line('O salário atual do atleta '
                         || v_atleta_nome
                         || ' é '
                         || v_salario_atual
                         || '.');

    v_salario_atualizado := fu_calcula_reajuste(p_atleta_id, p_percentual);
    UPDATE atleta
    SET
        salario = v_salario_atualizado
    WHERE
        id = p_atleta_id;

    COMMIT;
    dbms_output.put_line('O novo salário do atleta '
                         || v_atleta_nome
                         || ' é '
                         || v_salario_atualizado
                         || '.');

END;
/

EXEC pr_altera_salario_atleta(1,10);