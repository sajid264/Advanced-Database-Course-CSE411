-- Welcome

/*Step 01: Login to the database. 
Open SQL Plus and enter the following command to connect top the database */
-- / as sysdba;

select name from v$pdbs;


/*Connect to the pdb*/

connect sys/password@localhost:1521/XEPDB1 as sysdba;


/*Create Users
The second name is the password*/
CREATE USER sofia IDENTIFIED BY sofia DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;
CREATE USER app IDENTIFIED BY app DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;

/*Check if user is created successfully*/
SELECT username FROM all_users WHERE username in ('SOFIA', 'APP');


/*Grant Proper permissions to the user*/
GRANT CREATE SESSION TO sofia;
GRANT CREATE TABLE TO sofia;
GRANT CREATE PROCEDURE TO sofia;
GRANT CREATE SEQUENCE TO sofia;
GRANT CREATE TRIGGER TO sofia;
GRANT CREATE VIEW TO sofia;
GRANT CREATE ANY TABLE TO sofia;
GRANT CREATE ANY VIEW TO sofia;
GRANT CREATE ANY INDEX TO sofia;
GRANT CREATE ANY SEQUENCE TO sofia;
GRANT CREATE ANY PROCEDURE TO sofia;
GRANT CREATE ANY TRIGGER TO sofia;
GRANT CREATE TYPE TO sofia;

GRANT CREATE SESSION TO app;
GRANT CREATE TABLE TO app;
GRANT CREATE PROCEDURE TO app;
GRANT CREATE SEQUENCE TO app;
GRANT CREATE TRIGGER TO app;
GRANT CREATE VIEW TO app;
GRANT CREATE ANY TABLE TO app;
GRANT CREATE ANY VIEW TO app;
GRANT CREATE ANY INDEX TO app;
GRANT CREATE ANY SEQUENCE TO app;
GRANT CREATE ANY PROCEDURE TO app;
GRANT CREATE ANY TRIGGER TO app;
GRANT CREATE TYPE TO app;