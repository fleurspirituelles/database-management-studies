/* A cada início de sessão: */
ALTER SESSION SET "_ORACLE_SCRIPT" = true;
/* Habilita a execução de scripts com permissões de sistema. */

/* Limpa as tabelas quando necessário. */

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

/*  
    Oracle possui os seguintes data types:
    VARCHAR2(size) é um dado de caracteres de tamanho variável (1 a 4000).
    CHAR(size) é um dado de caracteres de tamanho fixo (1 a 2000).
    NUMBER(p,s) é um dado numérico de tamanho variável, onde p é a precisão (1 a 38) e s a escala (-84 e 127).
    DATE é um dado que aceita valores entre 01/01/4712 AC a 31/12/9999 DC).
    CLOB é um dado de caracteres até 4GB.
    BLOB é um dado binário até 4GB.

    PRIMARY KEY define a chave primária da tabela.
    FOREIGN KEY define uma chave estrangeira e por meio de REFERENCES indica a tabela de quem depende.
    CHECK verifica condições para uma coluna, as quais devem ser satisfeitas na inserção/atualização.
    UNIQUE determina que os valores da coluna deve ser único.
    NOT NULL indica que a coluna não aceita nulos.

    Por uma questão de boa prática, é adotado um padrão de criação de nomes de constraints:
    PK, FK, CK e UK para as constraints PRIMARY KEY, FOREIGN KEY, CHECK e UNIQUE, respectivamente.
*/

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
    /* CONSTRAINT atleta_clube_fk FOREIGN KEY ( id_clube )
        REFERENCES clube ( id ) */
);

/* Como a tabela clube ainda não existe, a tabela é criada sem a foreign key referenciando clube. */

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

/* Agora, com a tabela clube criada, é possível criar a constraint para atleta. */

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

/* Descreve a estrutura básica de uma tabela, isto é, suas colunas, tipos de dados, tamanhos, e se aceitam ou não valores nulos. */

DESCRIBE atleta;
DESC atleta;

/* Consulta todas as tabelas pertencentes ao usuário conectado:

SELECT
    table_name
FROM
    user_tables;

*/

/* Adiciona uma coluna em uma tabela existente. */
ALTER TABLE atleta ADD idade DATE;

/*Altera uma coluna existente. */
ALTER TABLE atleta MODIFY
    idade NUMBER(3);

/* Exclui uma coluna existente em uma tabela. */
ALTER TABLE atleta DROP COLUMN idade;

/* Insere dados em tabelas. */

INSERT INTO presidente (
    id,
    nome,
    cpf,
    email,
    telefone
) VALUES (
    1,
    'Godofredo Silva',
    '195.819.621-70',
    'gsilva@gmail.com',
    '(16) 3411-9878'
);

INSERT INTO presidente (
    id,
    nome,
    cpf,
    email,
    telefone
) VALUES (
    2,
    'Maria Sincera',
    '876.987.345-66',
    'marias@globo.com',
    '(19) 99876-8764'
);

INSERT INTO presidente (
    id,
    nome,
    cpf,
    email,
    telefone
) VALUES (
    3,
    'Patrício Dias',
    '100.200.300-44',
    'padias@outlook.com',
    '(11) 91254-8756'
);

/* Utilizar sempre aspas simples. */
/* Para formatar uma data utiliza-se a função to_date. Alguns formatos são DD/MM/YYYY, DDMMYYYY, YYYY-MM-DD. */

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    10,
    'Pinheiros',
    TO_DATE('11/04/1965', 'DD/MM/YYYY'),
    1
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    20,
    'Flamengo',
    TO_DATE('21/07/2010', 'DD/MM/YYYY'),
    3
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    30,
    'Clube da Luta',
    TO_DATE('03/08/1977', 'DD/MM/YYYY'),
    2
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    40,
    'Santos',
    TO_DATE('04/09/1921', 'DD/MM/YYYY'),
    NULL
);

INSERT INTO atleta (
    id,
    nome,
    cpf,
    sexo,
    datanasc,
    endereco,
    salario,
    id_clube
) VALUES (
    1,
    'Jade Barbosa',
    '112.356.757-34',
    'F',
    TO_DATE('27/10/1990', 'DD/MM/YYYY'),
    'Rua das Artes, 132',
    10500,
    NULL
);

INSERT INTO atleta (
    id,
    nome,
    cpf,
    sexo,
    datanasc,
    endereco,
    salario,
    id_clube
) VALUES (
    2,
    'Gustavo Borges',
    '231.423.547-11',
    'M',
    TO_DATE('10/05/1985', 'DD/MM/YYYY'),
    'Rua das Águas, 365',
    48300.55,
    NULL
);

INSERT INTO atleta (
    id,
    nome,
    cpf,
    sexo,
    datanasc,
    endereco,
    salario,
    id_clube
) VALUES (
    3,
    'Anderson Silva',
    '358.967.111-21',
    'M',
    TO_DATE('1982-02-15', 'YYYY-MM-DD'),
    'Av. Spider, 12',
    7200.50,
    30
);

