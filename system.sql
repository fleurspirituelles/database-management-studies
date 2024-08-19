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

/* Utilizar sempre aspas simples. */
/* Para formatar uma data utiliza-se a função to_date. Alguns formatos são DD/MM/YYYY, DDMMYYYY, YYYY-MM-DD. */

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

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    7,
    '296-08-8396',
    'Delila Inkpen',
    'dinkpen6@creativecommons.org',
    '780-365-0148'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    8,
    '161-20-9079',
    'Diana Leamon',
    'dleamon7@360.cn',
    '229-312-6061'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    9,
    '672-60-6443',
    'Conrado Dumbare',
    'cdumbare8@nsw.gov.au',
    '615-551-0726'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    10,
    '706-68-9424',
    'Hilary Manilow',
    'hmanilow9@nymag.com',
    '992-959-5363'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    11,
    '749-67-5859',
    'Coop Coslett',
    'ccosletta@jimdo.com',
    '298-186-9432'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    12,
    '869-37-7117',
    'Ursola Brownhill',
    'ubrownhillb@whitehouse.gov',
    '311-276-9951'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    13,
    '600-92-1234',
    'Loise Farrand',
    'lfarrandc@fastcompany.com',
    '407-452-7376'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    14,
    '738-74-2426',
    'Cash Dubock',
    'cdubockd@w3.org',
    '833-696-6152'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    15,
    '800-64-7952',
    'Ermanno Tremblett',
    'etremblette@hatena.ne.jp',
    '182-481-9114'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    16,
    '417-01-9088',
    'Sherlock Laxtonne',
    'slaxtonnef@google.es',
    '533-285-4276'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    17,
    '875-11-9904',
    'Elvira Gerry',
    'egerryg@webmd.com',
    '761-323-5782'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    18,
    '286-95-6512',
    'Chelsey Swatland',
    'cswatlandh@flavors.me',
    '636-503-9898'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    19,
    '211-93-3474',
    'Ainsley Choppin',
    'achoppini@jiathis.com',
    '493-555-8065'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    20,
    '488-96-9333',
    'Moreen Abdee',
    'mabdeej@loc.gov',
    '502-474-3238'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    21,
    '641-03-9023',
    'Carlin Hamper',
    'champerk@tinypic.com',
    '530-138-7253'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    22,
    '612-83-3180',
    'Shantee Jouhning',
    'sjouhningl@topsy.com',
    '889-807-8646'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    23,
    '454-70-4908',
    'Dionysus Fazzioli',
    'dfazziolim@netlog.com',
    '545-870-5186'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    24,
    '821-98-6400',
    'Kristyn Ormesher',
    'kormeshern@oaic.gov.au',
    '111-146-0515'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    25,
    '786-87-1352',
    'Analiese Parsand',
    'aparsando@biglobe.ne.jp',
    '865-996-7431'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    26,
    '404-63-8997',
    'Prissie Cunningham',
    'pcunninghamp@g.co',
    '662-906-6610'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    27,
    '219-35-2949',
    'Sancho Belford',
    'sbelfordq@unesco.org',
    '748-551-7883'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    28,
    '570-56-9819',
    'Newton Iacomi',
    'niacomir@ftc.gov',
    '510-573-3936'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    29,
    '331-09-4646',
    'Frances Carslaw',
    'fcarslaws@soup.io',
    '547-390-0108'
);

INSERT INTO presidente (
    id,
    cpf,
    nome,
    email,
    telefone
) VALUES (
    30,
    '617-42-7162',
    'Nina Budden',
    'nbuddent@state.gov',
    '108-605-5951'
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
    3
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
    1
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
    5
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
    11
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
    16
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
    15
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    7,
    'Solarbreeze Club',
    NULL,
    26
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    8,
    'Duobam Team',
    TO_DATE('18/08/1990', 'dd/mm/yyyy'),
    6
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    9,
    'Flowdesk Team',
    TO_DATE('10/11/1934', 'dd/mm/yyyy'),
    17
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    10,
    'Veribet Club',
    TO_DATE('07/07/1994', 'dd/mm/yyyy'),
    25
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    11,
    'Fixflex Club',
    TO_DATE('25/04/1998', 'dd/mm/yyyy'),
    18
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    12,
    'Powerful Team',
    NULL,
    27
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    13,
    'Solowarm Team',
    TO_DATE('20/03/1939', 'dd/mm/yyyy'),
    2
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    14,
    'Tresom Club',
    TO_DATE('15/04/1955', 'dd/mm/yyyy'),
    20
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    15,
    'Sonsing Club',
    TO_DATE('17/11/1967', 'dd/mm/yyyy'),
    7
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    16,
    'Dragon Team',
    TO_DATE('29/08/1982', 'dd/mm/yyyy'),
    19
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    17,
    'Zamit Team',
    NULL,
    28
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    18,
    'Tregold Club',
    TO_DATE('01/09/1996', 'dd/mm/yyyy'),
    24
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    19,
    'Flexidy Team',
    TO_DATE('04/11/1999', 'dd/mm/yyyy'),
    4
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    20,
    'Toughjoy Club',
    TO_DATE('20/12/1945', 'dd/mm/yyyy'),
    12
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    21,
    'Stronghold Team',
    TO_DATE('16/07/1983', 'dd/mm/yyyy'),
    29
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    22,
    'Redhold Team',
    TO_DATE('23/09/1965', 'dd/mm/yyyy'),
    8
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    23,
    'Alpha Team',
    TO_DATE('16/10/1951', 'dd/mm/yyyy'),
    NULL
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    24,
    'Temp Club',
    TO_DATE('25/07/1989', 'dd/mm/yyyy'),
    22
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    25,
    'Kanlam Team',
    TO_DATE('08/12/1996', 'dd/mm/yyyy'),
    9
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    26,
    'Tamplight Club',
    TO_DATE('21/04/1946', 'dd/mm/yyyy'),
    10
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    27,
    'Holdlamis Club',
    TO_DATE('04/11/1961', 'dd/mm/yyyy'),
    23
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    28,
    'Ventosanzap Team',
    TO_DATE('14/02/1972', 'dd/mm/yyyy'),
    13
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    29,
    'Monster Team',
    TO_DATE('12/01/1933', 'dd/mm/yyyy'),
    21
);

