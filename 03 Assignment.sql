-- Create custom types

-- Address Type
CREATE TYPE Address_Type AS OBJECT (
    House_No     VARCHAR2(10),
    Street       VARCHAR2(100),
    Thana        VARCHAR2(50),
    District     VARCHAR2(50)
);

-- Name Type
CREATE TYPE Name_Type AS OBJECT (
    First_Name    VARCHAR2(50),
    Middle_Name   VARCHAR2(50),
    Last_Name     VARCHAR2(50)
);

-- Educational Qualification Type
CREATE TYPE Education_Type AS OBJECT (
    Degree       VARCHAR2(100),
    Institution  VARCHAR2(100),
    Grad_Year    NUMBER(4)
);

-- Research Interests VARRAY
CREATE TYPE Research_Interests_Varray AS VARRAY(10) OF VARCHAR2(100);

-- Programming Knowledge VARRAY
CREATE TYPE Programming_Knowledge_Varray AS VARRAY(10) OF VARCHAR2(50);

-- Phone Numbers VARRAY
CREATE TYPE Phone_Numbers_Varray AS VARRAY(5) OF VARCHAR2(15);

-- Email Addresses VARRAY
CREATE TYPE Email_Addresses_Varray AS VARRAY(5) OF VARCHAR2(100);

-- Educational Qualifications NESTED TABLE
CREATE TYPE Education_List AS TABLE OF Education_Type;

-- Player Type
CREATE TYPE Player_Type AS OBJECT (
    Game    VARCHAR2(50),
    Score   NUMBER(5, 2)
);

-- Organizer Type
CREATE TYPE Organizer_Type AS OBJECT (
    Club_Name  VARCHAR2(100),
    Start_Date DATE,
    End_Date   DATE
);

-- Family Tree Type
CREATE TYPE Family_Type AS OBJECT (
    Father_of_Father VARCHAR2(50),
    Mother_of_Father VARCHAR2(50),
    Father_of_Mother VARCHAR2(50),
    Mother_of_Mother VARCHAR2(50)
);

-- Family Info Type
CREATE TYPE Family_Info_Type AS OBJECT (
    Father  Family_Type,
    Mother  Family_Type
);

-- Now create the main table for students

CREATE TABLE Student (
    ID                   NUMBER PRIMARY KEY,
    Name                 Name_Type,
    Date_Of_Birth        DATE,
    CGPA                 NUMBER(4, 2),
    Total_Credits        NUMBER(4),
    Department           VARCHAR2(100),
    
    Present_Address      Address_Type,
    Permanent_Address    Address_Type,

    -- Multi-valued Attributes
    Phone_Numbers        Phone_Numbers_Varray,
    Email_Addresses      Email_Addresses_Varray,

    -- Optional Multi-valued Attributes
    Research_Interests   Research_Interests_Varray,
    Programming_Knowledge Programming_Knowledge_Varray,
    Educational_Qualifications Education_List,

    -- Family Tree
    Family_Tree          Family_Info_Type,

    -- Nested Attributes for Activities
    Player_Info          Player_Type,
    Organizer_Info       Organizer_Type
) NESTED TABLE Educational_Qualifications STORE AS Edu_Qualifications_Tab;



