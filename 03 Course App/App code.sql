--App before inserting Methods and Functions

CREATE TYPE StockItem_objtyp AS OBJECT (
  StockNo    NUMBER,
  stockName  VARCHAR2(32),
  Price      NUMBER
  );
/


CREATE TYPE LineItem_objtyp AS OBJECT (
  LineItemNo   NUMBER,
  Stock_ref    REF StockItem_objtyp,
  Quantity     NUMBER
  );
/

CREATE OR REPLACE TYPE LineItem_objtyp AS OBJECT (
  LineItemNo   NUMBER,
  Stock_ref    REF StockItem_objtyp,
  Quantity     NUMBER
  );
/

CREATE TYPE PhoneList_vartyp AS VARRAY(10) OF VARCHAR2(20);
/

CREATE TYPE Address_objtyp AS OBJECT (
  Street         VARCHAR(32),
  Thana          VARCHAR(32),
  District       VARCHAR(32),
  Division       VARCHAR2(32)
  ) 
/

CREATE TYPE Customer_objtyp AS OBJECT (
  CustNo           NUMBER,
  CustName         VARCHAR2(200),
  Address_obj      Address_objtyp,
  PhoneList_var    PhoneList_vartyp
);
/

CREATE TYPE LineItemList_ntabtyp AS TABLE OF LineItem_objtyp;
/

CREATE TYPE PurchaseOrder_objtyp AUTHID CURRENT_USER AS OBJECT (
  PONo                 NUMBER,
  Cust_ref             REF Customer_objtyp,
  OrderDate            DATE,
  LineItemList_ntab    LineItemList_ntabtyp
  );
/

CREATE TABLE STOCKITEM_OBJTAB OF STOCKITEM_OBJTYP (STOCKNO PRIMARY KEY);

CREATE TABLE CUSTOMER_OBJTAB OF CUSTOMER_OBJTYP (CUSTNO PRIMARY KEY);

CREATE TABLE PURCHASEORDER_OBJTAB OF PURCHASEORDER_OBJTYP (
    PRIMARY KEY (PONO),
    FOREIGN KEY (CUST_REF)  REFERENCES CUSTOMER_OBJTAB)
    NESTED TABLE LINEITEMLIST_NTAB STORE AS POLINE_NTAB (
    (PRIMARY KEY (NESTED_TABLE_ID, LINEITEMNO)));
/

INSERT INTO STOCKITEM_OBJTAB VALUES(1,Pen,)