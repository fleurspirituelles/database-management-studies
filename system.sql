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