-- Student 1
INSERT INTO Student VALUES (
    1, 
    Name_Type('John', 'A.', 'Doe'), 
    TO_DATE('15-FEB-2000','DD-MON-YYYY'), 
    3.5, 
    120, 
    'Computer Science', 
    Address_Type('123','Main St','Thana-1','District-1'), 
    Address_Type('456','Park Ave','Thana-2','District-2'), 
    Phone_Numbers_Varray('1234567890','0987654321'), 
    Email_Addresses_Varray('john.doe@example.com','john.alt@example.com'), 
    Research_Interests_Varray('Artificial Intelligence','Data Science'), 
    Programming_Knowledge_Varray('C','Java','Python'), 
    Education_List(
       Education_Type('BSc in CS','University A',2022),
       Education_Type('MSc in CS','University B',2024)
    ),
    Family_Info_Type(
       Family_Type('Grandfather1','Grandmother1',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather2','Grandmother2')
    ),
    Player_Type('Basketball',85), 
    Organizer_Type('Tech Club',TO_DATE('01-JAN-2023','DD-MON-YYYY'),TO_DATE('31-DEC-2023','DD-MON-YYYY'))
);

-- Student 2
INSERT INTO Student VALUES (
    2, 
    Name_Type('Emily', 'B.', 'Smith'), 
    TO_DATE('10-MAR-1999','DD-MON-YYYY'), 
    3.8, 
    110, 
    'Mechanical Engineering', 
    Address_Type('789','Oak St','Thana-3','District-3'), 
    Address_Type('101','Pine St','Thana-4','District-4'), 
    Phone_Numbers_Varray('2223334444','5556667777'), 
    Email_Addresses_Varray('emily.smith@example.com'), 
    Research_Interests_Varray('Robotics','3D Printing'), 
    Programming_Knowledge_Varray('MATLAB','Python'), 
    Education_List(
       Education_Type('BSc in Mechanical Eng','University C',2021)
    ),
    Family_Info_Type(
       Family_Type('Grandfather3','Grandmother3',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather4','Grandmother4')
    ),
    Player_Type('Tennis',72), 
    Organizer_Type('Engineering Club',TO_DATE('15-JUL-2022','DD-MON-YYYY'),TO_DATE('14-JUL-2023','DD-MON-YYYY'))
);

-- Student 3
INSERT INTO Student VALUES (
    3, 
    Name_Type('Michael', 'C.', 'Brown'), 
    TO_DATE('22-APR-2001','DD-MON-YYYY'), 
    3.9, 
    115, 
    'Electrical Engineering', 
    Address_Type('22','Green St','Thana-5','District-5'), 
    Address_Type('33','Blue St','Thana-6','District-6'), 
    Phone_Numbers_Varray('8889990000'), 
    Email_Addresses_Varray('michael.brown@example.com'), 
    Research_Interests_Varray('Renewable Energy'), 
    Programming_Knowledge_Varray('C++','JavaScript'), 
    Education_List(
       Education_Type('BSc in EE','University D',2023)
    ),
    Family_Info_Type(
       Family_Type('Grandfather5','Grandmother5',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather6','Grandmother6')
    ),
    Player_Type('Football',90), 
    Organizer_Type('Energy Club',TO_DATE('01-MAR-2023','DD-MON-YYYY'),TO_DATE('28-FEB-2024','DD-MON-YYYY'))
);

-- Student 4
INSERT INTO Student VALUES (
    4, 
    Name_Type('Jessica', 'D.', 'Johnson'), 
    TO_DATE('07-MAY-1998','DD-MON-YYYY'), 
    3.6, 
    105, 
    'Civil Engineering', 
    Address_Type('77','Birch St','Thana-7','District-7'), 
    Address_Type('88','Cedar St','Thana-8','District-8'), 
    Phone_Numbers_Varray('7778889999'), 
    Email_Addresses_Varray('jessica.johnson@example.com'), 
    Research_Interests_Varray('Sustainable Architecture'), 
    Programming_Knowledge_Varray('AutoCAD','Revit'), 
    Education_List(
       Education_Type('BSc in Civil Eng','University E',2020)
    ),
    Family_Info_Type(
       Family_Type('Grandfather7','Grandmother7',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather8','Grandmother8')
    ),
    Player_Type('Volleyball',65), 
    Organizer_Type('Architecture Club',TO_DATE('01-SEP-2022','DD-MON-YYYY'),TO_DATE('31-AUG-2023','DD-MON-YYYY'))
);

-- Student 5
INSERT INTO Student VALUES (
    5, 
    Name_Type('David', 'E.', 'Wilson'), 
    TO_DATE('19-JUN-2002','DD-MON-YYYY'), 
    3.4, 
    125, 
    'Software Engineering', 
    Address_Type('99','Maple St','Thana-9','District-9'), 
    Address_Type('100','Willow St','Thana-10','District-10'), 
    Phone_Numbers_Varray('3334445555'), 
    Email_Addresses_Varray('david.wilson@example.com'), 
    Research_Interests_Varray('Cloud Computing'), 
    Programming_Knowledge_Varray('Java','Python','C#'), 
    Education_List(
       Education_Type('BSc in Soft Eng','University F',2024)
    ),
    Family_Info_Type(
       Family_Type('Grandfather9','Grandmother9',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather10','Grandmother10')
    ),
    Player_Type('Chess',78), 
    Organizer_Type('Tech Society',TO_DATE('01-JAN-2024','DD-MON-YYYY'),TO_DATE('31-DEC-2024','DD-MON-YYYY'))
);

-- Student 6
INSERT INTO Student VALUES (
    6, 
    Name_Type('Sarah', 'F.', 'Miller'), 
    TO_DATE('05-JUL-2000','DD-MON-YYYY'), 
    3.7, 
    118, 
    'Information Technology', 
    Address_Type('10','Sunset Blvd','Thana-11','District-11'), 
    Address_Type('20','Dawn Ave','Thana-12','District-12'), 
    Phone_Numbers_Varray('4445556666','7778889999'), 
    Email_Addresses_Varray('sarah.miller@example.com'), 
    Research_Interests_Varray('Cyber Security','Network Architecture'), 
    Programming_Knowledge_Varray('Python','Ruby'), 
    Education_List(
       Education_Type('BSc in IT','University G',2022)
    ),
    Family_Info_Type(
       Family_Type('Grandfather11','Grandmother11',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather12','Grandmother12')
    ),
    Player_Type('Soccer',88), 
    Organizer_Type('IT Club',TO_DATE('01-FEB-2023','DD-MON-YYYY'),TO_DATE('31-JAN-2024','DD-MON-YYYY'))
);

-- Student 7
INSERT INTO Student VALUES (
    7, 
    Name_Type('Robert', 'G.', 'Davis'), 
    TO_DATE('12-AUG-1997','DD-MON-YYYY'), 
    3.2, 
    100, 
    'Chemistry', 
    Address_Type('55','Lakeview Rd','Thana-13','District-13'), 
    Address_Type('66','Riverside Rd','Thana-14','District-14'), 
    Phone_Numbers_Varray('1112223333'), 
    Email_Addresses_Varray('robert.davis@example.com','robert.alt@example.com'), 
    Research_Interests_Varray('Organic Chemistry'), 
    Programming_Knowledge_Varray('None'), 
    Education_List(
       Education_Type('BSc in Chemistry','University H',2019)
    ),
    Family_Info_Type(
       Family_Type('Grandfather13','Grandmother13',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather14','Grandmother14')
    ),
    Player_Type('Baseball',70), 
    Organizer_Type('Chemistry Club',TO_DATE('01-MAR-2022','DD-MON-YYYY'),TO_DATE('28-FEB-2023','DD-MON-YYYY'))
);

-- Student 8
INSERT INTO Student VALUES (
    8, 
    Name_Type('Laura', 'H.', 'Martinez'), 
    TO_DATE('30-SEP-2001','DD-MON-YYYY'), 
    3.85, 
    122, 
    'Biology', 
    Address_Type('101','Forest Dr','Thana-15','District-15'), 
    Address_Type('202','Meadow Ln','Thana-16','District-16'), 
    Phone_Numbers_Varray('9998887777'), 
    Email_Addresses_Varray('laura.martinez@example.com'), 
    Research_Interests_Varray('Genetics','Ecology'), 
    Programming_Knowledge_Varray('R','Python'), 
    Education_List(
       Education_Type('BSc in Biology','University I',2020)
    ),
    Family_Info_Type(
       Family_Type('Grandfather15','Grandmother15',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather16','Grandmother16')
    ),
    Player_Type('Running',92), 
    Organizer_Type('Biology Club',TO_DATE('01-APR-2023','DD-MON-YYYY'),TO_DATE('31-MAR-2024','DD-MON-YYYY'))
);

-- Student 9
INSERT INTO Student VALUES (
    9, 
    Name_Type('Daniel', 'I.', 'Garcia'), 
    TO_DATE('18-OCT-1998','DD-MON-YYYY'), 
    3.45, 
    108, 
    'Mathematics', 
    Address_Type('303','Hill St','Thana-17','District-17'), 
    Address_Type('404','Valley St','Thana-18','District-18'), 
    Phone_Numbers_Varray('5554443333'), 
    Email_Addresses_Varray('daniel.garcia@example.com'), 
    Research_Interests_Varray('Algebra','Statistics'), 
    Programming_Knowledge_Varray('MATLAB','Fortran'), 
    Education_List(
       Education_Type('BSc in Math','University J',2018)
    ),
    Family_Info_Type(
       Family_Type('Grandfather17','Grandmother17',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather18','Grandmother18')
    ),
    Player_Type('Swimming',80), 
    Organizer_Type('Math Club',TO_DATE('01-MAY-2023','DD-MON-YYYY'),TO_DATE('30-APR-2024','DD-MON-YYYY'))
);

-- Student 10
INSERT INTO Student VALUES (
    10, 
    Name_Type('Karen', 'J.', 'Lopez'), 
    TO_DATE('25-NOV-2000','DD-MON-YYYY'), 
    3.55, 
    112, 
    'Physics', 
    Address_Type('707','Quantum Rd','Thana-19','District-19'), 
    Address_Type('808','Relativity Ave','Thana-20','District-20'), 
    Phone_Numbers_Varray('6667778888'), 
    Email_Addresses_Varray('karen.lopez@example.com'), 
    Research_Interests_Varray('Astrophysics','Quantum Mechanics'), 
    Programming_Knowledge_Varray('Python','C++'), 
    Education_List(
       Education_Type('BSc in Physics','University K',2021)
    ),
    Family_Info_Type(
       Family_Type('Grandfather19','Grandmother19',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather20','Grandmother20')
    ),
    Player_Type('Badminton',75), 
    Organizer_Type('Physics Society',TO_DATE('01-JUN-2023','DD-MON-YYYY'),TO_DATE('31-MAY-2024','DD-MON-YYYY'))
);

-- Student 11
INSERT INTO Student VALUES (
    11, 
    Name_Type('Steven', 'K.', 'Anderson'), 
    TO_DATE('03-DEC-2001','DD-MON-YYYY'), 
    3.65, 
    117, 
    'Computer Science', 
    Address_Type('909','Innovation Dr','Thana-21','District-21'), 
    Address_Type('1010','Tech Park','Thana-22','District-22'), 
    Phone_Numbers_Varray('7776665555'), 
    Email_Addresses_Varray('steven.anderson@example.com','steven.alt@example.com'), 
    Research_Interests_Varray('Machine Learning'), 
    Programming_Knowledge_Varray('Java','Python','Go'), 
    Education_List(
       Education_Type('BSc in CS','University L',2023)
    ),
    Family_Info_Type(
       Family_Type('Grandfather21','Grandmother21',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather22','Grandmother22')
    ),
    Player_Type('Cricket',82), 
    Organizer_Type('CS Club',TO_DATE('01-JUL-2023','DD-MON-YYYY'),TO_DATE('30-JUN-2024','DD-MON-YYYY'))
);

-- Student 12
INSERT INTO Student VALUES (
    12, 
    Name_Type('Olivia', 'L.', 'Thomas'), 
    TO_DATE('12-JAN-2002','DD-MON-YYYY'), 
    3.75, 
    119, 
    'Information Systems', 
    Address_Type('111','Data St','Thana-23','District-23'), 
    Address_Type('222','Logic Ln','Thana-24','District-24'), 
    Phone_Numbers_Varray('8887776666'), 
    Email_Addresses_Varray('olivia.thomas@example.com'), 
    Research_Interests_Varray('Big Data'), 
    Programming_Knowledge_Varray('SQL','Python'), 
    Education_List(
       Education_Type('BSc in IS','University M',2024)
    ),
    Family_Info_Type(
       Family_Type('Grandfather23','Grandmother23',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather24','Grandmother24')
    ),
    Player_Type('Hockey',79), 
    Organizer_Type('IS Society',TO_DATE('01-AUG-2023','DD-MON-YYYY'),TO_DATE('31-JUL-2024','DD-MON-YYYY'))
);

-- Student 13
INSERT INTO Student VALUES (
    13, 
    Name_Type('Brian', 'M.', 'Jackson'), 
    TO_DATE('08-FEB-1999','DD-MON-YYYY'), 
    3.3, 
    107, 
    'Economics', 
    Address_Type('333','Market St','Thana-25','District-25'), 
    Address_Type('444','Commerce Ave','Thana-26','District-26'), 
    Phone_Numbers_Varray('5556667777'), 
    Email_Addresses_Varray('brian.jackson@example.com'), 
    Research_Interests_Varray('Behavioral Economics'), 
    Programming_Knowledge_Varray('R'), 
    Education_List(
       Education_Type('BSc in Economics','University N',2020)
    ),
    Family_Info_Type(
       Family_Type('Grandfather25','Grandmother25',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather26','Grandmother26')
    ),
    Player_Type('Table Tennis',68), 
    Organizer_Type('Economics Forum',TO_DATE('01-SEP-2023','DD-MON-YYYY'),TO_DATE('31-AUG-2024','DD-MON-YYYY'))
);

-- Student 14
INSERT INTO Student VALUES (
    14, 
    Name_Type('Megan', 'N.', 'White'), 
    TO_DATE('21-MAR-2000','DD-MON-YYYY'), 
    3.85, 
    123, 
    'Psychology', 
    Address_Type('555','Mind St','Thana-27','District-27'), 
    Address_Type('666','Soul Ave','Thana-28','District-28'), 
    Phone_Numbers_Varray('2221113333'), 
    Email_Addresses_Varray('megan.white@example.com','megan.alt@example.com'), 
    Research_Interests_Varray('Cognitive Science'), 
    Programming_Knowledge_Varray('Python'), 
    Education_List(
       Education_Type('BSc in Psychology','University O',2022)
    ),
    Family_Info_Type(
       Family_Type('Grandfather27','Grandmother27',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather28','Grandmother28')
    ),
    Player_Type('Running',95), 
    Organizer_Type('Psychology Club',TO_DATE('01-OCT-2023','DD-MON-YYYY'),TO_DATE('30-SEP-2024','DD-MON-YYYY'))
);

-- Student 15
INSERT INTO Student VALUES (
    15, 
    Name_Type('Kevin', 'O.', 'Harris'), 
    TO_DATE('14-APR-2001','DD-MON-YYYY'), 
    3.2, 
    110, 
    'History', 
    Address_Type('777','Heritage Rd','Thana-29','District-29'), 
    Address_Type('888','Antique Ln','Thana-30','District-30'), 
    Phone_Numbers_Varray('4443332222'), 
    Email_Addresses_Varray('kevin.harris@example.com'), 
    Research_Interests_Varray('Ancient Civilizations'), 
    Programming_Knowledge_Varray('None'), 
    Education_List(
       Education_Type('BA in History','University P',2019)
    ),
    Family_Info_Type(
       Family_Type('Grandfather29','Grandmother29',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather30','Grandmother30')
    ),
    Player_Type('Soccer',77), 
    Organizer_Type('History Society',TO_DATE('01-NOV-2023','DD-MON-YYYY'),TO_DATE('31-OCT-2024','DD-MON-YYYY'))
);

-- Student 16
INSERT INTO Student VALUES (
    16, 
    Name_Type('Sophia', 'P.', 'Clark'), 
    TO_DATE('02-MAY-2002','DD-MON-YYYY'), 
    3.9, 
    130, 
    'Computer Science', 
    Address_Type('909','Innovation Blvd','Thana-31','District-31'), 
    Address_Type('101','Tech Ln','Thana-32','District-32'), 
    Phone_Numbers_Varray('1231231234'), 
    Email_Addresses_Varray('sophia.clark@example.com'), 
    Research_Interests_Varray('Data Mining','Cloud Computing'), 
    Programming_Knowledge_Varray('Java','Python','Scala'), 
    Education_List(
       Education_Type('BSc in CS','University Q',2023)
    ),
    Family_Info_Type(
       Family_Type('Grandfather31','Grandmother31',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather32','Grandmother32')
    ),
    Player_Type('Volleyball',82), 
    Organizer_Type('CS Society',TO_DATE('15-JAN-2023','DD-MON-YYYY'),TO_DATE('14-JAN-2024','DD-MON-YYYY'))
);

-- Student 17
INSERT INTO Student VALUES (
    17, 
    Name_Type('Mark', 'Q.', 'Roberts'), 
    TO_DATE('19-JUN-2000','DD-MON-YYYY'), 
    3.4, 
    112, 
    'Economics', 
    Address_Type('202','Finance St','Thana-33','District-33'), 
    Address_Type('303','Market Ave','Thana-34','District-34'), 
    Phone_Numbers_Varray('9876543210'), 
    Email_Addresses_Varray('mark.roberts@example.com'), 
    Research_Interests_Varray('Microeconomics'), 
    Programming_Knowledge_Varray('R'), 
    Education_List(
       Education_Type('BSc in Economics','University R',2021)
    ),
    Family_Info_Type(
       Family_Type('Grandfather33','Grandmother33',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather34','Grandmother34')
    ),
    Player_Type('Cricket',80), 
    Organizer_Type('Economics Club',TO_DATE('01-FEB-2023','DD-MON-YYYY'),TO_DATE('31-JAN-2024','DD-MON-YYYY'))
);

-- Student 18
INSERT INTO Student VALUES (
    18, 
    Name_Type('Amy', 'R.', 'Lewis'), 
    TO_DATE('27-JUL-1999','DD-MON-YYYY'), 
    3.6, 
    118, 
    'Business Administration', 
    Address_Type('404','Commerce St','Thana-35','District-35'), 
    Address_Type('505','Enterprise Ave','Thana-36','District-36'), 
    Phone_Numbers_Varray('3213214321'), 
    Email_Addresses_Varray('amy.lewis@example.com','amy.alt@example.com'), 
    Research_Interests_Varray('Marketing','Finance'), 
    Programming_Knowledge_Varray('Excel','SQL'), 
    Education_List(
       Education_Type('BBA','University S',2020)
    ),
    Family_Info_Type(
       Family_Type('Grandfather35','Grandmother35',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather36','Grandmother36')
    ),
    Player_Type('Tennis',74), 
    Organizer_Type('Business Club',TO_DATE('01-MAR-2023','DD-MON-YYYY'),TO_DATE('28-FEB-2024','DD-MON-YYYY'))
);

-- Student 19
INSERT INTO Student VALUES (
    19, 
    Name_Type('Eric', 'S.', 'Walker'), 
    TO_DATE('11-AUG-2001','DD-MON-YYYY'), 
    3.7, 
    120, 
    'Software Engineering', 
    Address_Type('606','Coder Ln','Thana-37','District-37'), 
    Address_Type('707','Debugger Dr','Thana-38','District-38'), 
    Phone_Numbers_Varray('5556667777'), 
    Email_Addresses_Varray('eric.walker@example.com'), 
    Research_Interests_Varray('Distributed Systems'), 
    Programming_Knowledge_Varray('Java','Python','C++'), 
    Education_List(
       Education_Type('BSc in Soft Eng','University T',2022)
    ),
    Family_Info_Type(
       Family_Type('Grandfather37','Grandmother37',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather38','Grandmother38')
    ),
    Player_Type('Chess',83), 
    Organizer_Type('Coding Club',TO_DATE('01-APR-2023','DD-MON-YYYY'),TO_DATE('31-MAR-2024','DD-MON-YYYY'))
);

-- Student 20
INSERT INTO Student VALUES (
    20, 
    Name_Type('Natalie', 'T.', 'Hall'), 
    TO_DATE('03-SEP-2000','DD-MON-YYYY'), 
    3.8, 
    125, 
    'Biotechnology', 
    Address_Type('808','Lab St','Thana-39','District-39'), 
    Address_Type('909','Research Rd','Thana-40','District-40'), 
    Phone_Numbers_Varray('4445556666'), 
    Email_Addresses_Varray('natalie.hall@example.com'), 
    Research_Interests_Varray('Genomics'), 
    Programming_Knowledge_Varray('Python','R'), 
    Education_List(
       Education_Type('BSc in Biotechnology','University U',2023)
    ),
    Family_Info_Type(
       Family_Type('Grandfather39','Grandmother39',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather40','Grandmother40')
    ),
    Player_Type('Swimming',89), 
    Organizer_Type('Biotech Club',TO_DATE('01-MAY-2023','DD-MON-YYYY'),TO_DATE('30-APR-2024','DD-MON-YYYY'))
);

-- Student 21
INSERT INTO Student VALUES (
    21, 
    Name_Type('Patrick', 'U.', 'Young'), 
    TO_DATE('29-OCT-1998','DD-MON-YYYY'), 
    3.25, 
    110, 
    'History', 
    Address_Type('121','Old Town Rd','Thana-41','District-41'), 
    Address_Type('131','Heritage Ln','Thana-42','District-42'), 
    Phone_Numbers_Varray('3332221111'), 
    Email_Addresses_Varray('patrick.young@example.com'), 
    Research_Interests_Varray('Medieval History'), 
    Programming_Knowledge_Varray('None'), 
    Education_List(
       Education_Type('BA in History','University V',2017)
    ),
    Family_Info_Type(
       Family_Type('Grandfather41','Grandmother41',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather42','Grandmother42')
    ),
    Player_Type('Basketball',76), 
    Organizer_Type('History Club',TO_DATE('01-JUN-2023','DD-MON-YYYY'),TO_DATE('31-MAY-2024','DD-MON-YYYY'))
);

-- Student 22
INSERT INTO Student VALUES (
    22, 
    Name_Type('Rebecca', 'V.', 'King'), 
    TO_DATE('17-NOV-2001','DD-MON-YYYY'), 
    3.85, 
    128, 
    'Computer Science', 
    Address_Type('141','Binary Blvd','Thana-43','District-43'), 
    Address_Type('151','Algorithm Ave','Thana-44','District-44'), 
    Phone_Numbers_Varray('7778889990'), 
    Email_Addresses_Varray('rebecca.king@example.com','rebecca.alt@example.com'), 
    Research_Interests_Varray('Data Analytics'), 
    Programming_Knowledge_Varray('Python','Java'), 
    Education_List(
       Education_Type('BSc in CS','University W',2024)
    ),
    Family_Info_Type(
       Family_Type('Grandfather43','Grandmother43',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather44','Grandmother44')
    ),
    Player_Type('Soccer',84), 
    Organizer_Type('Tech Society',TO_DATE('01-JAN-2024','DD-MON-YYYY'),TO_DATE('31-DEC-2024','DD-MON-YYYY'))
);

-- Student 23
INSERT INTO Student VALUES (
    23, 
    Name_Type('George', 'W.', 'Scott'), 
    TO_DATE('06-DEC-2000','DD-MON-YYYY'), 
    3.45, 
    115, 
    'Mathematics', 
    Address_Type('161','Number St','Thana-45','District-45'), 
    Address_Type('171','Equation Rd','Thana-46','District-46'), 
    Phone_Numbers_Varray('8889990001'), 
    Email_Addresses_Varray('george.scott@example.com'), 
    Research_Interests_Varray('Topology'), 
    Programming_Knowledge_Varray('MATLAB'), 
    Education_List(
       Education_Type('BSc in Math','University X',2022)
    ),
    Family_Info_Type(
       Family_Type('Grandfather45','Grandmother45',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather46','Grandmother46')
    ),
    Player_Type('Running',91), 
    Organizer_Type('Math Club',TO_DATE('01-FEB-2024','DD-MON-YYYY'),TO_DATE('31-JAN-2025','DD-MON-YYYY'))
);

-- Student 24
INSERT INTO Student VALUES (
    24, 
    Name_Type('Hannah', 'X.', 'Edwards'), 
    TO_DATE('23-JAN-2002','DD-MON-YYYY'), 
    3.95, 
    130, 
    'Biology', 
    Address_Type('181','Bio St','Thana-47','District-47'), 
    Address_Type('191','Gene Ave','Thana-48','District-48'), 
    Phone_Numbers_Varray('9990001111'), 
    Email_Addresses_Varray('hannah.edwards@example.com'), 
    Research_Interests_Varray('Microbiology','Genetics'), 
    Programming_Knowledge_Varray('Python','R'), 
    Education_List(
       Education_Type('BSc in Biology','University Y',2023)
    ),
    Family_Info_Type(
       Family_Type('Grandfather47','Grandmother47',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather48','Grandmother48')
    ),
    Player_Type('Tennis',87), 
    Organizer_Type('Biology Club',TO_DATE('01-MAR-2024','DD-MON-YYYY'),TO_DATE('29-FEB-2025','DD-MON-YYYY'))
);

-- Student 25
INSERT INTO Student VALUES (
    25, 
    Name_Type('Anthony', 'Y.', 'Baker'), 
    TO_DATE('09-FEB-2001','DD-MON-YYYY'), 
    3.55, 
    118, 
    'Electrical Engineering', 
    Address_Type('201','Circuit Rd','Thana-49','District-49'), 
    Address_Type('211','Voltage St','Thana-50','District-50'), 
    Phone_Numbers_Varray('2223334445'), 
    Email_Addresses_Varray('anthony.baker@example.com'), 
    Research_Interests_Varray('Power Systems'), 
    Programming_Knowledge_Varray('C','C++'), 
    Education_List(
       Education_Type('BSc in EE','University Z',2022)
    ),
    Family_Info_Type(
       Family_Type('Grandfather49','Grandmother49',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather50','Grandmother50')
    ),
    Player_Type('Football',79), 
    Organizer_Type('EE Club',TO_DATE('01-APR-2024','DD-MON-YYYY'),TO_DATE('31-MAR-2025','DD-MON-YYYY'))
);

-- Student 26
INSERT INTO Student VALUES (
    26, 
    Name_Type('Lily', 'Z.', 'Carter'), 
    TO_DATE('14-MAR-2002','DD-MON-YYYY'), 
    3.75, 
    124, 
    'Information Technology', 
    Address_Type('311','Digital Dr','Thana-51','District-51'), 
    Address_Type('321','Binary Blvd','Thana-52','District-52'), 
    Phone_Numbers_Varray('3334445556'), 
    Email_Addresses_Varray('lily.carter@example.com'), 
    Research_Interests_Varray('Networking'), 
    Programming_Knowledge_Varray('Python','JavaScript'), 
    Education_List(
       Education_Type('BSc in IT','University AA',2023)
    ),
    Family_Info_Type(
       Family_Type('Grandfather51','Grandmother51',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather52','Grandmother52')
    ),
    Player_Type('Volleyball',83), 
    Organizer_Type('IT Club',TO_DATE('01-MAY-2024','DD-MON-YYYY'),TO_DATE('30-APR-2025','DD-MON-YYYY'))
);

-- Student 27
INSERT INTO Student VALUES (
    27, 
    Name_Type('Jason', 'AA.', 'Nelson'), 
    TO_DATE('28-APR-2000','DD-MON-YYYY'), 
    3.65, 
    119, 
    'Software Engineering', 
    Address_Type('411','Coder Ct','Thana-53','District-53'), 
    Address_Type('421','Debug Dr','Thana-54','District-54'), 
    Phone_Numbers_Varray('4445556667'), 
    Email_Addresses_Varray('jason.nelson@example.com'), 
    Research_Interests_Varray('Distributed Systems'), 
    Programming_Knowledge_Varray('Java','Python'), 
    Education_List(
       Education_Type('BSc in Soft Eng','University BB',2024)
    ),
    Family_Info_Type(
       Family_Type('Grandfather53','Grandmother53',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather54','Grandmother54')
    ),
    Player_Type('Chess',81), 
    Organizer_Type('Coding Society',TO_DATE('01-JUN-2024','DD-MON-YYYY'),TO_DATE('31-MAY-2025','DD-MON-YYYY'))
);

-- Student 28
INSERT INTO Student VALUES (
    28, 
    Name_Type('Rachel', 'BB.', 'Perez'), 
    TO_DATE('12-MAY-2001','DD-MON-YYYY'), 
    3.85, 
    127, 
    'Mathematics', 
    Address_Type('511','Integral Rd','Thana-55','District-55'), 
    Address_Type('521','Derivative Ave','Thana-56','District-56'), 
    Phone_Numbers_Varray('5556667778'), 
    Email_Addresses_Varray('rachel.perez@example.com'), 
    Research_Interests_Varray('Statistics'), 
    Programming_Knowledge_Varray('SAS','R'), 
    Education_List(
       Education_Type('BSc in Math','University CC',2023)
    ),
    Family_Info_Type(
       Family_Type('Grandfather55','Grandmother55',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather56','Grandmother56')
    ),
    Player_Type('Badminton',78), 
    Organizer_Type('Math Society',TO_DATE('01-JUL-2024','DD-MON-YYYY'),TO_DATE('30-JUN-2025','DD-MON-YYYY'))
);

-- Student 29
INSERT INTO Student VALUES (
    29, 
    Name_Type('Justin', 'CC.', 'Mitchell'), 
    TO_DATE('05-JUN-2000','DD-MON-YYYY'), 
    3.55, 
    116, 
    'Physics', 
    Address_Type('621','Gravity Rd','Thana-57','District-57'), 
    Address_Type('631','Inertia Ln','Thana-58','District-58'), 
    Phone_Numbers_Varray('6667778889'), 
    Email_Addresses_Varray('justin.mitchell@example.com'), 
    Research_Interests_Varray('Quantum Mechanics'), 
    Programming_Knowledge_Varray('Python','C++'), 
    Education_List(
       Education_Type('BSc in Physics','University DD',2022)
    ),
    Family_Info_Type(
       Family_Type('Grandfather57','Grandmother57',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather58','Grandmother58')
    ),
    Player_Type('Tennis',86), 
    Organizer_Type('Physics Club',TO_DATE('01-AUG-2024','DD-MON-YYYY'),TO_DATE('31-JUL-2025','DD-MON-YYYY'))
);

-- Student 30
INSERT INTO Student VALUES (
    30, 
    Name_Type('Victoria', 'DD.', 'Robinson'), 
    TO_DATE('16-JUL-2001','DD-MON-YYYY'), 
    3.95, 
    132, 
    'Biotechnology', 
    Address_Type('731','Genome Rd','Thana-59','District-59'), 
    Address_Type('741','Protein Ave','Thana-60','District-60'), 
    Phone_Numbers_Varray('7778889991'), 
    Email_Addresses_Varray('victoria.robinson@example.com','victoria.alt@example.com'), 
    Research_Interests_Varray('Biochemistry'), 
    Programming_Knowledge_Varray('Python','R'), 
    Education_List(
       Education_Type('BSc in Biotech','University EE',2023)
    ),
    Family_Info_Type(
       Family_Type('Grandfather59','Grandmother59',NULL,NULL),
       Family_Type(NULL,NULL,'Grandfather60','Grandmother60')
    ),
    Player_Type('Soccer',90), 
    Organizer_Type('Biotech Society',TO_DATE('01-SEP-2024','DD-MON-YYYY'),TO_DATE('31-AUG-2025','DD-MON-YYYY'))
);
