## Part – 1 (ORDBMS)
Marks: 10
# Title: ORDBMS Database Design, Implementation and Query

### Objective:
The objectives of this assignment are:
to acquire knowledge about database design for Object-Relational DBMS (ORDBMS) model,
to implement a database in an ORDBMS like Oracle,
to insert sample data and run different queries on the database.
### Problem definition
The following attributes describe a student in University Student Information System database:

1. ID: Unique identifier for each entry.
2. Name: Type
    1. First Name
    2. Middle Name
    3. Last Name
3. Date of Birth
4. CGPA
5. Total Credits
6. Department
7. Address: Type
    1. Present Address:
        1. House Number
        2. Street
        3. Thana
        4. District
    2. Permanent Address:
        1. House Number
        2. Street
        3. Thana
        4. District

3. Mandatory Fields (Multi-valued):
    1. Phone Number(s) Varray
    2. Email Address(es) Varray
4. Optional Fields (Multi-valued):
    1. Research Interests: Fields of research interest. Varray
    2. Programming Knowledge: Specify languages known (e.g., C, Java). Varray
    3. Educational Qualifications:Structure a record to store academic qualifications (Nested Type)
        1. degree
        2. institution
        3. year of graduation.
5. Family tree
    1. Father 
        1. father of father
        2. Mother of father
    2. Mother 
        1. father of Mother
        2. Mother of Mother
6. Player (game, score) Nested 
7. Organizer (club name, start date, end date). Nested


## Tasks:
Using oracle OORDBMS features and documentations, perform the following:
1. Define the custom types 
2. Create tables using the types
3. Insert sample data
4. Write queries on the data

## Solution

### Defining custom types in Oracle 

To define a custom type you have to use the CREATE TYPE keyword Followed by the name of the custom type and then AS OBJECT. After that you can add all the attributes with the respective data types.

CREATE TYPE Name_Type AS OBJECT (
    First_Name    VARCHAR2(50),
    Middle_Name   VARCHAR2(50),
    Last_Name     VARCHAR2(50)
);

Here we have created a custom data type called name type with three attributes. 
