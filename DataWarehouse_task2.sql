------------creation of customer table---------------------
CREATE TABLE dim_customer (
  cId INT PRIMARY KEY,
  PlaceId INT,
  Name VARCHAR(50),
  Surname VARCHAR(50) NOT NULL,
  Bday DATE,
  FOREIGN KEY (PlaceId) REFERENCES dim_place(PlaceId)
);

alter table dim_customer add Gender VARCHAR(5);

INSERT ALL
  INTO dim_customer (cId, PlaceId, Name, Surname, Bday, Gender) VALUES (1, 100, 'John', 'Doe', TO_DATE('1990-05-15', 'YYYY-MM-DD'), 'M')
  INTO dim_customer (cId, PlaceId, Name, Surname, Bday, Gender) VALUES (2, 100, 'Jane', 'Smith', TO_DATE('1985-08-20', 'YYYY-MM-DD'), 'F')
  INTO dim_customer (cId, PlaceId, Name, Surname, Bday, Gender) VALUES (3, 101, 'Michael', 'Johnson', TO_DATE('2000-01-02', 'YYYY-MM-DD'), 'M')
  INTO dim_customer (cId, PlaceId, Name, Surname, Bday, Gender) VALUES (4, 101, 'Emily', 'Brown', TO_DATE('1995-11-12', 'YYYY-MM-DD'), 'F')
  INTO dim_customer (cId, PlaceId, Name, Surname, Bday, Gender) VALUES (5, 102, 'William', 'Davis', TO_DATE('1972-04-25', 'YYYY-MM-DD'), 'M')
  INTO dim_customer (cId, PlaceId, Name, Surname, Bday, Gender) VALUES (6, 102, 'Sophia', 'Miller', TO_DATE('1988-09-30', 'YYYY-MM-DD'), 'F')
  INTO dim_customer (cId, PlaceId, Name, Surname, Bday, Gender) VALUES (7, 100, 'Alexander', 'Wilson', TO_DATE('2003-07-07', 'YYYY-MM-DD'), 'M')
  INTO dim_customer (cId, PlaceId, Name, Surname, Bday, Gender) VALUES (8, 101, 'Olivia', 'Taylor', TO_DATE('2002-03-18', 'YYYY-MM-DD'), 'F')
  INTO dim_customer (cId, PlaceId, Name, Surname, Bday, Gender) VALUES (9, 101, 'James', 'Anderson', TO_DATE('1978-12-05', 'YYYY-MM-DD'), 'M')
  INTO dim_customer (cId, PlaceId, Name, Surname, Bday, Gender) VALUES (10, 102, 'Isabella', 'Thomas', TO_DATE('1965-10-10', 'YYYY-MM-DD'), 'F')
SELECT * FROM dual;

---------------creation of place table-------

create table dim_place(
PlaceId  INT PRIMARY KEY, 
str_no VARCHAR(70), 
zip_code  VARCHAR2(100) NOT NULL
);
alter table dim_place add Name VARCHAR(50);
desc dim_place;

INSERT ALL
  INTO dim_place (PlaceId, str_no, zip_code, Name) VALUES (100, 'Sample Street 1', '12345', 'Berlin')
  INTO dim_place (PlaceId, str_no, zip_code, Name) VALUES (101, 'Sample Street 2', '23456', 'Cottbus')
  INTO dim_place (PlaceId, str_no, zip_code, Name) VALUES (102, 'Sample Street 3', '34567', 'Munich')
  
SELECT * FROM DUAL;


---------------creation of category table-------
create table dim_category(
Category_id INT,
Type VARCHAR(30)
);
ALTER TABLE dim_category
ADD CONSTRAINT pk_category PRIMARY KEY (Category_id);

INSERT ALL
    INTO dim_category (Category_id, Type)
    VALUES(200, 'Alcoholic')
    INTO dim_category (Category_id, Type)
    VALUES (201, 'Nonalcoholic')
select * from DUAL;

select * from dim_category;

---------------creation of products table-------
create table dim_products(
Pro_id INT PRIMARY KEY,
Name VARCHAR(50),
Liter NUMBER(3,2) NOT NULL,
Price NUMBER(3,2) NOT NULL
);
desc dim_products

ALTER TABLE dim_products
ADD (Category_id INT,
     CONSTRAINT fk_category FOREIGN KEY (Category_id) REFERENCES dim_category (Category_id));
     
ALTER TABLE dim_products
MODIFY (Pro_id NUMBER(3,0));

ALTER TABLE dim_products
MODIFY (Name varchar(70));

ALTER TABLE dim_products
MODIFY (Liter NUMBER(5,2));

ALTER TABLE dim_products
MODIFY (price NUMBER(5,2));