INSERT INTO clube (
    id,
    nome,
    data_fundacao,
    id_presidente
) VALUES (
    30,
    'Voyatouch Club',
    TO_DATE('15/03/1952', 'dd/mm/yyyy'),
    14
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
    14
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
    27
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
    4,
    '291-05-4193',
    'Humfrid Iacovino',
    'M',
    TO_DATE('05/11/1994', 'dd/mm/yyyy'),
    '0379 Hoard Way',
    58567.74,
    19
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
    24
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
    26
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
    7,
    '246-93-5580',
    'Ringo Vidgeon',
    'M',
    TO_DATE('11/10/1996', 'dd/mm/yyyy'),
    '07 Jenifer Drive',
    83651.2,
    27
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
    8,
    '360-11-1351',
    'Shurwood Soan',
    'M',
    TO_DATE('02/08/2003', 'dd/mm/yyyy'),
    '831 Farmco Junction',
    75644.7,
    29
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
    9,
    '620-48-2618',
    'Pernell Boorer',
    'M',
    TO_DATE('01/12/1984', 'dd/mm/yyyy'),
    '47817 Marquette Hill',
    81478.62,
    11
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
    10,
    '266-64-4666',
    'Gannie Pidgeley',
    'M',
    TO_DATE('01/08/1990', 'dd/mm/yyyy'),
    '44 Columbus Pass',
    31384.28,
    15
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
    11,
    '831-23-8244',
    'Franzen Clawe',
    'M',
    TO_DATE('17/06/1988', 'dd/mm/yyyy'),
    '9 Dayton Parkway',
    27425.2,
    24
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
    12,
    '628-15-0557',
    'Sophie Teodorski',
    'F',
    TO_DATE('16/07/1985', 'dd/mm/yyyy'),
    '50703 Monica Court',
    33139.7,
    26
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
    13,
    '435-84-4340',
    'Ike Hakonsson',
    'M',
    TO_DATE('02/04/1999', 'dd/mm/yyyy'),
    '7 Lakeland Center',
    99488.3,
    19
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
    14,
    '664-74-5725',
    'Leandra Piner',
    'F',
    TO_DATE('08/12/2002', 'dd/mm/yyyy'),
    '04 Corben Parkway',
    18400.73,
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
    15,
    '655-85-9107',
    'Blanche Lillico',
    'F',
    TO_DATE('12/09/1986', 'dd/mm/yyyy'),
    '04 Nelson Lane',
    16602.8,
    25
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
    16,
    '682-27-0643',
    'Yulma Robatham',
    'M',
    TO_DATE('05/11/1992', 'dd/mm/yyyy'),
    '8604 Gulseth Park',
    37310.43,
    21
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
    17,
    '355-49-7452',
    'Donavon Grason',
    'M',
    TO_DATE('20/05/1984', 'dd/mm/yyyy'),
    '3 Independence Trail',
    71435.4,
    29
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
    18,
    '128-31-4916',
    'Madella Musgrove',
    'F',
    TO_DATE('22/11/1985', 'dd/mm/yyyy'),
    NULL,
    81106.95,
    26
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
    19,
    '517-09-3553',
    'Filip Dodamead',
    'M',
    TO_DATE('24/02/1995', 'dd/mm/yyyy'),
    NULL,
    80580.89,
    28
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
    20,
    '569-15-6773',
    'Allie Tessier',
    'F',
    TO_DATE('18/02/2000', 'dd/mm/yyyy'),
    '2 Merchant Place',
    51752.76,
    20
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
    21,
    '353-94-5414',
    'Lambert Taffs',
    'M',
    TO_DATE('12/11/1985', 'dd/mm/yyyy'),
    NULL,
    8726.67,
    13
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
    22,
    '130-39-3125',
    'Stanleigh Ruddock',
    'M',
    TO_DATE('11/12/1988', 'dd/mm/yyyy'),
    '9 Warner Pass',
    95669.88,
    25
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
    23,
    '168-50-2229',
    'Almire Beddard',
    'F',
    TO_DATE('27/07/1997', 'dd/mm/yyyy'),
    '88331 Canary Avenue',
    29395.38,
    7
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
    24,
    '712-34-8456',
    'Dominick Ivankin',
    NULL,
    TO_DATE('18/09/1998', 'dd/mm/yyyy'),
    NULL,
    87476.5,
    NULL
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
    25,
    '675-71-4440',
    'Ulises Damrel',
    'M',
    TO_DATE('31/12/1998', 'dd/mm/yyyy'),
    '76459 Mccormick Terrace',
    23071.69,
    8
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
    26,
    '220-07-5418',
    'Averill Drogan',
    'M',
    TO_DATE('30/01/1994', 'dd/mm/yyyy'),
    '50 Fordem Plaza',
    89908.05,
    9
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
    27,
    '340-97-8450',
    'Lancelot Apdell',
    'M',
    TO_DATE('09/07/1993', 'dd/mm/yyyy'),
    NULL,
    74344.23,
    23
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
    28,
    '787-79-7183',
    'Grace Pleavin',
    NULL,
    TO_DATE('28/01/2002', 'dd/mm/yyyy'),
    '8 Bunting Trail',
    28456.48,
    NULL
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
    29,
    '724-38-1676',
    'Yale Buttle',
    'M',
    TO_DATE('18/03/1996', 'dd/mm/yyyy'),
    '9 Brown Street',
    71999.78,
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
    30,
    '102-98-8071',
    'Heinrick Samter',
    'M',
    TO_DATE('19/07/1995', 'dd/mm/yyyy'),
    NULL,
    6483.21,
    24
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
    31,
    '588-35-6857',
    'Addi Pryell',
    'F',
    TO_DATE('06/01/1982', 'dd/mm/yyyy'),
    '452 Sommers Parkway',
    68771.69,
    17
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
    32,
    '686-72-1859',
    'Johna Belf',
    NULL,
    TO_DATE('02/07/1988', 'dd/mm/yyyy'),
    '1056 Birchwood Center',
    84061.29,
    NULL
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
    33,
    '469-83-6887',
    'Hoyt Hawker',
    'M',
    TO_DATE('31/07/1995', 'dd/mm/yyyy'),
    '9 Dorton Terrace',
    91900.05,
    11
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
    34,
    '471-78-5539',
    'Isadora Renny',
    'F',
    TO_DATE('07/11/1983', 'dd/mm/yyyy'),
    '357 Mayer Point',
    26402.05,
    9
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
    35,
    '714-45-3007',
    'Paula Wotton',
    'F',
    TO_DATE('29/12/1998', 'dd/mm/yyyy'),
    '2 Nevada Junction',
    93320.55,
    26
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
    36,
    '694-18-8019',
    'Matthaeus Ferran',
    'M',
    TO_DATE('16/02/1984', 'dd/mm/yyyy'),
    '2004 New Castle Drive',
    93107.43,
    24
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
    37,
    '407-36-6488',
    'Caspar Perago',
    'M',
    TO_DATE('15/01/2003', 'dd/mm/yyyy'),
    '366 Mesta Center',
    60880.46,
    8
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
    38,
    '163-16-3947',
    'Colleen Tunnacliffe',
    NULL,
    TO_DATE('09/09/2004', 'dd/mm/yyyy'),
    '62028 Little Fleur Junction',
    92680.28,
    NULL
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
    39,
    '637-11-6317',
    'Hazel Rheubottom',
    'F',
    TO_DATE('14/01/2002', 'dd/mm/yyyy'),
    '7838 Scoville Plaza',
    32834.63,
    26
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
    40,
    '735-67-1419',
    'Doloritas Torald',
    'F',
    TO_DATE('15/10/2001', 'dd/mm/yyyy'),
    '30286 Westport Center',
    65209.14,
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
    41,
    '247-52-2228',
    'Merwyn Sivills',
    'M',
    TO_DATE('03/07/2000', 'dd/mm/yyyy'),
    '072 Kensington Crossing',
    4461.3,
    10
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
    42,
    '542-62-1084',
    'Herc Pococke',
    'M',
    TO_DATE('03/01/1995', 'dd/mm/yyyy'),
    '35538 Briar Crest Plaza',
    27190.48,
    10
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
    43,
    '135-46-2106',
    'Galven Duckett',
    'M',
    TO_DATE('25/09/1993', 'dd/mm/yyyy'),
    '316 Banding Street',
    54741.98,
    10
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
    44,
    '798-27-7620',
    'Miquela Malloy',
    'F',
    TO_DATE('09/04/1983', 'dd/mm/yyyy'),
    '21 Cottonwood Street',
    6998.47,
    9
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
    45,
    '435-02-4281',
    'Mickie Kille',
    'F',
    TO_DATE('19/11/1999', 'dd/mm/yyyy'),
    '44277 6th Court',
    60622.94,
    18
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
    46,
    '835-52-6663',
    'Oren Peers',
    'M',
    TO_DATE('22/01/2002', 'dd/mm/yyyy'),
    NULL,
    34656.84,
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
    47,
    '599-51-1118',
    'Josephine Chelam',
    'F',
    TO_DATE('23/05/2002', 'dd/mm/yyyy'),
    '758 Cordelia Way',
    68826.28,
    16
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
    48,
    '763-03-7123',
    'Tessi Eyckel',
    'F',
    TO_DATE('24/01/1997', 'dd/mm/yyyy'),
    '02130 Graceland Road',
    63682.13,
    7
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
    49,
    '567-41-3531',
    'Buddy Riddell',
    'M',
    TO_DATE('20/12/1999', 'dd/mm/yyyy'),
    '16 Clemons Alley',
    72662.65,
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
    50,
    '690-41-7944',
    'Ianthe MacRory',
    'F',
    TO_DATE('25/11/1998', 'dd/mm/yyyy'),
    '558 6th Pass',
    56328.64,
    28
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
    51,
    '876-07-0897',
    'Tootsie Filochov',
    'F',
    TO_DATE('05/10/1986', 'dd/mm/yyyy'),
    '0 Oxford Terrace',
    61866.27,
    23
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
    52,
    '104-47-6827',
    'Lou Lovie',
    'M',
    TO_DATE('26/11/2004', 'dd/mm/yyyy'),
    '6 Marcy Lane',
    11438.04,
    10
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
    53,
    '889-40-5983',
    'Toddy McCormick',
    'M',
    TO_DATE('17/05/1983', 'dd/mm/yyyy'),
    '074 Village Street',
    41665.36,
    17
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
    54,
    '315-51-0136',
    'Marshall McSporrin',
    'M',
    TO_DATE('21/07/1990', 'dd/mm/yyyy'),
    '677 Claremont Center',
    58388.74,
    7
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
    55,
    '668-46-5053',
    'Cyndi Gianulli',
    'F',
    TO_DATE('14/03/2003', 'dd/mm/yyyy'),
    '6 Clemons Avenue',
    24114.04,
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
    56,
    '148-54-7626',
    'Estele Stapele',
    'F',
    TO_DATE('07/12/2002', 'dd/mm/yyyy'),
    NULL,
    39272.93,
    13
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
    57,
    '710-41-8143',
    'Laurie Castellino',
    'M',
    TO_DATE('14/02/1990', 'dd/mm/yyyy'),
    '9 Forster Drive',
    83247.63,
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
    58,
    '645-82-3678',
    'Alisun Skelly',
    'F',
    TO_DATE('16/09/2003', 'dd/mm/yyyy'),
    NULL,
    44655.4,
    14
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
    59,
    '164-99-8076',
    'Rube Jossum',
    'M',
    TO_DATE('17/10/1986', 'dd/mm/yyyy'),
    '42 Coleman Street',
    19398.26,
    21
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
    60,
    '469-69-8829',
    'Nappy Flory',
    'M',
    TO_DATE('21/12/1997', 'dd/mm/yyyy'),
    NULL,
    70949.4,
    8
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
    61,
    '446-79-9387',
    'Bendix Alti',
    'M',
    TO_DATE('30/03/2002', 'dd/mm/yyyy'),
    NULL,
    17586.7,
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
    62,
    '480-71-4866',
    'Eyde Juschke',
    'F',
    TO_DATE('08/09/1993', 'dd/mm/yyyy'),
    '83 Hanover Parkway',
    67042.57,
    18
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
    63,
    '881-45-4652',
    'Wilhelmina Iggulden',
    'F',
    TO_DATE('16/01/1994', 'dd/mm/yyyy'),
    '116 8th Terrace',
    27070.16,
    29
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
    64,
    '424-08-9564',
    'Matteo Sidaway',
    'M',
    TO_DATE('02/01/1986', 'dd/mm/yyyy'),
    NULL,
    80626.06,
    28
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
    65,
    '639-69-7692',
    'Hurleigh Bradnick',
    NULL,
    TO_DATE('01/02/1986', 'dd/mm/yyyy'),
    '9010 Sheridan Drive',
    43988.82,
    NULL
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
    66,
    '472-14-4192',
    'Ketti Huerta',
    'F',
    TO_DATE('05/05/2003', 'dd/mm/yyyy'),
    '3933 Clemons Way',
    40242.36,
    29
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
    67,
    '522-30-5384',
    'Neel Rootham',
    'M',
    TO_DATE('27/03/1983', 'dd/mm/yyyy'),
    '3 Milwaukee Point',
    61059.0,
    26
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
    68,
    '222-27-8381',
    'Richard Burcombe',
    'M',
    TO_DATE('14/04/1994', 'dd/mm/yyyy'),
    NULL,
    35821.87,
    16
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
    69,
    '808-28-5674',
    'Niko Ripsher',
    'M',
    TO_DATE('04/05/1989', 'dd/mm/yyyy'),
    '019 Loeprich Place',
    58856.83,
    28
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
    70,
    '301-96-5323',
    'Sonia Guinnane',
    'F',
    TO_DATE('16/03/1995', 'dd/mm/yyyy'),
    '07 Truax Point',
    76937.27,
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
    71,
    '787-68-4041',
    'Eberhard Pusill',
    'M',
    TO_DATE('17/12/1990', 'dd/mm/yyyy'),
    '72 Beilfuss Street',
    44553.49,
    22
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
    72,
    '325-66-8575',
    'Debby Emmines',
    'F',
    TO_DATE('15/07/1991', 'dd/mm/yyyy'),
    '9814 Continental Alley',
    47790.93,
    18
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
    73,
    '323-24-3904',
    'Lewes Labroue',
    'M',
    TO_DATE('02/10/2001', 'dd/mm/yyyy'),
    '1 Miller Center',
    26166.84,
    29
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
    74,
    '711-95-2411',
    'Olwen Dellenbrok',
    'F',
    TO_DATE('29/06/1986', 'dd/mm/yyyy'),
    '22362 Summit Road',
    12481.42,
    26
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
    75,
    '191-09-9408',
    'Tina Iacovides',
    'F',
    TO_DATE('26/12/1989', 'dd/mm/yyyy'),
    '3 Straubel Circle',
    23094.61,
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
    76,
    '845-78-6212',
    'Ingunna Caseborne',
    'F',
    TO_DATE('24/05/1985', 'dd/mm/yyyy'),
    '55 Golf View Place',
    72146.38,
    30
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
    77,
    '490-71-0232',
    'Carmita Filipponi',
    'F',
    TO_DATE('08/07/1994', 'dd/mm/yyyy'),
    NULL,
    79400.65,
    18
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
    78,
    '296-14-1783',
    'Karlene Raff',
    'F',
    TO_DATE('24/06/1989', 'dd/mm/yyyy'),
    NULL,
    9283.43,
    25
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
    79,
    '383-85-3985',
    'Janene Edelheid',
    'F',
    TO_DATE('08/07/2002', 'dd/mm/yyyy'),
    '22356 Michigan Place',
    36309.65,
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
    80,
    '184-50-2282',
    'Nial Crockett',
    'M',
    TO_DATE('12/04/1990', 'dd/mm/yyyy'),
    '2008 Union Trail',
    34466.84,
    17
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
    81,
    '321-24-7713',
    'Charlene Aisthorpe',
    'F',
    TO_DATE('22/11/1983', 'dd/mm/yyyy'),
    '2 Morrow Road',
    4849.42,
    9
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
    82,
    '373-19-2338',
    'Britt Balnaves',
    'F',
    TO_DATE('14/03/1990', 'dd/mm/yyyy'),
    '71720 Melby Point',
    65351.02,
    21
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
    83,
    '718-76-9515',
    'Anet Wanderschek',
    'F',
    TO_DATE('14/01/1998', 'dd/mm/yyyy'),
    '21 Sherman Avenue',
    39513.26,
    15
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
    84,
    '758-73-6597',
    'Timotheus Cudiff',
    'M',
    TO_DATE('13/05/2003', 'dd/mm/yyyy'),
    '35 Schurz Trail',
    72189.55,
    23
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
    85,
    '519-10-0270',
    'Karlene Freckelton',
    'F',
    TO_DATE('16/11/1993', 'dd/mm/yyyy'),
    NULL,
    68886.78,
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
    86,
    '208-82-4304',
    'Engelbert Brawson',
    'M',
    TO_DATE('28/07/1994', 'dd/mm/yyyy'),
    '46995 Loomis Junction',
    78588.68,
    29
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
    87,
    '782-62-0990',
    'Lu McOrkil',
    'F',
    TO_DATE('26/10/1989', 'dd/mm/yyyy'),
    '68 Farwell Parkway',
    35230.62,
    12
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
    88,
    '842-68-9833',
    'Gustaf Tilbury',
    'M',
    TO_DATE('25/08/1985', 'dd/mm/yyyy'),
    '1 Westport Crossing',
    28960.24,
    22
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
    89,
    '403-40-0578',
    'Elyn Hubbucke',
    'F',
    TO_DATE('23/12/1988', 'dd/mm/yyyy'),
    '9 Harper Junction',
    69247.67,
    22
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
    90,
    '156-48-3523',
    'Beryle Standall',
    'F',
    TO_DATE('05/05/1988', 'dd/mm/yyyy'),
    '3040 Lien Lane',
    7516.45,
    10
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
    91,
    '593-56-5435',
    'Royal Sallter',
    'M',
    TO_DATE('30/03/2004', 'dd/mm/yyyy'),
    '4261 Jackson Hill',
    12685.38,
    20
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
    92,
    '462-05-6321',
    'Lincoln Kingman',
    'M',
    TO_DATE('04/10/1999', 'dd/mm/yyyy'),
    '9 Sommers Hill',
    36671.07,
    17
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
    93,
    '863-17-0494',
    'Wesley Dregan',
    'M',
    TO_DATE('26/02/1984', 'dd/mm/yyyy'),
    '374 Macpherson Park',
    4369.48,
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
    94,
    '485-71-7411',
    'Tracey Lineham',
    'F',
    TO_DATE('21/09/1986', 'dd/mm/yyyy'),
    '845 Hermina Hill',
    67609.64,
    15
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
    95,
    '205-52-2681',
    'Pincus Prangle',
    'M',
    TO_DATE('12/09/1997', 'dd/mm/yyyy'),
    '2761 La Follette Alley',
    68900.2,
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
    96,
    '255-76-8860',
    'Delinda Crowth',
    'F',
    TO_DATE('19/09/1983', 'dd/mm/yyyy'),
    '94312 Darwin Alley',
    19997.72,
    16
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
    97,
    '526-92-9368',
    'Wendeline Braunds',
    'F',
    TO_DATE('25/04/1994', 'dd/mm/yyyy'),
    NULL,
    1696.42,
    18
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
    98,
    '656-79-4815',
    'Byrle Liepins',
    'M',
    TO_DATE('18/07/2004', 'dd/mm/yyyy'),
    '37 Bay Alley',
    74400.91,
    9
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
    99,
    '372-76-5429',
    'Jesselyn Minall',
    'F',
    TO_DATE('06/11/1985', 'dd/mm/yyyy'),
    '3 Grover Trail',
    73084.88,
    13
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
    100,
    '449-34-3717',
    'Zachariah Eddowis',
    'M',
    TO_DATE('06/09/1989', 'dd/mm/yyyy'),
    NULL,
    36736.02,
    8
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    3,
    '(601) 7382910'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    35,
    '(424) 1277153'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    8,
    '(853) 4939806'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    10,
    '(537) 7676929'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    5,
    '(930) 3424502'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    24,
    '(805) 8850394'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    21,
    '(961) 4319690'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    39,
    '(582) 5786007'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    19,
    '(327) 4362855'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    25,
    '(334) 6464131'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    36,
    '(220) 5874448'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    14,
    '(245) 6444676'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    3,
    '(204) 7075984'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    29,
    '(831) 6814772'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    8,
    '(823) 9114157'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    1,
    '(172) 4988196'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    40,
    '(528) 3226452'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    3,
    '(304) 7327208'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    31,
    '(167) 8232204'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    36,
    '(903) 1863360'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    17,
    '(803) 1615017'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    1,
    '(663) 8443211'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    14,
    '(931) 5897442'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    20,
    '(859) 8551564'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    12,
    '(973) 3484414'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    24,
    '(620) 1429068'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    15,
    '(418) 3535451'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    25,
    '(464) 6517647'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    15,
    '(376) 3345143'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    29,
    '(750) 2970402'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    22,
    '(402) 2094554'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    5,
    '(934) 8184141'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    19,
    '(508) 1233810'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    15,
    '(524) 9040828'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    10,
    '(949) 7263269'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    6,
    '(827) 9983340'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    27,
    '(634) 9608119'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    17,
    '(353) 1617571'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    27,
    '(930) 3096037'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    21,
    '(705) 3022456'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    36,
    '(901) 2881330'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    2,
    '(190) 1524601'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    15,
    '(665) 6201461'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    16,
    '(685) 9381272'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    32,
    '(344) 4370898'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    16,
    '(974) 2598779'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    3,
    '(208) 5945890'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    31,
    '(874) 3764618'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    19,
    '(335) 4648941'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    7,
    '(645) 3624445'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    16,
    '(146) 1553210'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    8,
    '(920) 5577754'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    5,
    '(535) 7174885'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    10,
    '(519) 9464991'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    39,
    '(493) 5374018'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    19,
    '(634) 4159429'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    24,
    '(950) 5932172'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    23,
    '(599) 3251876'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    31,
    '(584) 3107077'
);

