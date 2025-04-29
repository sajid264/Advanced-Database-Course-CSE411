create TYPE StockItem_objtyp as object (
    StockNo NUMBER,
    Price NUMBER,
    TaxRate NUMBER 
);
/
CREATE TYPE LineItem_objtyp AS OBJECT (
    LineItemNo  NUMBER,
    Stock_ref   REF StockItem_objtyp,
    Quantity    NUMBER,
    Discount    Number
);
/
CREATE or replace type PhoneList_vartyp as VARRAY(10) of VARCHAR2(20);
/
create type Address_objtyp as object (
    Street VARCHAR2(52),
    City   VARCHAR2(52),
    State   VARCHAR2(52),
    Zip     VARCHAR2(20)
);
/
create OR REPLACE type customer_objtyp as object (
    CustNo number,
    CustName varchar2(52),
    Address_obj Address_objtyp,
    PhoneList_var PhoneList_vartyp,
    ORDER MEMBER function
        compareCustOrders(x in Customer_objtyp) return integer
) not final ;
/

create type LineItemList_ntabtyp as table of LineItem_objtyp;
/

CREATE or replace TYPE PurchaseOrder_objtyp AUTHID CURRENT_USER AS OBJECT (
    PONo number,
    Cust_Ref Ref Customer_objtyp,
    OrderDate date,
    ShipDate DATE,
    LineItemList_ntab LineItemList_ntabtyp,
    ShiptoAddress_obj Address_objtyp,

    Map member function 
        getPONo RETURN NUMBER,
    
    member FUNCTION
        sumLineItems RETURN NUMBER
    );
/

CREATE OR REPLACE TYPE BODY PURCHASEORDER_OBJTYP AS
    MAP MEMBER FUNCTION getPONo return number is 
    BEGIN
        RETURN PONO;
    END;

    MEMBER FUNCTION SUMLINEITEMS return number is

    i integer;
    StockVal StockItem_objtyp;
    Total number:= 0;

    begin
        for i in 1..self.LineItemList_ntab.COUNT LOOP
        UTL_REF.SELECT_OBJECT(LineItemList_ntab(i).Stock_ref, StockVal);
        Total := Total+ self.LineItemList_ntab(i).Quantity * StockVal.Price;
        end LOOP;
        Return TOTAL;
    END;
END;
/


CREATE OR REPLACE TYPE BODY customer_objtyp as
ORDER MEMBER FUNCTION compareCustOrders (x IN Customer_objtyp) RETURN INTEGER IS
    BEGIN
        RETURN custNo - x.custNo;
    END;
end;
/

-- object definitions finished.

-- Now to create the tables.

CREATE TABLE Customer_objtab OF customer_objtyp (custNo primary key)
    OBJECT IDENTIFIER IS PRIMARY KEY;

CREATE TABLE Stock_objtab OF StockItem_objtyp (StockNo PRIMARY KEY)
    OBJECT IDENTIFIER IS PRIMARY KEY;

CREATE TABLE PurchaseOrder_objtab OF PurchaseOrder_objtyp 
  (PRIMARY KEY (PONo), FOREIGN KEY (Cust_ref) REFERENCES Customer_objtab)  
  OBJECT IDENTIFIER IS PRIMARY KEY
  NESTED TABLE LineItemList_ntab STORE AS PoLine_ntab (
      (PRIMARY KEY (NESTED_TABLE_ID, LineItemNo))
      ORGANIZATION INDEX COMPRESS)
RETURN AS LOCATOR
/

ALTER TABLE POLINE_NTAB 
  ADD (SCOPE FOR (STOCK_REF) IS STOCK_OBJTAB);

-- Data


INSERT INTO Customer_objtab VALUES (
  Customer_objtyp(
    1,
    'Abdullah',
    Address_objtyp('123 Main St','Dhaka','Dhaka','1207'),
    PhoneList_vartyp('01511200215')
  )
);
INSERT INTO Customer_objtab VALUES (
  Customer_objtyp(
    2,
    'Borkot',
    Address_objtyp('456 Oak Ave','Chittagong','Chittagong','4000'),
    PhoneList_vartyp('01511200215')
  )
);
INSERT INTO Customer_objtab VALUES (
  Customer_objtyp(
    3,
    'Akib',
    Address_objtyp('456 Oak Ave','Chittagong','Chittagong','4000'),
    PhoneList_vartyp('01511200215')
  )
);
INSERT INTO Customer_objtab VALUES (
  Customer_objtyp(
    4,
    'Amor',
    Address_objtyp('123 Main St','Dhaka','Dhaka','1207'),
    PhoneList_vartyp('01511200215')
  )
);
INSERT INTO Customer_objtab VALUES (
  Customer_objtyp(
    5,
    'Bilal',
    Address_objtyp('456 Oak Ave','Chittagong','Chittagong','4000'),
    PhoneList_vartyp('01511200215')
  )
);
INSERT INTO Customer_objtab VALUES (
  Customer_objtyp(
    6,
    'Akbor',
    Address_objtyp('456 Oak Ave','Chittagong','Chittagong','4000'),
    PhoneList_vartyp('01511200215')
  )
);
COMMIT;
/


INSERT INTO Stock_objtab VALUES(1004, 6750.00, 2) ;
INSERT INTO Stock_objtab VALUES(1011, 4500.23, 2) ;
INSERT INTO Stock_objtab VALUES(1534, 2234.00, 2) ;
INSERT INTO Stock_objtab VALUES(1535, 3456.23, 2) ;

COMMIT;
/

insert into purchaseorder_objtab 
  select 1001, ref(c), sysdate, '10-mar-2023', lineItemList_ntabtyp(),
  null
  from customer_objtab c
  where c.CUSTNO =1;

commit;
/

INSERT INTO TABLE (
  SELECT P.LINEITEMLIST_NTAB 
  FROM PURCHASEORDER_OBJTAB P
  WHERE P.PONO = 1001
  )
  SELECT 05, REF(S), 12, 0
  FROM STOCK_OBJTAB S
  WHERE S.STOCKNO = 1534;

INSERT INTO TABLE
  (SELECT P.LINEITEMLIST_NTAB
  FROM PURCHASEORDER_OBJTAB P
  WHERE P.PONO = 1001)
  SELECT 04, REF(S), 12, 0
  FROM STOCK_OBJTAB S
  WHERE S.STOCKNO = 1534;


SELECT * FROM ALL_PROCEDURES 
WHERE OBJECT_TYPE='PACKAGE' AND OBJECT_NAME LIKE 'UTL_REF%';


delete from purchaseOrder_objtab;