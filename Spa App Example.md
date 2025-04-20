# Defining Types

Object types are user-defined data types that make it possible to model real-world entities such as staff. It is metadata for user-defined data types stored in a schema that is available to SQL, PL/SQL, Java, and other APIs.

We can create an object type with the `CREATE TYPE` statement. The following statement creates a `Staff` object:

```sql
CREATE TYPE STAFF AS OBJECT (
    TherapistID INT, 
    TherapistFirstName VARCHAR2(15),
    TherapistLastName VARCHAR2(15),
    StartDate DATE,
    StaffLevel VARCHAR2(50),
    StaffSpeed INT,
    SpaMgr CHAR
);
```

Instances of the `Staff` object type represent the staff. The `Staff` object has seven different attributes with the primary key of `TherapistID`.

---

# Defining VARRAY

VARRAY is an ordered set of data elements, which are of the same datatype. The following example creates `phonelist_vartyp`, a VARRAY of `VARCHAR2(20)`, with up to 10 phone numbers:

```sql
CREATE TYPE PHONELIST_VARTYP AS VARRAY(10) OF VARCHAR2(20);
```

### Implementation of VARRAY

```sql
CREATE TYPE CUSTOMER AS OBJECT (
    CustomerID INT,
    FName VARCHAR2(50),
    LName VARCHAR2(50),
    Gender VARCHAR2(15),
    AcceptPromos CHAR,
    AcceptReminders CHAR,
    DateOfBirth DATE,
    PhoneNo PHONELIST_VARTYP, -- phoneNo data type is VARRAY
    PreferredStaffMember PREFSTAFFMEM_NTABTYP
);
```

**Note:** VARRAY and nested tables can contain a list of phone numbers. In this case, we use VARRAY because:
- The order of numbers is important in phone numbers, whereas nested tables are unordered.
- VARRAY forces us to define the maximum number of elements in advance, whereas nested tables do not have an upper limitation.
- We cannot query VARRAY, whereas we can query nested tables.

---

# Defining Nested Tables

Nested tables are unordered sets of user-defined data types. To create a nested table, we first create an object type and then create a nested table of that type. The following statements demonstrate this:

### Creating Product Object Type

```sql
CREATE TYPE PRODUCT AS OBJECT (
    ProductID INT,
    ProductDesc VARCHAR2(15),
    ProductCategoryID REF PRODUCTCATEGORY,
    ProductCost FLOAT,
    ProductSize INTEGER
);
```

### Creating Nested Table of Product Type

```sql
CREATE TYPE PRODUCT_NTABTYPE AS TABLE OF PRODUCT;
```

### Using Nested Table in Object Type

```sql
CREATE TYPE LINEITEM AS OBJECT (
    LineItemID INT,
    Products PRODUCT_NTABTYPE,
    ServiceRef REF SERVICE,
    Quantity INTEGER,
    Total FLOAT
);
```

- **Line 1:** Defines the `LineItem` object.
- **Line 3:** Defines the `Products` attribute as `PRODUCT_NTABTYPE`. It has a single column, and its type is an object type. We can store as many objects as needed.
- **Line 4:** References the `Service` object type pointer.

An instance of `PRODUCT_NTABTYPE` nested table contains objects of type `Product` in each row. A nested table is a better choice for multivalued items than a VARRAY of `Product`.

**Note:** Benefits of using nested tables over VARRAY:
- We can query content.
- If the application needs to index, it can be done with nested tables.
- There is no upper bound on the number of items.
- Nested tables contain UDT (user-defined data types).

---

# Defining REFs

`REF` is a built-in datatype in Oracle. It is a logical pointer to a row object. It is used for associations among objects, enabling many-to-many relationships and reducing the need for foreign keys. It provides a simple mechanism for navigating between objects.

### Example

```sql
CREATE TYPE APPOINTMENT AS OBJECT (
    ApptID INT,
    AppDate DATE,
    CustomerID REF CUSTOMER,
    TherapistID REF STAFF,
    ServiceID REF SERVICE,
    Notes VARCHAR2(250),
    UnpaidTime INT
);
```

In this example:
- `CustomerID` references the `Customer` object type.
- `CustomerID` holds the pointer to the `Customer` object.

### Creating Physical Tables

```sql
CREATE TABLE APPOINTMENT_OBJTAB OF APPOINTMENT (
    PRIMARY KEY (ApptID),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER_OBJTAB,
    FOREIGN KEY (TherapistID) REFERENCES STAFF_OBJTAB,
    FOREIGN KEY (ServiceID) REFERENCES SERVICE_OBJTAB
);
```

Alternatively:

```sql
CREATE TABLE APPOINTMENT_OBJTAB OF APPOINTMENT (
    PRIMARY KEY (ApptID),
    CustomerID REF CUSTOMER SCOPE IS CUSTOMER_OBJTAB,
    TherapistID REF STAFF SCOPE IS STAFF_OBJTAB,
    ServiceID REF SERVICE SCOPE IS SERVICE_OBJTAB
);
```

Both methods create `REF` objects for `CustomerID`, `TherapistID`, and `ServiceID` of their respective object tables.

---

# Inserting Values into `APPOINTMENT_OBJTAB`