INSERT INTO atleta_contato (
    id_atleta,
    contato
) VALUES (
    1,
    '(566) 9226280'
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

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    5,
    'S'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    7,
    'S'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    8,
    'S'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    10,
    'S'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    12,
    'N'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    13,
    'N'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    15,
    'S'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    16,
    'N'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    17,
    'S'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    19,
    'S'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    20,
    'S'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    21,
    'N'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    25,
    'N'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    28,
    'N'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    30,
    'S'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    31,
    'S'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    32,
    'N'
);

INSERT INTO olimpico (
    id_atleta,
    incentivo_governo
) VALUES (
    35,
    'N'
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
    9,
    'Visual',
    3
);

INSERT INTO paraolimpico (
    id_atleta,
    deficiencia,
    nivel
) VALUES (
    11,
    'Auditiva',
    2
);

INSERT INTO paraolimpico (
    id_atleta,
    deficiencia,
    nivel
) VALUES (
    14,
    'Motora',
    2
);

INSERT INTO paraolimpico (
    id_atleta,
    deficiencia,
    nivel
) VALUES (
    18,
    'Motora',
    4
);

INSERT INTO paraolimpico (
    id_atleta,
    deficiencia,
    nivel
) VALUES (
    24,
    'Motora',
    1
);

INSERT INTO paraolimpico (
    id_atleta,
    deficiencia,
    nivel
) VALUES (
    29,
    'Visual',
    4
);

