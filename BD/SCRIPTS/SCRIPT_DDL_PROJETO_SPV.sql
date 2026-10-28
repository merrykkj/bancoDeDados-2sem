/*
DROP TABLE t_spv_classif_fiscal CASCADE CONSTRAINTS;

DROP TABLE t_spv_cliente CASCADE CONSTRAINTS;

DROP TABLE t_spv_item_nf CASCADE CONSTRAINTS;

DROP TABLE t_spv_nota_fiscal CASCADE CONSTRAINTS;

DROP TABLE t_spv_produto CASCADE CONSTRAINTS;

DROP TABLE t_spv_unid_cml CASCADE CONSTRAINTS;
*/

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE t_spv_classif_fiscal (
    nr_cfop          NUMBER(4) NOT NULL,
    nr_tipo_operacao NUMBER(1) NOT NULL,
    nm_nat_operacao  VARCHAR2(80) NOT NULL,
    ds_nat_operacao  VARCHAR2(400) NOT NULL
);

ALTER TABLE T_SPV_CLASSIF_FISCAL 
    ADD CONSTRAINT CK_T_SPV_CLFISCAL_TIPO 
    CHECK ( nr_tipo_operacao = 1 OR nr_tipo_operacao = 2);
-- OPERADOR IN (LISTA VALORES)
-- NR_TIPO_OPERACAO IN (1,2))

ALTER TABLE t_spv_classif_fiscal ADD CONSTRAINT pk_t_spv_classif_fiscal PRIMARY KEY ( nr_cfop );

ALTER TABLE t_spv_classif_fiscal ADD CONSTRAINT un_t_spv_classif_fiscal_nome UNIQUE ( nm_nat_operacao );

CREATE TABLE t_spv_cliente (
    cd_cliente    NUMBER(5) NOT NULL,
    nm_cliente    VARCHAR2(60) NOT NULL,
    dt_nascimento DATE,
    ds_genero     CHAR(2) NOT NULL,
    ds_endereco   VARCHAR2(100) NOT NULL,
    ds_telefone   NUMBER(11),
    ds_email      VARCHAR2(100),
    nr_cpf        NUMBER(9) NOT NULL,
    nr_cpf_digito NUMBER(2) NOT NULL,
    nr_rg         NUMBER(8) NOT NULL,
    nr_rg_digito  CHAR(1) NOT NULL
);

ALTER TABLE t_spv_cliente
    ADD CONSTRAINT ck_t_spv_cliente_genero CHECK ( upper(ds_genero) = 'H'
                                                   OR upper(ds_genero) = 'M'
                                                   OR upper(ds_genero) = 'NB' );

ALTER TABLE t_spv_cliente ADD CONSTRAINT pk_t_spv_cliente PRIMARY KEY ( cd_cliente );

CREATE TABLE t_spv_item_nf (
    nr_nota_fiscal      NUMBER(5) NOT NULL,
    qt_comercializada   NUMBER(3) NOT NULL,
    vl_preco_unitario   NUMBER(7, 2) NOT NULL,
    vl_preco_total_item NUMBER(10, 2) NOT NULL,
    cd_produto          NUMBER(5) NOT NULL
);

ALTER TABLE t_spv_item_nf ADD CONSTRAINT ck_t_spv_item_nf_qtde CHECK ( qt_comercializada > 0 );

ALTER TABLE t_spv_item_nf ADD CONSTRAINT ck_t_spv_item_nf_preuni CHECK ( vl_preco_unitario > 0 );

ALTER TABLE t_spv_item_nf ADD CONSTRAINT pk_t_spv_item_nf PRIMARY KEY ( nr_nota_fiscal,
                                                                        cd_produto );

CREATE TABLE t_spv_nota_fiscal (
    nr_nota_fiscal NUMBER(5) NOT NULL,
    cd_cliente     NUMBER(5) NOT NULL,
    dt_emissao     DATE NOT NULL,
    dt_saida       DATE NOT NULL,
    vl_desconto    NUMBER(3, 1) NOT NULL,
    vl_total_nf    NUMBER(11, 2) NOT NULL,
    nr_cfop        NUMBER(4) NOT NULL
);

ALTER TABLE T_SPV_NOTA_FISCAL 
    ADD CONSTRAINT CK_T_SPV_Nf_DESCONTO 
    CHECK ( vl_desconto >= 0 AND vl_desconto <= 25);
-- BETWEEN -> AVALIA INTERVALOS FECHADOS
-- VL_DESCONTO BETWEEN 0 AND 25)

ALTER TABLE t_spv_nota_fiscal ADD CONSTRAINT ck_t_spv_nf_data CHECK ( dt_saida >= dt_emissao );

ALTER TABLE t_spv_nota_fiscal ADD CONSTRAINT pk_t_spv_nota_fiscal PRIMARY KEY ( nr_nota_fiscal );

CREATE TABLE t_spv_produto (
    cd_produto          NUMBER(5) NOT NULL,
    cd_unid_cml         NUMBER(3) NOT NULL,
    ds_produto          VARCHAR2(40) NOT NULL,
    ds_completa_produto VARCHAR2(400) NOT NULL,
    qt_estoque          NUMBER(3) NOT NULL,
    vl_preco_unitario   NUMBER(7, 2) NOT NULL
);

ALTER TABLE t_spv_produto ADD CONSTRAINT ck_t_spv_produto_preuni CHECK ( vl_preco_unitario > 0 );

ALTER TABLE t_spv_produto ADD CONSTRAINT pk_t_spv_produto PRIMARY KEY ( cd_produto );

ALTER TABLE t_spv_produto ADD CONSTRAINT un_t_spv_produto_desc UNIQUE ( ds_produto );

CREATE TABLE t_spv_unid_cml (
    cd_unid_cml NUMBER(3) NOT NULL,
    sg_unid_cml CHAR(6) NOT NULL,
    ds_unid_cml VARCHAR2(25) NOT NULL
);

ALTER TABLE t_spv_unid_cml ADD CONSTRAINT pk_t_spv_unid_cml PRIMARY KEY ( cd_unid_cml );

ALTER TABLE t_spv_unid_cml ADD CONSTRAINT un_t_spv_unid_cml_desc UNIQUE ( ds_unid_cml );

ALTER TABLE t_spv_item_nf
    ADD CONSTRAINT fk_t_spv_item_nf_nf FOREIGN KEY ( nr_nota_fiscal )
        REFERENCES t_spv_nota_fiscal ( nr_nota_fiscal );

ALTER TABLE t_spv_item_nf
    ADD CONSTRAINT fk_t_spv_item_nf_produto FOREIGN KEY ( cd_produto )
        REFERENCES t_spv_produto ( cd_produto );

ALTER TABLE t_spv_nota_fiscal
    ADD CONSTRAINT fk_t_spv_nf_classif_fiscal FOREIGN KEY ( nr_cfop )
        REFERENCES t_spv_classif_fiscal ( nr_cfop );

ALTER TABLE t_spv_nota_fiscal
    ADD CONSTRAINT fk_t_spv_nf_cliente FOREIGN KEY ( cd_cliente )
        REFERENCES t_spv_cliente ( cd_cliente );

ALTER TABLE t_spv_produto
    ADD CONSTRAINT fk_t_spv_prod_unid_cml FOREIGN KEY ( cd_unid_cml )
        REFERENCES t_spv_unid_cml ( cd_unid_cml );



-- Relat�rio do Resumo do Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             6
-- CREATE INDEX                             0
-- ALTER TABLE                             21
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