INSERT ALL
  INTO dim_products (Pro_id, Name, Liter, Price, Category_id) VALUES (300, 'Beer', 0.5, 4.99, 200)
  INTO dim_products (Pro_id, Name, Liter, Price, Category_id) VALUES (301, 'Wine', 0.75, 12.99, 200)
  INTO dim_products (Pro_id, Name, Liter, Price, Category_id) VALUES (302, 'Whiskey', 0.7, 39.99, 200)
  INTO dim_products (Pro_id, Name, Liter, Price, Category_id) VALUES (303, 'Soda', 1.5, 1.99, 201)
  INTO dim_products (Pro_id, Name, Liter, Price, Category_id) VALUES (304, 'Juice', 1, 2.49, 201)
  INTO dim_products (Pro_id, Name, Liter, Price, Category_id) VALUES (305, 'Water', 0.5, 0.99, 201)
  INTO dim_products (Pro_id, Name, Liter, Price, Category_id) VALUES (306, 'Vodka', 0.7, 29.99, 200)
  INTO dim_products (Pro_id, Name, Liter, Price, Category_id) VALUES (307, 'Tequila', 0.75, 34.99, 200)
  INTO dim_products (Pro_id, Name, Liter, Price, Category_id) VALUES (308, 'Cola', 1.5, 1.49, 201)
  INTO dim_products (Pro_id, Name, Liter, Price, Category_id) VALUES (309, 'Lemonade', 1, 1.79, 201)
SELECT * FROM DUAL;


---------------creation of branch table-------
create table dim_branch(
branch_id INT PRIMARY KEY,
reg_id INT,
Name VARCHAR(50),
FOREIGN KEY (reg_id) REFERENCES dim_region(reg_id)
);
INSERT ALL
  INTO dim_branch (branch_id, reg_id, name) VALUES (1, 13, 'DWT_BRANCH_1')
  INTO dim_branch (branch_id, reg_id, name) VALUES (2, 12, 'DWT_BRANCH_2')
  INTO dim_branch (branch_id, reg_id, name) VALUES (3, 11, 'DWT_BRANCH_3')
  INTO dim_branch (branch_id, reg_id, name) VALUES (4, 11, 'DWT_BRANCH_4')
  INTO dim_branch (branch_id, reg_id, name) VALUES (5, 13, 'DWT_BRANCH_5')
  INTO dim_branch (branch_id, reg_id, name) VALUES (6, 12, 'DWT_BRANCH_6')
SELECT * FROM DUAL;

select * from dim_branch;

---------------creation of region table-------
create table dim_region(
reg_id INT PRIMARY KEY,
Name VARCHAR(10)
);
INSERT ALL
    INTO dim_region (reg_id, Name) VALUES (11, 'North')
    INTO dim_region (reg_id, Name) VALUES (12, 'West')
    INTO dim_region (reg_id, Name) VALUES (13, 'East')
SELECT * FROM DUAL;


---------------creation of sales table-------

create table fact_sales(
sale_id INT PRIMARY Key,
cId INT,
Pro_id INT,
amount NUMBER(3,2) NOT NULL,
sale_date DATE NOT NULL,
FOREIGN KEY (Pro_id) REFERENCES dim_products(Pro_id),
FOREIGN KEY (cId) REFERENCES dim_customer(cId)
);

ALTER TABLE fact_sales
MODIFY (amount NUMBER(5,2));

INSERT ALL
    INTO fact_sales (sale_id, cId, Pro_id, amount, sale_date)
    VALUES (500, 1, 300, 2.5, TO_DATE('2023-06-01', 'YYYY-MM-DD'))
    INTO fact_sales (sale_id, cId, Pro_id, amount, sale_date)
    VALUES (501, 2, 303, 3, TO_DATE('2023-06-02', 'YYYY-MM-DD'))
    INTO fact_sales (sale_id, cId, Pro_id, amount, sale_date)
    VALUES (502, 3, 301, 1, TO_DATE('2023-06-03', 'YYYY-MM-DD'))
    INTO fact_sales (sale_id, cId, Pro_id, amount, sale_date)
    VALUES (503, 4, 306, 0.5, TO_DATE('2023-06-04', 'YYYY-MM-DD'))
    INTO fact_sales (sale_id, cId, Pro_id, amount, sale_date)
    VALUES (504, 5, 305, 1, TO_DATE('2023-06-05', 'YYYY-MM-DD'))
    INTO fact_sales (sale_id, cId, Pro_id, amount, sale_date)
    VALUES (505, 6, 304, 2, TO_DATE('2023-06-06', 'YYYY-MM-DD'))
    INTO fact_sales (sale_id, cId, Pro_id, amount, sale_date)
    VALUES (506, 7, 302, 0.7, TO_DATE('2023-06-07', 'YYYY-MM-DD'))
    INTO fact_sales (sale_id, cId, Pro_id, amount, sale_date)
    VALUES (507, 8, 308, 1, TO_DATE('2023-06-08', 'YYYY-MM-DD'))
    INTO fact_sales (sale_id, cId, Pro_id, amount, sale_date)
    VALUES (508, 9, 306, 1.5, TO_DATE('2023-06-09', 'YYYY-MM-DD'))
    INTO fact_sales (sale_id, cId, Pro_id, amount, sale_date)
    VALUES (509, 10, 300, 3, TO_DATE('2023-06-10', 'YYYY-MM-DD'))