```sql
INSERT INTO APPOINTMENT_OBJTAB VALUES(
    1, SYSDATE,
    (SELECT REF(C) FROM CUSTOMER_OBJTAB C WHERE C.CustomerID = 1),
    (SELECT REF(T) FROM STAFF_OBJTAB T WHERE T.THERAPISTID = 1),
    (SELECT REF(S) FROM SERVICE_OBJTAB S WHERE S.SERVICEID = 1),
    'THIS IS SPECIAL NOTES FOR APPOINTMENT', 2
);
```

The preceding statement constructs an `APPOINTMENT_OBJTAB` object with the following attributes:
- `ApptID`: 1
- `AppDate`: `SYSDATE`
- `CustomerID`: REF to customer 1
- `TherapistID`: REF to staff 1
- `ServiceID`: REF to service 1
- `Notes`: "THIS IS SPECIAL NOTES FOR APPOINTMENT"
- `UnpaidTime`: 2

---

# Querying `APPOINTMENT_OBJTAB`

Retrieve data from `APPOINTMENT_OBJTAB` made by customer 1:

```sql
SELECT A.APPTID, A.CUSTOMERID, A.APPDATE, A.THERAPISTID, A.SERVICEID 
FROM APPOINTMENT_OBJTAB A 
WHERE A.CUSTOMERID.CustomerID = 1;
```

Retrieve data from `APPOINTMENT_OBJTAB` made for staff 2:

```sql
SELECT A.APPTID, A.CUSTOMERID, A.APPDATE, A.THERAPISTID, A.SERVICEID 
FROM APPOINTMENT_OBJTAB A 
WHERE A.THERAPISTID.THERAPISTID = 2;
```

---

# Defining Methods

Methods are functions or procedures declared in object type definitions to implement behavior for that object type. There are three types of methods:
1. **Member Methods**
2. **Static Methods**
3. **Constructor Methods**

### Member Methods

Member methods provide access to an object instance’s data. They can be declared using `MAP` or `ORDER` keywords.

#### Example: `MAP` Method

```sql
CREATE TYPE INVOICE AS OBJECT (
    InvoiceNo INT,
    CustomerId REF CUSTOMER,
    LineItem LINEITEM_NTAB,
    InvoiceDate DATE,
    Total FLOAT,
    MAP MEMBER FUNCTION CALC_TOTAL RETURN FLOAT
);
```

#### Implementing `MAP` Method

```sql
CREATE TYPE BODY INVOICE IS 
    MAP MEMBER FUNCTION CALC_TOTAL RETURN FLOAT IS 
        i INTEGER;
        PRODUCTVAL PRODUCT;
        SERVICEVAL SERVICE;
        TOTAL FLOAT := 0;
    BEGIN 
        FOR i IN 1..SELF.LINEITEM_NTAB.COUNT LOOP
            UTL_REF.SELECT_OBJECT(LINEITEM_NTAB(I).Products, PRODUCTVAL);
            TOTAL := TOTAL + SELF.LINEITEM_NTAB(I).Quantity * PRODUCTVAL.ProductCost;
            UTL_REF.SELECT_OBJECT(LINEITEM_NTAB(I).ServiceRef, SERVICEVAL);
            TOTAL := TOTAL + SELF.LINEITEM_NTAB(I).SERVICEVAL.ServiceCost;
        END LOOP;
        RETURN TOTAL;
    END CALC_TOTAL;
END;
```

---

# Inheritance

Inheritance allows a child object type to inherit attributes and methods from a parent object type.

### Example

```sql
CREATE TYPE PRODUCTCATEGORY AS OBJECT (
    ProductCategoryId INTEGER,
    ProductCatDesc VARCHAR2(250)
) NOT FINAL;

CREATE TYPE PRODUCT_INHTYP UNDER PRODUCTCATEGORY (
    ProductID INT,
    ProductDesc VARCHAR2(15),
    ProductCost INT,
    ProductSize INTEGER
);
```

Here:
- `PRODUCTCATEGORY` is the supertype.
- `PRODUCT_INHTYP` is the subtype inheriting attributes from the supertype.

---

# Method Overriding and Overloading

### Overriding

Allows a subtype to implement a method specifically, which is already defined in the supertype.

### Overloading

Allows creating multiple methods in a subtype with the same name but different parameters.

#### Example

```sql
CREATE OR REPLACE TYPE STUDENTS AS OBJECT (
    Student_id NUMBER,
    FirstName VARCHAR2(20),
    LastName VARCHAR2(20),
    Address VARCHAR2(50),
    Department VARCHAR2(20),
    CONSTRUCTOR FUNCTION STUDENTS (Student_id NUMBER, FirstName VARCHAR2, LastName VARCHAR2, Address VARCHAR2, Department VARCHAR2)
    RETURN SELF AS RESULT,
    CONSTRUCTOR FUNCTION STUDENTS (Student_id NUMBER, FirstName VARCHAR2, LastName VARCHAR2, Address VARCHAR2)
    RETURN SELF AS RESULT,
    MEMBER PROCEDURE PRINT_DETAILS,
    MEMBER FUNCTION GET_ATTR RETURN VARCHAR2
);
```

---

# Views

Views are representations of SQL statements stored in memory for reuse.

### Example: Creating a View

```sql
CREATE OR REPLACE VIEW CUST_APPT AS
SELECT A.APPTID, A.CUSTOMERID, A.APPDATE, A.THERAPISTID, A.SERVICEID 
FROM APPOINTMENT_OBJTAB A 
WHERE A.CUSTOMERID.CustomerID = 1;
```

This view retrieves all appointments made by customer 1.

