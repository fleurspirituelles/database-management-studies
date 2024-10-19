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
    salario  NUMBER(8, 2) NOT NULL,
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
    contato   VARCHAR(20),
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

ALTER TABLE atleta ADD idade DATE;

ALTER TABLE atleta MODIFY
    idade NUMBER(3);

ALTER TABLE atleta DROP COLUMN idade;

ALTER TABLE atleta DROP CONSTRAINT atleta_clube_fk;

ALTER TABLE atleta
    ADD CONSTRAINT atleta_clube_fk FOREIGN KEY ( id_clube )
        REFERENCES clube ( id )
            ON DELETE CASCADE;

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    1,
    '785-45-5286',
    'Tamera Bravington',
    'tbravington0@studiopress.com',
    '367-956-3178'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    2,
    '289-05-0419',
    'Billie Dargavel',
    'bdargavel1@clickbank.net',
    '995-722-9098'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    3,
    '261-92-1249',
    'Murdock Evesque',
    'mevesque2@merriam-webster.com',
    '320-493-9072'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    4,
    '167-95-8399',
    'Sharai Jahncke',
    'sjahncke3@wordpress.org',
    '907-590-0532'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    5,
    '150-79-1794',
    'Uta Guillond',
    'uguillond4@odnoklassniki.ru',
    '426-617-7731'
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    1,
    'Bigtax Team',
    TO_DATE('24/06/1930', 'dd/mm/yyyy'),
    1
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    2,
    'Prodder Club',
    TO_DATE('28/02/1977', 'dd/mm/yyyy'),
    2
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    3,
    'Itil Club',
    NULL,
    3
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    4,
    'Trippledex Club',
    TO_DATE('16/09/1987', 'dd/mm/yyyy'),
    4
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    5,
    'Jabbing Club',
    NULL,
    5
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
    '505-75-9669',
    'Lawry Peterken',
    'M',
    TO_DATE('23/01/1984', 'dd/mm/yyyy'),
    '82920 Kedzie Trail',
    5767.3,
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
    '259-09-1273',
    'Frederic Bernardoux',
    'M',
    TO_DATE('01/11/1994', 'dd/mm/yyyy'),
    '822 Valley Edge Hill',
    85648.36,
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
    '332-26-7082',
    'Agatha Renard',
    'F',
    TO_DATE('29/06/1990', 'dd/mm/yyyy'),
    '874 Hermina Alley',
    82419.55,
    3
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
    4,
    '291-05-4193',
    'Humfrid Iacovino',
    'M',
    TO_DATE('05/11/1994', 'dd/mm/yyyy'),
    '0379 Hoard Way',
    58567.74,
    4
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
    5,
    '330-36-7223',
    'Foster Rushmere',
    'M',
    TO_DATE('01/03/2002', 'dd/mm/yyyy'),
    '3546 Eastlawn Point',
    86158.05,
    5
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    1,
    '(601) 7382910'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    2,
    '(424) 1277153'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    3,
    '(853) 4939806'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    4,
    '(537) 7676929'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    5,
    '(930) 3424502'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    1,
    'N'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    2,
    'S'
);

INSERT INTO paraolimpico (
    id_atleta,
    deficiencia,
    nivel
) VALUES (
    4,
    'Motora',
    5
);

INSERT INTO paraolimpico (
    id_atleta,
    deficiencia,
    nivel
) VALUES (
    5,
    'Visual',
    3
);

INSERT INTO modalidade (
    id,
    descricao,
    olimpica
) VALUES (
    1,
    'Soccer',
    'S'
);

INSERT INTO modalidade (
    id,
    descricao,
    olimpica
) VALUES (
    2,
    'Volleyball',
    'S'
);

INSERT INTO modalidade (
    id,
    descricao,
    olimpica
) VALUES (
    3,
    'Basketball',
    'S'
);

INSERT INTO modalidade (
    id,
    descricao,
    olimpica
) VALUES (
    4,
    'Fight',
    'S'
);

INSERT INTO modalidade (
    id,
    descricao,
    olimpica
) VALUES (
    5,
    'Hockey',
    'S'
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    1,
    1,
    TO_DATE('23/03/2002', 'dd/mm/yyyy'),
    18.6
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    2,
    2,
    TO_DATE('30/09/1991', 'dd/mm/yyyy'),
    29.0
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    3,
    3,
    TO_DATE('04/05/1993', 'dd/mm/yyyy'),
    27.4
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    4,
    4,
    TO_DATE('18/03/1991', 'dd/mm/yyyy'),
    29.6
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    5,
    5,
    NULL,
    NULL
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    1,
    'Vipe Cup',
    'Huolongping',
    TO_DATE('09/10/2016', 'dd/mm/yyyy'),
    TO_DATE('31/10/2016', 'dd/mm/yyyy')
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    2,
    'Vitz Championship',
    'Kapotnya',
    TO_DATE('12/02/2019', 'dd/mm/yyyy'),
    TO_DATE('30/11/2019', 'dd/mm/yyyy')
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    3,
    'Youfeed Championship',
    'Zeljezno Polje',
    NULL,
    NULL
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    4,
    'Mynte Cup',
    'Langxi',
    NULL,
    NULL
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    5,
    'Skimia Cup',
    'San Miguel',
    NULL,
    NULL
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    1,
    1,
    1
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    2,
    2,
    2
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    3,
    3,
    3
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    4,
    4,
    4
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    5,
    5,
    5
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    1,
    1,
    1,
    1000.00
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    2,
    1,
    2,
    800.00
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    3,
    1,
    3,
    600.00
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    4,
    1,
    4,
    400.00
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    5,
    1,
    5,
    200.00
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
    '(203) 8852807',
    'Forest Run',
    '360',
    'Center',
    '06726',
    'Waterbury',
    'CT'
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
    2,
    '(518) 1705042',
    'Elmside',
    '843',
    'Plaza',
    '12242',
    'Albany',
    'NY'
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
    3,
    3,
    '(713) 7019153',
    'Kings',
    '4',
    'Circle',
    '77045',
    'Houston',
    'TX'
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
    4,
    4,
    '(203) 1509611',
    'International',
    '106',
    'Avenue',
    '06816',
    'Danbury',
    'CT'
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
    5,
    5,
    '(786) 8411691',
    'Dexter',
    '092',
    'Park',
    '33134',
    'Miami',
    'FL'
);

