-- Create StockItem object type
CREATE TYPE StockItem AS OBJECT (
    stockNo    number,
    stockName   VARCHAR2(100),
    price       NUMBER(10, 2)
);
/


-- Create LineItem object type with REF to StockItem
CREATE TYPE LineItem AS OBJECT (
    lineItemNo  number,
    stockRef    REF StockItem,
    quantity    NUMBER(5)
);
/
-- Now insert the following data into the tables:
-- StockNo,StockName,Price
-- 1,Ballpoint Pen,1.20
-- 2,Notebook A5,2.50
-- 3,Stapler,3.75


-- LineNo,StockRef,Quantity
-- 1,3,2
-- 2,1,5
-- 3,1,1
-- 4,2,4
-- 5,2,3


CREATE TYPE StockItem AS OBJECT (
  stockNo   NUMBER,
  stockName VARCHAR2(100),
  price     NUMBER(10,2)
);
/

-- LineItem type (holds a REF to StockItem)
CREATE TYPE LineItem AS OBJECT (
  lineItemNo NUMBER,
  stockRef   REF StockItem,
  quantity   NUMBER(5)
);
/


-- Object table for StockItem OID is System Generated
CREATE TABLE Stock OF StockItem (stockno primary key);
  
-- Object table for LineItem; likewise
CREATE TABLE Line OF LineItem (lineitemno primary key);


INSERT INTO Stock VALUES (001, 'Ballpoint Pen', 1.20);
INSERT INTO Stock VALUES (002, 'Notebook A5', 2.50);
INSERT INTO Stock VALUES (003, 'Stapler', 3.75);


INSERT into line 
select 001, REF(s), 5
from app.stock s
WHERE s.stockno = 1;


-- Reading from the tables: 
Select * from line 


-- The REF value from the select statement will return a system generated oid. This can be better viewed from SQL Plus. 
-- Dereferencing the REF
-- An easy way to Dereference the REF using SQL is to use the dot notation.
Select l.stockref.stockname from line l;


-- Another way is to use the deref function.
SELECT
  l.lineItemNo,
  l.quantity,
  DEREF(l.stockRef).stockNo   AS stock_no,
  DEREF(l.stockRef).stockName AS stock_name,
  DEREF(l.stockRef).price     AS price
FROM Line l;
