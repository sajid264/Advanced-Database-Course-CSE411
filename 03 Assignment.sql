-- Define object types for complex attributes
CREATE OR REPLACE TYPE Name_Type AS OBJECT (
    first_name VARCHAR2(50),
    middle_name VARCHAR2(50),
    last_name VARCHAR2(50)
);

CREATE OR REPLACE TYPE Address_Type AS OBJECT (
    house_number VARCHAR2(20),
    street VARCHAR2(100),
    thana VARCHAR2(50),
    district VARCHAR2(50)
);

CREATE OR REPLACE TYPE ResearchInterest_Type AS TABLE OF VARCHAR2(100);

CREATE OR REPLACE TYPE ProgrammingKnowledge_Type AS TABLE OF VARCHAR2(100);

CREATE OR REPLACE TYPE Qualification_Type AS OBJECT (
    degree VARCHAR2(50),
    institution VARCHAR2(100),
    year_of_graduation NUMBER(4)
);

CREATE OR REPLACE TYPE Qualification_List AS TABLE OF Qualification_Type;

CREATE OR REPLACE TYPE PhoneNumber_Type AS TABLE OF VARCHAR2(20);

CREATE OR REPLACE TYPE EmailAddress_Type AS TABLE OF VARCHAR2(100);

CREATE OR REPLACE TYPE FamilyTree_Type AS OBJECT (
    father VARCHAR2(100),
    grandfather VARCHAR2(100),
    mother VARCHAR2(100),
    grandmother VARCHAR2(100)
);

CREATE OR REPLACE TYPE Player_Type AS OBJECT (
    game VARCHAR2(50),
    score NUMBER(5,2)
);

CREATE OR REPLACE TYPE Organizer_Type AS OBJECT (
    club_name VARCHAR2(100),
    start_date DATE,
    end_date DATE
);

CREATE OR REPLACE TYPE Role_Type AS OBJECT (
    player Player_Type,
    organizer Organizer_Type
);

-- Create the main Student table with multiset attributes and complex types
CREATE TABLE Student (
    id NUMBER PRIMARY KEY,
    name Name_Type,
    date_of_birth DATE,
    cgpa NUMBER(3, 2),
    total_credits NUMBER(5),
    department VARCHAR2(100),
    present_address Address_Type,
    permanent_address Address_Type,
    phone_numbers PhoneNumber_Type,
    email_addresses EmailAddress_Type,
    research_interests ResearchInterest_Type,
    programming_knowledge ProgrammingKnowledge_Type,
    qualifications Qualification_List,
    family_tree FamilyTree_Type,
    roles Role_Type
) NESTED TABLE phone_numbers STORE AS phone_numbers_ntab,
  NESTED TABLE email_addresses STORE AS email_addresses_ntab,
  NESTED TABLE research_interests STORE AS research_interests_ntab,
  NESTED TABLE programming_knowledge STORE AS programming_knowledge_ntab,
  NESTED TABLE qualifications STORE AS qualifications_ntab;
