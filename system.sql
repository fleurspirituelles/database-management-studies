/* A cada início de sessão: */
ALTER SESSION SET "_ORACLE_SCRIPT" = true;
/* Habilita a execução de scripts com permissões de sistema. */

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