SELECT * FROM DUAL;



------------1. customer should be possible to aggreted by group------------

ALTER TABLE dim_customer
ADD Age_Group VARCHAR(20);

UPDATE dim_customer
SET Age_Group = (
    SELECT
        CASE
            WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, BDAY) / 12) <= 15 THEN 'Child'
            WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, BDAY) / 12) BETWEEN 16 AND 19 THEN 'Youngster'
            WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, BDAY) / 12) BETWEEN 20 AND 29 THEN 'Young Adult'
            WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, BDAY) / 12) BETWEEN 30 AND 49 THEN 'Adult'
            ELSE 'Old Adult'
        END
    FROM
        dual
)
WHERE
    dim_customer.cId = dim_customer.cId;

select * from dim_customer;

------------------Daily sales--------------------
SELECT
  TRUNC("SALE_DATE", 'DD') AS Day,
  SUM(CAST(AMOUNT AS NUMBER)) AS TotalSales
FROM fact_sales
GROUP BY TRUNC("SALE_DATE", 'DD')
ORDER BY TRUNC("SALE_DATE", 'DD');

desc fact_sales
SELECT * FROM fact_sales;


---------------weekly sales------------------------------------------
SELECT TO_CHAR("SALE_DATE" - TO_CHAR("SALE_DATE", 'D') + 1, 'YYYY-MM-DD') AS Start_of_Week,
       TO_CHAR("SALE_DATE" - TO_CHAR("SALE_DATE", 'D') + 7, 'YYYY-MM-DD') AS End_of_Week,
       SUM(AMOUNT) AS Total_Sales
FROM fact_sales
GROUP BY TO_CHAR("SALE_DATE" - TO_CHAR("SALE_DATE", 'D') + 1, 'YYYY-MM-DD'),
         TO_CHAR("SALE_DATE" - TO_CHAR("SALE_DATE", 'D') + 7, 'YYYY-MM-DD');
         
         
-----------------Monthly sales--------------------------------
SELECT EXTRACT(YEAR FROM SALE_DATE) AS Year, 
       EXTRACT(MONTH FROM SALE_DATE) AS Month, 
       SUM(AMOUNT) AS Total_Sales 
FROM fact_sales  
GROUP BY EXTRACT(YEAR FROM SALE_DATE), EXTRACT(MONTH FROM SALE_DATE);

-----------------quarterly sales-------------------
SELECT EXTRACT(YEAR FROM sale_date) AS Year,
       CASE 
           WHEN EXTRACT(MONTH FROM sale_date) BETWEEN 1 AND 3 THEN 'Q1'
           WHEN EXTRACT(MONTH FROM sale_date) BETWEEN 4 AND 6 THEN 'Q2'
           WHEN EXTRACT(MONTH FROM sale_date) BETWEEN 7 AND 9 THEN 'Q3'
           WHEN EXTRACT(MONTH FROM sale_date) BETWEEN 10 AND 12 THEN 'Q4'
       END AS Quarter,
       SUM(AMOUNT) AS Total_Sales
FROM fact_sales
GROUP BY EXTRACT(YEAR FROM sale_date),
         CASE 
           WHEN EXTRACT(MONTH FROM sale_date) BETWEEN 1 AND 3 THEN 'Q1'
           WHEN EXTRACT(MONTH FROM sale_date) BETWEEN 4 AND 6 THEN 'Q2'
           WHEN EXTRACT(MONTH FROM sale_date) BETWEEN 7 AND 9 THEN 'Q3'
           WHEN EXTRACT(MONTH FROM sale_date) BETWEEN 10 AND 12 THEN 'Q4'
         END;


----------------yearly sales-----------------------------------
SELECT
  EXTRACT(YEAR FROM sale_date) AS Year,
  SUM(CAST(AMOUNT AS NUMBER)) AS TotalSales
FROM fact_sales
GROUP BY EXTRACT(YEAR FROM sale_date)
ORDER BY EXTRACT(YEAR FROM sale_date);


