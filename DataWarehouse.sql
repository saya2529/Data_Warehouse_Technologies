//checking table in each branch

SELECT distinct table_name
FROM all_tab_columns
WHERE owner = 'DWT_BRANCH_1';

SELECT distinct table_name
FROM all_tab_columns
WHERE owner = 'DWT_BRANCH_2';

SELECT distinct table_name
FROM all_tab_columns
WHERE owner = 'DWT_BRANCH_6';

---------------------------------DWT_BRANCH_1------------------------------------

DESC DWT_BRANCH_1.customer;

//Creation of DWT_BRANCH_1.customer
CREATE TABLE DWT_BRANCH_1.customer (
  ID      NUMBER(11) NOT NULL,
  NAME    VARCHAR2(40),
  SURNAME VARCHAR2(40) NOT NULL,
  STR     VARCHAR2(60),
  NO      VARCHAR2(5),
  ZIP     VARCHAR2(5) NOT NULL,
  PLACE   VARCHAR2(50) NOT NULL,
  GEND    CHAR(1),
  BDAY    DATE,
  
  CONSTRAINT PK_CUSTOMER PRIMARY KEY (ID),
  CONSTRAINT CHK_GEND CHECK (GEND IN ('M', 'F'))
);

DESC DWT_BRANCH_1.order;
//Create table order
CREATE TABLE DWT_BRANCH1."ORDER" (
  "ORDER" VARCHAR2(15) NOT NULL,
  "DATE" DATE NOT NULL,
  "AMOUNT" CHAR(5) NOT NULL,
  "CSTMR" NUMBER(11),
  "PRO" NUMBER(11),
  CONSTRAINT fk_cstmr FOREIGN KEY (cstmr) REFERENCES dwt_branch_1.customer (id) NOT DEFERRABLE,
  CONSTRAINT fk_pro FOREIGN KEY (pro) REFERENCES dwt_branch_1.products (id) NOT DEFERRABLE
);

DESC DWT_BRANCH_1.products;
//create table products
CREATE TABLE DWT_BRANCH1.products (
  ID    NUMBER(11) NOT NULL,
  NAME  VARCHAR2(50) NOT NULL,
  SORT  VARCHAR2(20),
  SZ    NUMBER(3,2) NOT NULL,
  PRICE NUMBER(3,2) NOT NULL
);

//Select for customer
SELECT *
FROM DWT_BRANCH_1.customer;

//Select for order
SELECT *
FROM DWT_BRANCH_1."ORDER";

//Select for products
SELECT *
FROM DWT_BRANCH_1.products;

---------------------------------DWT_BRANCH_2---------------------------------------

select * from all_tab_columns where owner='DWT_BRANCH_2';

//Describe Branch 2 with columns

DESC DWT_BRANCH_2.BUYS;
DESC DWT_BRANCH_2.CUSTOMER;
DESC DWT_BRANCH_2.PLACE;
DESC DWT_BRANCH_2.PRODUCT;


//Creation of columns of DWT_BRANCH_2

create table DWT_BRANCH_2.BUYS(CNUMBER NOT NULL NUMBER(10),PNUMBER NOT NULL NUMBER(10),AMOUNT NOT NULL VARCHAR2(5),DATE NOT NULL DATE);

create table DWT_BRANCH_2.CUSTOMER(NUM NOT NULL NUMBER(12),LASTNAME NOT NULL VARCHAR2(50),FIRSTNAME VARCHAR2(50),PLACEID NUMBER(5),BDAY DATE);


create table DWT_BRANCH_2.PLACE(PLID NOT NULL NUMBER(5), STR_NO VARCHAR2(70), ZIP_PLACE NOT NULL VARCHAR2(100));


create table DWT_BRANCH_2.PRODUCT(NUM NOT NULL NUMBER(12), LABEL NOT NULL VARCHAR2(40), TYPE NOT NULL VARCHAR2(30), LITER NOT NULL NUMBER(3,2), 
PRICE NOT NULL VARCHAR2(10));


//Select for buys
SELECT *
FROM DWT_BRANCH_2.BUYS;

//Select for customer
SELECT *
FROM DWT_BRANCH_2.CUSTOMER;

//Select for place
SELECT *
FROM DWT_BRANCH_2.PLACE;

//Select for product
SELECT * 
FROM DWT_BRANCH_2.PRODUCT;

------------------------------------DWT_BRANCH_2----------------------------------

--------select database DWT_BRANCH_6-----------
select * from all_tab_columns where owner='DWT_BRANCH_6';

//Describe Branch 6 with columns


DESC DWT_BRANCH_6.CUSTOMER;
DESC DWT_BRANCH_6.ORDERS;
DESC DWT_BRANCH_6.PRODUCT;


//Creation of columns of DWT_BRANCH_6

create table DWT_BRANCH_6.CUSTOMER(CCODE NOT NULL NUMBER(10), SURNAME NOT NULL VARCHAR2(30),FIRSTNAME VARCHAR2(30),STR_NO VARCHAR2(60), ZIP_PLACE VARCHAR2(50), GENDER NUMBER(1), BDAY DATE);


create table DWT_BRANCH_6.ORDERS(IDC NOT NULL NUMBER(13), KC NOT NULL NUMBER(10),DATE NOT NULL DATE, AMOUNT NOT NULL NUMBER(3));


create table DWT_BRANCH_6.PRODUCT(IDCODE NOT NULL NUMBER(13), NAME_VOL VARCHAR2(50), PRICE NOT NULL VARCHAR2(3, 2), UNIT VARCHAR2(20));

//Select for customer
SELECT *
FROM DWT_BRANCH_6.CUSTOMER;

//Select for ORDERS
SELECT *
FROM DWT_BRANCH_6.ORDERS;


//Select for PRODUCT
SELECT *
FROM DWT_BRANCH_6.PRODUCT;


