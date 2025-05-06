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

INSERT INTO STOCKITEM_OBJTAB VALUES(1,'Pen',5);
INSERT INTO STOCKITEM_OBJTAB VALUES(2,'Pencil',7);
INSERT INTO STOCKITEM_OBJTAB VALUES(3,'Book',20);
INSERT INTO STOCKITEM_OBJTAB VALUES(4,'Ruler',10);
INSERT INTO STOCKITEM_OBJTAB VALUES(5,'Scale',18);

INSERT INTO CUSTOMER_OBJTAB VALUES (1,'Anika Rahman',ADDRESS_OBJTYP('12 Green Road','Dhanmondi','Dhaka','Dhaka'),PHONELIST_VARTYP('01711122334','01812345678'));
INSERT INTO CUSTOMER_OBJTAB VALUES (2,'Tariq Hossain',ADDRESS_OBJTYP('45 North Lane','Khulshi','Chattogram','Chattogram'),PHONELIST_VARTYP('01610000000','01700000000',''));

INSERT INTO CUSTOMER_OBJTAB VALUES (3,'Nusrat Jahan',ADDRESS_OBJTYP('88 Main Street','Savar','Dhaka','Dhaka'),PHONELIST_VARTYP('01822223344'));


INSERT INTO PURCHASEORDER_OBJTAB 
    SELECT 2, REF(C), 
    SYSDATE, 
    LINEITEMLIST_NTABTYP()
    FROM CUSTOMER_OBJTAB C
    WHERE C.CUSTNO = 2 ;
    
INSERT INTO PurchaseOrder_objtab
  SELECT  1, REF(C),
          SYSDATE,
          LineItemList_ntabtyp()
   FROM   Customer_objtab C
   WHERE  C.CustNo = 1 ;
INSERT INTO TABLE (
  SELECT  P.LineItemList_ntab
   FROM   PurchaseOrder_objtab P
   WHERE  P.PONo = 1
  )
  SELECT  1, REF(S), 12
   FROM   STOCKITEM_OBJTAB S
   WHERE  S.StockNo = 1 ;