INSERT INTO paraolimpico (
    id_atleta,
    deficiencia,
    nivel
) VALUES (
    33,
    'Motora',
    2
);

INSERT INTO paraolimpico (
    id_atleta,
    deficiencia,
    nivel
) VALUES (
    36,
    'Auditiva',
    2
);

INSERT INTO paraolimpico (
    id_atleta,
    deficiencia,
    nivel
) VALUES (
    39,
    'Motora',
    1
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

INSERT INTO modalidade (
    id,
    descricao,
    olimpica
) VALUES (
    6,
    'Swimming',
    'S'
);

INSERT INTO modalidade (
    id,
    descricao,
    olimpica
) VALUES (
    7,
    'Cycling',
    'S'
);

INSERT INTO modalidade (
    id,
    descricao,
    olimpica
) VALUES (
    8,
    'Fencing',
    'S'
);

INSERT INTO modalidade (
    id,
    descricao,
    olimpica
) VALUES (
    9,
    'Running',
    'S'
);

INSERT INTO modalidade (
    id,
    descricao,
    olimpica
) VALUES (
    10,
    'Gymnastics',
    'S'
);

INSERT INTO modalidade (
    id,
    descricao,
    olimpica
) VALUES (
    11,
    'Cards',
    'N'
);

INSERT INTO modalidade (
    id,
    descricao,
    olimpica
) VALUES (
    12,
    'Videogame',
    'N'
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    29,
    5,
    TO_DATE('23/03/2002', 'dd/mm/yyyy'),
    18.6
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    22,
    1,
    TO_DATE('30/09/1991', 'dd/mm/yyyy'),
    29.0
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    27,
    11,
    TO_DATE('04/05/1993', 'dd/mm/yyyy'),
    27.4
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    31,
    10,
    TO_DATE('18/03/1991', 'dd/mm/yyyy'),
    29.6
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    25,
    10,
    NULL,
    NULL
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    30,
    8,
    NULL,
    NULL
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    9,
    9,
    TO_DATE('28/07/2016', 'dd/mm/yyyy'),
    4.2
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    34,
    7,
    NULL,
    NULL
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    30,
    2,
    TO_DATE('11/08/1993', 'dd/mm/yyyy'),
    27.2
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    20,
    1,
    TO_DATE('11/05/2008', 'dd/mm/yyyy'),
    12.4
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    2,
    4,
    TO_DATE('13/02/1995', 'dd/mm/yyyy'),
    25.7
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    35,
    5,
    NULL,
    NULL
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    4,
    12,
    NULL,
    NULL
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    25,
    11,
    TO_DATE('18/08/1995', 'dd/mm/yyyy'),
    25.2
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    18,
    9,
    TO_DATE('27/07/2000', 'dd/mm/yyyy'),
    20.2
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    37,
    7,
    TO_DATE('19/02/1993', 'dd/mm/yyyy'),
    27.7
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    38,
    4,
    TO_DATE('27/12/2012', 'dd/mm/yyyy'),
    7.8
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    4,
    9,
    TO_DATE('19/04/1991', 'dd/mm/yyyy'),
    29.5
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    1,
    9,
    TO_DATE('30/03/1997', 'dd/mm/yyyy'),
    23.5
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    17,
    8,
    TO_DATE('10/03/2002', 'dd/mm/yyyy'),
    18.6
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    14,
    4,
    TO_DATE('18/03/1998', 'dd/mm/yyyy'),
    22.6
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    26,
    6,
    TO_DATE('27/01/2007', 'dd/mm/yyyy'),
    13.7
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    32,
    9,
    TO_DATE('06/10/2016', 'dd/mm/yyyy'),
    4.0
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    1,
    8,
    TO_DATE('22/08/2002', 'dd/mm/yyyy'),
    18.1
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    21,
    11,
    TO_DATE('23/12/1994', 'dd/mm/yyyy'),
    25.8
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    11,
    7,
    TO_DATE('16/08/2003', 'dd/mm/yyyy'),
    17.2
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    10,
    10,
    TO_DATE('05/06/1990', 'dd/mm/yyyy'),
    30.4
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    21,
    5,
    NULL,
    NULL
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    25,
    9,
    TO_DATE('25/11/1995', 'dd/mm/yyyy'),
    24.9
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    4,
    8,
    NULL,
    NULL
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    17,
    4,
    TO_DATE('05/09/2003', 'dd/mm/yyyy'),
    17.1
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    14,
    12,
    TO_DATE('04/02/2006', 'dd/mm/yyyy'),
    14.7
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    22,
    9,
    TO_DATE('12/07/1995', 'dd/mm/yyyy'),
    25.3
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    37,
    9,
    TO_DATE('25/10/2017', 'dd/mm/yyyy'),
    3.0
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    17,
    7,
    TO_DATE('03/04/2000', 'dd/mm/yyyy'),
    20.5
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    8,
    3,
    TO_DATE('12/01/1998', 'dd/mm/yyyy'),
    22.8
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    27,
    6,
    TO_DATE('13/08/2001', 'dd/mm/yyyy'),
    19.2
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    17,
    10,
    TO_DATE('02/12/1997', 'dd/mm/yyyy'),
    22.9
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    30,
    12,
    TO_DATE('28/04/2004', 'dd/mm/yyyy'),
    16.5
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    8,
    6,
    TO_DATE('11/04/1993', 'dd/mm/yyyy'),
    27.5
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    36,
    4,
    TO_DATE('01/12/1996', 'dd/mm/yyyy'),
    23.9
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    16,
    7,
    TO_DATE('09/02/1991', 'dd/mm/yyyy'),
    29.7
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    23,
    3,
    NULL,
    NULL
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    17,
    2,
    TO_DATE('19/08/2001', 'dd/mm/yyyy'),
    19.2
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    37,
    5,
    TO_DATE('13/09/1993', 'dd/mm/yyyy'),
    27.1
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    26,
    9,
    TO_DATE('29/01/2000', 'dd/mm/yyyy'),
    20.7
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    8,
    1,
    NULL,
    NULL
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    7,
    6,
    TO_DATE('08/03/1990', 'dd/mm/yyyy'),
    30.6
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    35,
    8,
    TO_DATE('11/03/2012', 'dd/mm/yyyy'),
    8.6
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    10,
    12,
    TO_DATE('19/02/1995', 'dd/mm/yyyy'),
    25.7
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    16,
    4,
    TO_DATE('20/06/2018', 'dd/mm/yyyy'),
    2.3
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    7,
    2,
    TO_DATE('30/12/2009', 'dd/mm/yyyy'),
    10.8
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    14,
    6,
    TO_DATE('05/06/1993', 'dd/mm/yyyy'),
    27.4
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    30,
    5,
    TO_DATE('28/08/1994', 'dd/mm/yyyy'),
    26.1
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    9,
    2,
    TO_DATE('16/11/2007', 'dd/mm/yyyy'),
    12.9
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    10,
    9,
    NULL,
    NULL
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    38,
    1,
    TO_DATE('22/11/2016', 'dd/mm/yyyy'),
    3.9
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    35,
    1,
    NULL,
    NULL
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    39,
    4,
    TO_DATE('22/07/2010', 'dd/mm/yyyy'),
    10.2
);

INSERT INTO pratica (
    id_atleta,
    id_modalidade,
    data_inicio,
    experiencia
) VALUES (
    24,
    4,
    TO_DATE('14/05/1997', 'dd/mm/yyyy'),
    23.4
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

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    7,
    'Mydo Championship',
    'Nova Lima',
    TO_DATE('07/02/2015', 'dd/mm/yyyy'),
    TO_DATE('07/03/2015', 'dd/mm/yyyy')
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    8,
    'Thoughtworks Tournament',
    'Lengkongsari',
    TO_DATE('09/05/2018', 'dd/mm/yyyy'),
    TO_DATE('31/07/2018', 'dd/mm/yyyy')
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    9,
    'Lazzy Cup',
    'Shanghudi',
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
    10,
    'BlogXS Championship',
    'Shinan',
    TO_DATE('19/11/2013', 'dd/mm/yyyy'),
    TO_DATE('21/11/2013', 'dd/mm/yyyy')
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    11,
    'Skipstorm Tournament',
    'Sindou',
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
    12,
    'Trilith Cup',
    'Sebu',
    TO_DATE('16/06/2020', 'dd/mm/yyyy'),
    TO_DATE('20/06/2020', 'dd/mm/yyyy')
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    13,
    'Topicstorm Championship',
    'Rawasan',
    TO_DATE('17/03/2011', 'dd/mm/yyyy'),
    TO_DATE('24/03/2011', 'dd/mm/yyyy')
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    14,
    'Quinu Cup',
    'Zlotniki Kujawskie',
    TO_DATE('03/09/2017', 'dd/mm/yyyy'),
    TO_DATE('15/09/2017', 'dd/mm/yyyy')
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    15,
    'Youspan Tournament',
    'Pahonjean',
    TO_DATE('07/11/2017', 'dd/mm/yyyy'),
    TO_DATE('20/12/2017', 'dd/mm/yyyy')
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    16,
    'Camido Championship',
    'Masipi West',
    TO_DATE('19/06/2017', 'dd/mm/yyyy'),
    TO_DATE('24/06/2017', 'dd/mm/yyyy')
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    17,
    'Nlounge Cup',
    'Sanying',
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
    18,
    'Yombu Cup',
    'Menara',
    TO_DATE('28/03/2014', 'dd/mm/yyyy'),
    TO_DATE('03/05/2014', 'dd/mm/yyyy')
);

INSERT INTO campeonato (
    id,
    nome,
    local,
    data_inicio,
    data_fim
) VALUES (
    19,
    'Skiptube Championship',
    'Gaoping',
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
    20,
    'Browsecat Tournament',
    'Tomakivka',
    TO_DATE('13/05/2019', 'dd/mm/yyyy'),
    TO_DATE('15/06/2019', 'dd/mm/yyyy')
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    87715634,
    29,
    5
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    33416420,
    22,
    1
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    86986384,
    27,
    11
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    11547175,
    31,
    10
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    95166144,
    9,
    9
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    62048185,
    30,
    2
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    98353043,
    20,
    1
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    28626679,
    2,
    4
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    59911312,
    37,
    7
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    96196461,
    38,
    4
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    56608784,
    4,
    9
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    53241057,
    17,
    8
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    37285072,
    14,
    4
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    68327832,
    1,
    8
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    44528889,
    21,
    11
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    47362586,
    25,
    9
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    96395079,
    10,
    10
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    24731406,
    17,
    4
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    17671679,
    11,
    7
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    57253633,
    26,
    6
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    78031632,
    32,
    9
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    63644507,
    1,
    8
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    91373515,
    21,
    11
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    75844070,
    11,
    7
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    88442722,
    17,
    2
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    26063016,
    17,
    7
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    91645641,
    8,
    3
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    28339718,
    27,
    6
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    45811774,
    35,
    8
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    48981675,
    10,
    12
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    69592247,
    16,
    4
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    68685407,
    14,
    6
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    78173025,
    10,
    9
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    79043780,
    38,
    1
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    61056193,
    35,
    1
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    81655809,
    39,
    4
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    25609911,
    24,
    4
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    47090406,
    9,
    2
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    18546292,
    35,
    5
);

INSERT INTO esporte (
    registro_atleta,
    id_atleta,
    id_modalidade
) VALUES (
    95531262,
    4,
    12
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    87715634,
    13,
    6,
    4407.8
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    33416420,
    4,
    16,
    270.07
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    86986384,
    11,
    18,
    350.31
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    11547175,
    1,
    15,
    39618.25
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    95166144,
    18,
    25,
    98.99
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    62048185,
    6,
    16,
    2005.09
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    98353043,
    2,
    15,
    170.56
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    28626679,
    19,
    22,
    314.14
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    59911312,
    4,
    29,
    14.87
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    96196461,
    11,
    5,
    2506.61
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    56608784,
    13,
    10,
    15511.94
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    87715634,
    12,
    20,
    109.86
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    53241057,
    13,
    22,
    NULL
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    37285072,
    17,
    13,
    270.44
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    33416420,
    12,
    19,
    NULL
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    68327832,
    9,
    30,
    191.64
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    44528889,
    12,
    9,
    465.57
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    47362586,
    13,
    7,
    906.08
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    96395079,
    13,
    11,
    86.92
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    62048185,
    7,
    21,
    107.6
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    24731406,
    7,
    22,
    NULL
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    17671679,
    5,
    30,
    37.57
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    57253633,
    4,
    2,
    2331.09
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    78031632,
    5,
    24,
    NULL
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    63644507,
    8,
    1,
    70224.88
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    98353043,
    18,
    16,
    NULL
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    91373515,
    2,
    2,
    10261.26
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    28626679,
    11,
    3,
    16243.92
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    75844070,
    9,
    1,
    29506.26
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    86986384,
    6,
    24,
    76.42
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    88442722,
    6,
    29,
    8.14
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    96196461,
    3,
    22,
    239.66
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    62048185,
    19,
    1,
    35869.31
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    95166144,
    11,
    5,
    4085.82
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    26063016,
    19,
    2,
    18760.85
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    96395079,
    9,
    8,
    1629.99
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    91645641,
    10,
    19,
    NULL
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    86986384,
    8,
    13,
    167.56
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    53241057,
    18,
    21,
    NULL
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    37285072,
    5,
    16,
    262.87
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    57253633,
    3,
    5,
    2165.82
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    28339718,
    10,
    7,
    1474.87
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    45811774,
    10,
    15,
    227.4
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    48981675,
    14,
    1,
    74397.52
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    69592247,
    11,
    23,
    NULL
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    68685407,
    9,
    2,
    30752.48
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    44528889,
    17,
    20,
    81.41
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    78173025,
    19,
    10,
    692.19
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    79043780,
    10,
    2,
    6065.36
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    95166144,
    16,
    19,
    620.1
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    61056193,
    2,
    14,
    272.75
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    81655809,
    10,
    1,
    14597.76
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    25609911,
    18,
    5,
    NULL
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    61056193,
    20,
    3,
    6428.57
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    37285072,
    12,
    17,
    NULL
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    78173025,
    17,
    20,
    926.2
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    62048185,
    4,
    20,
    727.44
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    48981675,
    19,
    3,
    22099.41
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    91373515,
    14,
    28,
    143.31
);

INSERT INTO participa (
    registro_atleta,
    id_campeonato,
    colocacao,
    valor_premiacao
) VALUES (
    57253633,
    5,
    6,
    1736.93
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
    17,
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
    25,
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
    17,
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
    24,
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
    29,
    5,
    '(786) 8411691',
    'Dexter',
    '092',
    'Park',
    '33134',
    'Miami',
    'FL'
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
    21,
    6,
    '(434) 3343181',
    'Debra',
    '20896',
    'Terrace',
    '27705',
    'Durham',
    'NC'
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
    29,
    7,
    '(412) 2100712',
    'Graceland',
    '0093',
    'Avenue',
    '15215',
    'Pittsburgh',
    'PA'
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
    8,
    '(808) 3236645',
    'Hayes',
    '870',
    'Hill',
    '96815',
    'Honolulu',
    'HI'
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
    15,
    9,
    '(917) 1765373',
    'Knutson',
    '1',
    'Lane',
    '10280',
    'New York City',
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
    18,
    10,
    '(412) 7739903',
    'Waywood',
    '223',
    'Circle',
    '15250',
    'Pittsburgh',
    'PA'
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
    7,
    11,
    '(406) 1340148',
    'Arizona',
    '1773',
    'Road',
    '59806',
    'Missoula',
    'MT'
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
    11,
    12,
    '(937) 1593587',
    'Lillian',
    '6',
    'Hill',
    '45414',
    'Dayton',
    'OH'
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
    15,
    13,
    '(469) 5734653',
    'Westerfield',
    '07111',
    'Parkway',
    '75342',
    'Dallas',
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
    6,
    14,
    '(404) 5859229',
    'Brentwood',
    '917',
    'Court',
    '30336',
    'Atlanta',
    'GA'
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
    10,
    15,
    '(414) 7746157',
    'Hoepker',
    '04',
    'Drive',
    '53205',
    'Milwaukee',
    'WI'
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
    8,
    16,
    '(213) 9957974',
    'Bluejay',
    '5',
    'Crossing',
    '90025',
    'Los Angeles',
    'CA'
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
    17,
    '(303) 5974224',
    'Alpine',
    '580',
    'Hill',
    '80127',
    'Littleton',
    'CO'
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
    12,
    18,
    '(626) 5855274',
    'Jenna',
    '4',
    'Circle',
    '91199',
    'Pasadena',
    'CA'
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
    21,
    19,
    '(571) 3492863',
    'Stephen',
    '45344',
    'Street',
    '22093',
    'Ashburn',
    'VA'
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
    16,
    20,
    '(713) 7112184',
    'Columbus',
    '675',
    'Drive',
    '77035',
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
    19,
    21,
    '(410) 3538543',
    'Calypso',
    '6132',
    'Pass',
    '21216',
    'Baltimore',
    'MD'
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
    26,
    22,
    '(714) 7586665',
    'Jana',
    '18739',
    'Court',
    '92812',
    'Anaheim',
    'CA'
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
    12,
    23,
    '(253) 1156055',
    'Moulton',
    '0976',
    'Hill',
    '98166',
    'Seattle',
    'WA'
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
    10,
    24,
    '(832) 3039011',
    'Boyd',
    '12352',
    'Terrace',
    '77201',
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
    29,
    25,
    '(951) 5257547',
    'Sommers',
    '94',
    'Hill',
    '92878',
    'Corona',
    'CA'
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
    26,
    '(754) 7559434',
    'Hagan',
    '39245',
    'Junction',
    '33336',
    'Fort Lauderdale',
    'FL'
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
    9,
    27,
    '(205) 1247664',
    'Mayer',
    '02',
    'Hill',
    '35487',
    'Tuscaloosa',
    'AL'
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
    12,
    28,
    '(334) 8729842',
    'Rutledge',
    '52082',
    'Drive',
    '36134',
    'Montgomery',
    'AL'
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
    25,
    29,
    '(803) 7932508',
    'Johnson',
    '02961',
    'Parkway',
    '29225',
    'Columbia',
    'SC'
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
    24,
    30,
    '(510) 7973790',
    'Dixon',
    '7',
    'Crossing',
    '94622',
    'Oakland',
    'CA'
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
    7,
    31,
    '(775) 9934404',
    'Buena Vista',
    '261',
    'Street',
    '89595',
    'Reno',
    'NV'
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
    12,
    32,
    '(212) 1827738',
    'Cardinal',
    '4447',
    'Pass',
    '11254',
    'Brooklyn',
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
    12,
    33,
    '(310) 3485729',
    'Sunbrook',
    '0567',
    'Point',
    '90805',
    'Long Beach',
    'CA'
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
    13,
    34,
    '(434) 8733507',
    'Spohn',
    '161',
    'Center',
    '22111',
    'Manassas',
    'VA'
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
    16,
    35,
    '(402) 3060768',
    'Blaine',
    '39',
    'Place',
    '68124',
    'Omaha',
    'NE'
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
    23,
    36,
    '(314) 7800399',
    'Sunfield',
    '0890',
    'Circle',
    '63167',
    'Saint Louis',
    'MO'
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
    30,
    37,
    '(774) 6028432',
    'Drewry',
    '55',
    'Drive',
    '01610',
    'Worcester',
    'MA'
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
    27,
    38,
    '(225) 7049300',
    'Jay',
    '2311',
    'Circle',
    '70820',
    'Baton Rouge',
    'LA'
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
    23,
    39,
    '(212) 5469699',
    'Dapin',
    '075',
    'Junction',
    '10131',
    'New York City',
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
    11,
    40,
    '(504) 9639309',
    'Ryan',
    '61518',
    'Road',
    '70142',
    'New Orleans',
    'LA'
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
    24,
    41,
    '(617) 7482347',
    'Lawn',
    '00825',
    'Crossing',
    '02208',
    'Boston',
    'MA'
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
    42,
    '(701) 1337802',
    'Arizona',
    '15586',
    'Center',
    '58122',
    'Fargo',
    'ND'
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
    18,
    43,
    '(202) 3571515',
    'Badeau',
    '76',
    'Circle',
    '20088',
    'Washington',
    'DC'
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
    19,
    44,
    '(602) 7233920',
    'Express',
    '6507',
    'Alley',
    '85010',
    'Phoenix',
    'AZ'
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
    45,
    '(215) 2518875',
    'Farmco',
    '9964',
    'Point',
    '19172',
    'Philadelphia',
    'PA'
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
    19,
    46,
    '(417) 2791827',
    'Marcy',
    '1',
    'Lane',
    '65810',
    'Springfield',
    'MO'
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
    13,
    47,
    '(619) 9955921',
    'Rutledge',
    '39',
    'Trail',
    '92153',
    'San Diego',
    'CA'
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
    11,
    48,
    '(763) 7567922',
    'Bluestem',
    '212',
    'Place',
    '55598',
    'Loretto',
    'MN'
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
    49,
    '(907) 4629296',
    'Northfield',
    '86725',
    'Crossing',
    '99512',
    'Anchorage',
    'AK'
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
    27,
    50,
    '(325) 4359571',
    'Texas',
    '97946',
    'Center',
    '79699',
    'Abilene',
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
    20,
    51,
    '(502) 1917772',
    'Vidon',
    '18626',
    'Road',
    '40618',
    'Frankfort',
    'KY'
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
    7,
    52,
    '(408) 6747243',
    'Hoffman',
    '6',
    'Center',
    '95123',
    'San Jose',
    'CA'
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
    53,
    '(208) 2292372',
    'Blue Bill Park',
    '8',
    'Drive',
    '83716',
    'Boise',
    'ID'
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
    14,
    54,
    '(903) 6070958',
    'Spaight',
    '54',
    'Drive',
    '75705',
    'Tyler',
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
    29,
    55,
    '(714) 6899483',
    'Fieldstone',
    '460',
    'Center',
    '92725',
    'Santa Ana',
    'CA'
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
    10,
    56,
    '(559) 9332511',
    'Oxford',
    '19',
    'Circle',
    '93740',
    'Fresno',
    'CA'
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
    30,
    57,
    '(412) 9936053',
    'Porter',
    '7',
    'Point',
    '15134',
    'Mc Keesport',
    'PA'
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
    12,
    58,
    '(706) 6696603',
    'Rowland',
    '1',
    'Trail',
    '30919',
    'Augusta',
    'GA'
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
    59,
    '(404) 9864853',
    'Petterle',
    '3',
    'Point',
    '30343',
    'Atlanta',
    'GA'
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
    13,
    60,
    '(469) 7153460',
    'Onsgard',
    '3',
    'Lane',
    '75342',
    'Dallas',
    'TX'
);

/*  Uma sequence pode automaticamente gerar números únicos.
    É um objeto compartilhável (pode ser utilizado em várias tabelas).
    Pode ser utilizado para criar valores em chaves primárias.
    Permite especificar valores de incremento, início, máximo e mínimo, se é cíclica, e quantos valores são pré-alocados e armazenados em cache.
*/

CREATE SEQUENCE clube_seq INCREMENT BY 10 START WITH 100 MAXVALUE 9999 NOCACHE NOCYCLE;

INSERT INTO clube (
    id,
    nome
) VALUES (
    clube_seq.NEXTVAL,
    'Tabajara'
);

SELECT
    clube_seq.CURRVAL
FROM
    dual;

SELECT
    *
FROM
    clube;

ALTER SEQUENCE clube_seq INCREMENT BY 40;

INSERT INTO modalidade (
    id,
    descricao,
    olimpica
) VALUES (
    clube_seq.NEXTVAL,
    'Skating',
    'N'
);

SELECT
    clube_seq.CURRVAL
FROM
    dual;

DROP SEQUENCE clube_seq;

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
    
/* Recupera CPF e nome dos atletas que não possuem clube e ordena a lista alfabeticamente: */

SELECT
    cpf,
    nome
FROM
    atleta
WHERE
    atleta.id_clube IS NULL
ORDER BY
    nome;
    
/* Recupera id, nome, e salário de atletas que ganham menos que 10000. Ordena o resultado do maior para o menor salário. */

SELECT
    id,
    nome,
    salario
FROM
    atleta
WHERE
    salario < 10000
ORDER BY
    salario DESC;
    
/*  A função lower converte todos os caracteres para minúsculo.
    A função upper converte todos os caracteres para maiúsculo.
    A função initcap converte os caracteres iniciais das palavras em maiúsculo. */

SELECT
    lower(nome),
    upper(nome),
    initcap(endereco)
FROM
    atleta;
    
/*  A função concat concatena dois textos ou colunas.
    Só aceita dois argumentos. Normalmente é utilizado || para concatenação, pois não possui limite de argumentos. */

SELECT
    concat(nome, data_fundacao)
FROM
    clube;
    
/* A função substr recupera parte de um texto ou coluna. */

SELECT
    substr(nome, 1, 5)
FROM
    atleta;

/* A função length recupera o tamanho de um texto ou coluna. */

SELECT
    nome,
    length(nome) AS tamanho
FROM
    atleta;

/*  A função round arredonda casas decimais.
    A função trunc trunca as casas decimais. */

SELECT
    nome,
    round(salario, 0),
    trunc(salario, 1)
FROM
    atleta;
    
/*  A função trim remove espaços em branco do início e fim de uma string. 
    As funções ltrim e rtrim removem espaços do início (left) e fim (right) de uma string, respectivamente. */

SELECT
    TRIM(nome)
FROM
    atleta;

/* A função replace substitui as ocorrências de um ou mais caracteres por outros. */

SELECT
    replace(nome, 'e', 'i')
FROM
    clube;

/* A função translate substitui as ocorrências de vários caracteres simultaneamente.*/

SELECT
    translate(nome, 'aei', 'ouy')
FROM
    clube;
    
/* A função nvl testa se o valor de uma coluna é nulo e aplica o tratamento informado caso seja. */

SELECT
    nome,
    nvl(id_clube, 0)
FROM
    atleta;

SELECT
    nome,
    nvl(to_char(id_clube), 'Não possui')
FROM
    atleta;
    
/* A função case é uma estrutura condicinal. */

SELECT
    nome,
    sexo,
    CASE sexo
        WHEN 'M' THEN
            'Masculino'
        WHEN 'F' THEN
            'Feminino'
        ELSE
            'Não Informado'
    END
FROM
    atleta;

SELECT
    nome,
    salario,
    CASE
        WHEN salario > 50000 THEN
            0.3
        WHEN salario > 25000 THEN
            0.2
        WHEN salario > 5000  THEN
            0.1
        ELSE
            0
    END AS imposto
FROM
    atleta;
    
/*  A função decode é uma estrutura similar ao case, mas mais econômica em texto. 
    É utilizada apenas em comparações com igualdade. */

SELECT
    nome,
    sexo,
    decode(sexo, 'M', 'Masculino', 'F', 'Feminino',
           'Não Informado')
FROM
    atleta;
    
/*  Ao utilizar to_char para conversão: 
    O formato precisa ser escrito entre aspas simples.
    É case sensitive.
    Pode incluir qualquer formato de data válido.
    É separado do valor da data por vírgula. */

SELECT
    nome,
    to_char(datanasc, 'DD Month YYYY') AS data_dasc
FROM
    atleta;

SELECT
    to_char(valor_premiacao, '$99,999.00') valor
FROM
    participa
WHERE
    id_campeonato IN ( 7, 10 );

SELECT
    upper(nome),
    datanasc,
    CASE
        WHEN datanasc < TO_DATE('01/01/1990', 'dd/mm/yyyy') THEN
            5000
        WHEN datanasc < TO_DATE('01/01/2000', 'dd/mm/yyyy') THEN
            3000
        ELSE
            0
    END             AS bonus,
    endereco,
    decode(substr(endereco, - 6), 'Avenue', 'Avenida', 'Street', 'Rua',
           'Outro') AS tipo_endereco
FROM
    atleta;
    
/*  Funções de agregação incluem:
    - max (valor máximo),
    - min (valor mínimo),
    - avg (valor médio),
    - sum (soma de todos os valores),
    - count (número total de valores). */

SELECT
    MAX(salario),
    MIN(salario),
    AVG(salario),
    SUM(salario),
    COUNT(*)
FROM
    atleta;
    
/*  A função count(coluna) mostra o total de valores não nulos da coluna.
    A função count(*) mmostra o total de linhas do resultado. */

SELECT
    COUNT(*)
FROM
    clube;

SELECT
    COUNT(id_clube)
FROM
    atleta;

/* A função group by exibe a contagem por coluna. */

SELECT
    sexo,
    COUNT(*)
FROM
    atleta
GROUP BY
    sexo;

SELECT
    id_clube,
    SUM(salario)
FROM
    atleta
GROUP BY
    id_clube
ORDER BY
    id_clube;

SELECT
    id_clube,
    SUM(salario)
FROM
    atleta
WHERE
    id_clube IN ( 12, 15, 24 )
GROUP BY
    id_clube
ORDER BY
    id_clube;

SELECT
    id_clube,
    sexo,
    round(AVG(salario), 2) AS media
FROM
    atleta
GROUP BY
    id_clube,
    sexo
ORDER BY
    id_clube;
    
/*  A cláusula having deve envolver função de agrupamento.
    Para filtrar registros, where deve ser utilizada. */

SELECT
    id_clube,
    SUM(salario)
FROM
    atleta
GROUP BY
    id_clube
HAVING
    SUM(salario) > 200000;

SELECT
    COUNT(*)
FROM
    centro_treinamento;

SELECT
    id_clube,
    COUNT(*)
FROM
    centro_treinamento
GROUP BY
    id_clube;

SELECT
    id_clube
FROM
    centro_treinamento
GROUP BY
    id_clube
HAVING
    COUNT(*) = 1;
    
/*  Lista o valor total de premiação distribuída no campeonato de id 19. */

SELECT
    id_campeonato,
    SUM(valor_premiacao) AS valor_total
FROM
    participa
WHERE
    id_campeonato = 19
GROUP BY
    id_campeonato;

/*  Lista a média de valor de premiação por campeonato para os campeonatos 2, 8, e 14.
    Arredonda para exibir com 1 casa decimal. */

SELECT
    id_campeonato,
    AVG(valor_premiacao) AS media_premiacao
FROM
    participa
WHERE
    id_campeonato IN ( 2, 8, 14 )
GROUP BY
    id_campeonato;

/*  Encontra a quantidade de atletas que pratica cada modalidade esportiva. */

/*  Para cada modalidade esportiva praticada, lista o maior e o menor tempo de experiência.
    Ordena os resultados por id de modalidade. */

/*  Lista o id do campeonato e a quantidade de atletas que participaram deles, exibindo somente os campeonatos com mais de 3 participantes.
    Ordena os resultados por quantidade de participantes decrescentemente. */
    
/*  Lista a média de colocação dos atletas participantes de campeonatos, exibindo o número de registro do atleta e sua colocação media truncada sem casas decimais.
    Descarta as tuplas em que não houve valor de premiação.
    Deixa na listagem apenas os atletas com colocação média até o décimo lugar.
    Ordena os resultados por colocação média. */

CREATE USER snoopy IDENTIFIED BY snoopy;

GRANT
    CREATE SESSION
TO snoopy;

GRANT
    CREATE TABLE
TO snoopy;

ALTER USER snoopy
    QUOTA UNLIMITED ON users;
    
GRANT
    CREATE SEQUENCE
TO snoopy;