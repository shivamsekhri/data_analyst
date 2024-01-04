CREATE OR REPLACE DIRECTORY sales_directory as 'C:\Users\shiva\Desktop\data_analyst\SQL';
GRANT READ ON  DIRECTORY sales_directory TO sys;
CREATE TABLE sales_data (ORDERNUMBER NUMBER (8), QUANTITYORDERED NUMBER(5), PRICEEACH NUMBER(7,3),ORDERLINENUMBER NUMBER (3)
 , SALES NUMBER(9,3) ,ORDERDATE DATE ,STATUS VARCHAR(8) ,QTR_ID NUMBER(2),MONTH_ID NUMBER(2),
 YEAR_ID NUMBER(4),PRODUCTLINE VARCHAR(20) ,MSRP NUMBER(6,2) ,PRODUCTCODE VARCHAR(9),CUSTOMERNAME VARCHAR(20),PHONE VARCHAR(15),
 ADDRESSLINE1 VARCHAR(25),ADDRESSLINE2 VARCHAR(25),CITY VARCHAR(15),STATE VARCHAR(15),POSTALCODE VARCHAR(15),COUNTRY VARCHAR(20),
 TERRITORY VARCHAR (20),CONTACTLASTNAME VARCHAR(15),CONTACTFIRSTNAME VARCHAR(15),DEALSIZE VARCHAR (15))
    ORGANIZATION EXTERNAL ( TYPE ORACLE_LOADER
                            DEFAULT DIRECTORY sales_directory
                            ACCESS PARAMETERS
                            (FIELDS TERMINATED BY ",")
                            LOCATION ('sales_data.csv'));
drop table sales_data;
SELECT * FROM sales_data;