ALTER TABLE atleta ADD idade NUMBER;

ALTER TABLE modalidade ADD qtde_praticantes NUMBER;

UPDATE atleta
SET
    idade = trunc(months_between(sysdate, datanasc) / 12);

UPDATE modalidade m
SET
    qtde_praticantes = (
        SELECT
            COUNT(*)
        FROM
            pratica
        WHERE
            id_modalidade = m.id
    );

SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER atualizar_idade_atleta BEFORE
    INSERT OR UPDATE ON atleta
    FOR EACH ROW
BEGIN
    :new.idade := trunc(months_between(sysdate, :new.datanasc) / 12);
END;
/

CREATE OR REPLACE TRIGGER atualizar_qtde_praticantes AFTER
    INSERT OR UPDATE OR DELETE ON pratica
BEGIN
    UPDATE modalidade m
    SET
        m.qtde_praticantes = (
            SELECT
                COUNT(*)
            FROM
                pratica p
            WHERE
                p.id_modalidade = m.id
        );

END;
/

CREATE OR REPLACE FUNCTION fu_get_total_camp (
    p_nome_atleta IN VARCHAR2
) RETURN NUMBER IS
    v_total_campeonatos NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO v_total_campeonatos
    FROM
             atleta a
        JOIN pratica   p ON a.id = p.id_atleta
        JOIN esporte   e ON p.id_atleta = e.id_atleta
                          AND p.id_modalidade = e.id_modalidade
        JOIN participa part ON e.registro_atleta = part.registro_atleta
    WHERE
        a.nome = p_nome_atleta;

    RETURN v_total_campeonatos;
END;
/

CREATE OR REPLACE PROCEDURE pr_calc_premio_atl_clube (
    p_nome_clube IN VARCHAR2
) IS

    v_nome_atleta  atleta.nome%TYPE;
    v_id_atleta    atleta.id%TYPE;
    v_total_premio NUMBER(10, 2);
    v_total_clube  NUMBER(10, 2) := 0;
    CURSOR c_atletas IS
    SELECT
        a.id,
        a.nome,
        coalesce(SUM(p.valor_premiacao),
                 0) AS total_premio
    FROM
             atleta a
        JOIN clube     c ON a.id_clube = c.id
        LEFT JOIN esporte   e ON a.id = e.id_atleta
        LEFT JOIN participa p ON e.registro_atleta = p.registro_atleta
    WHERE
        c.nome = p_nome_clube
    GROUP BY
        a.id,
        a.nome;

BEGIN
    FOR r_atleta IN c_atletas LOOP
        v_id_atleta := r_atleta.id;
        v_nome_atleta := r_atleta.nome;
        v_total_premio := r_atleta.total_premio;
        dbms_output.put_line('Atleta '
                             || v_id_atleta
                             || ' - '
                             || v_nome_atleta
                             || ': $'
                             || to_char(v_total_premio, '999,999.99'));

        v_total_clube := v_total_clube + v_total_premio;
    END LOOP;

    dbms_output.put_line('Total em premiação dos atletas do clube: $' || to_char(v_total_clube, '999,999.99'));
END pr_calc_premio_atl_clube;
/

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    6,
    '727-49-8657',
    'Casi Bilborough',
    'cbilborough5@youku.com',
    '445-135-1562'
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    6,
    'Bamity Team',
    TO_DATE('04/01/1949', 'dd/mm/yyyy'),
    6
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
    6,
    '878-04-7790',
    'Ranice Sherbourne',
    'F',
    TO_DATE('24/08/2004', 'dd/mm/yyyy'),
    '991 Almo Pass',
    65187.24,
    6
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    6,
    '(805) 8850394'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    3,
    'S'
);

INSERT INTO paraolimpico (
    id_atleta,
    deficiencia,
    nivel
) VALUES (
    6,
    'Auditiva',
    2
);

INSERT INTO modalidade (
    id,
    descricao,
    olimpica
) VALUES (
    6,
    'Swimming',
    'S'
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    6,
    6,
    TO_DATE('28/07/2016', 'dd/mm/yyyy'),
    4.2
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    6,
    'Npath Championship',
    'Taibao',
    TO_DATE('19/09/2015', 'dd/mm/yyyy'),
    TO_DATE('26/09/2015', 'dd/mm/yyyy')
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    6,
    6,
    6
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    6,
    1,
    6,
    100.00
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
    6,
    6,
    '(434) 3343181',
    'Debra',
    '20896',
    'Terrace',
    '27705',
    'Durham',
    'NC'
);

EXEC pr_calc_premio_atl_clube('Bigtax Team');

SELECT
    id,
    nome,
    idade
FROM
    atleta
WHERE
    id = 1;

SELECT
    fu_get_total_camp('Lawry Peterken')
FROM
    dual;