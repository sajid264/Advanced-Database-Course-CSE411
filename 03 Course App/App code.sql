CREATE OR REPLACE TYPE address_objtyp AS OBJECT (
	house VARCHAR2(64),
	THANA VARCHAR2(64),
	DISTRICT VARCHAR2(64)
	DIVISION VARCHAR2(64)
);
/
CREATE TYPE PhoneList_vartyp AS VARRAY(10) OF VARCHAR2(20);
/

CREATE TYPE Customer_objtyp AS OBJECT (
  CustNo           NUMBER,
  CustName         VARCHAR2(200),
  Address_obj      Address_objtyp,
  PhoneList_var    PhoneList_vartyp,
);
/

CREATE TYPE StockItem AS OBJECT (
    stockNo     NUMBER,
    stockName   VARCHAR2(100),
    price       NUMBER(10, 2)
);
/


-- Create LineItem object type with REF to StockItem
CREATE TYPE LineItem AS OBJECT (
    lineItemNo  NUMBER,
    stockRef    REF StockItem,
    quantity    NUMBER(5)
);
/