INSERT INTO atleta (
    id,
    nome,
    cpf,
    sexo,
    datanasc,
    endereco,
    salario,
    id_clube
) VALUES (
    4,
    'Marta',
    '987.654.321-00',
    'F',
    TO_DATE('1988-07-07', 'YYYY-MM-DD'),
    'Rua da Bola, 1437',
    125000,
    40
);

/* Atualiza dados na tabela. */

UPDATE atleta
SET
    id_clube = 10
WHERE
    nome = 'Jade Barbosa';

UPDATE atleta
SET
    id_clube = 20
WHERE
    nome = 'Gustavo Borges';
    
/*  
    Ações referenciais engatilhadas são utilizadas para nortear as ações automáticas tomadas em relação às colunas que possuem restrições de chave estrangeira, quando são executados comandos update e delete.
    Restrict evita a eliminação de uma tupla referenciada.
    Cascade especifica que, quando uma tupla referenciada é eliminada ou atualizada, as tuplas que a referenciam devem ser automaticamente eliminadas ou atualizadas também.
    No action significa que se alguma tupla ainda existir quando a restrição for verificada, um erro é levantado. Difere de restrict por permitir a verificação até o final da transação.
    Set null e set default determinam que os valores das tuplas que referenciam a coluna cujo valor foi eliminado ou atualizado serão modificados para null ou default. 
    Porém, se set default violar a restrição de chave estrangeira, a operação falhará.
*/

ALTER TABLE atleta DROP CONSTRAINT atleta_clube_fk;

ALTER TABLE atleta
    ADD CONSTRAINT atleta_clube_fk FOREIGN KEY ( id_clube )
        REFERENCES clube ( id )
            ON DELETE CASCADE;

UPDATE clube
SET
    id_presidente = NULL
WHERE
    id_presidente = 1;

DELETE FROM presidente
WHERE
    nome = 'Godofredo Silva';

/* Recupera todas as colunas e os registros da tabela atleta: */

/* SELECT
    "A1"."ID"       "ID",
    "A1"."CPF"      "CPF",
    "A1"."NOME"     "NOME",
    "A1"."SEXO"     "SEXO",
    "A1"."DATANASC" "DATANASC",
    "A1"."ENDERECO" "ENDERECO",
    "A1"."SALARIO"  "SALARIO",
    "A1"."ID_CLUBE" "ID_CLUBE"
FROM
    "SYSTEM"."ATLETA" "A1";
*/

SELECT
    id,
    cpf,
    nome,
    sexo,
    datanasc,
    endereco,
    salario,
    id_clube
FROM
    atleta;
    
/* Recupera o id, data de nascimento, endereço e salário dos atletas: */

/*
SELECT
    "A1"."ID"       "ID",
    "A1"."DATANASC" "DATANASC",
    "A1"."ENDERECO" "ENDERECO",
    "A1"."SALARIO"  "SALARIO"
FROM
    "SYSTEM"."ATLETA" "A1";
*/

SELECT
    id,
    datanasc,
    endereco,
    salario
FROM
    atleta;
    
/* Recupera o id, nome e id do presidente dos clubes, exibindo os títulos das colunas como ID_CLUBE, NOME_CLUBE e PRESIDENTE: */

/*
SELECT
    "A1"."ID"            "ID_CLUBE",
    "A1"."NOME"          "NOME_CLUBE",
    "A1"."ID_PRESIDENTE" "PRESIDENTE"
FROM
    "SYSTEM"."CLUBE" "A1";
*/
SELECT
    id            AS "ID_CLUBE",
    nome          AS "NOME_CLUBE",
    id_presidente AS "PRESIDENTE"
FROM
    clube;

/* Recupera o nome e o salário dos atletas cujos nomes comecem com a letra "J". */

/*
SELECT
    "A1"."NOME"    "NOME",
    "A1"."SALARIO" "SALARIO"
FROM
    "SYSTEM"."ATLETA" "A1"
WHERE
    "A1"."NOME" LIKE 'J%';
*/

SELECT
    nome,
    salario
FROM
    atleta
WHERE
    nome LIKE 'J%';
    
/* Recupera o nome e o sexo dos atletas cuja penúltima letra do nome seja "t": */

/*
SELECT
    "A1"."NOME"    "NOME",
    "A1"."SALARIO" "SALARIO"
FROM
    "SYSTEM"."ATLETA" "A1"
WHERE
    "A1"."NOME" LIKE '%t_';
*/

SELECT
    nome,
    sexo
FROM
    atleta
WHERE
    nome LIKE '%t_';
    
/* Recupera o nome e o salário dos atletas que ganhem entre 5000 e 250000: */

/*
SELECT
    "A1"."NOME"    "NOME",
    "A1"."SALARIO" "SALARIO"
FROM
    "SYSTEM"."ATLETA" "A1"
WHERE
    "A1"."SALARIO" BETWEEN 5000 AND 250000;
*/

SELECT
    nome,
    salario
FROM
    atleta
WHERE
    salario BETWEEN 5000 AND 250000;