--Assignment 1:

CREATE OR REPLACE TRIGGER t1 BEFORE
    INSERT ON EMP
    FOR EACH ROW
BEGIN
    dbms_output.put_line('trigger t1 executed');
END;

CREATE OR REPLACE TRIGGER t2 BEFORE
    INSERT ON EMP 
    FOR EACH ROW
    FOLLOWS t1
BEGIN
    dbms_output.put_line('Trigger T2 executed');
END;

insert into emp values(NULL,NULL,'KUMAR','ABC@EMAIL.COM',NULL,SYSDATE,'KING',NULL,NULL,NULL,NULL);

--Assignment 2:

CREATE OR REPLACE TRIGGER COMP_TEST
FOR INSERT OR UPDATE OR DELETE
ON EMPLOYEES
COMPOUND TRIGGER

  BEFORE STATEMENT IS
  BEGIN
  dbms_output.put_line('BEFORE STATEMENT FIRED');
  END BEFORE STATEMENT;
  
  BEFORE EACH ROW IS
  BEGIN
  dbms_output.put_line('BEFORE EACH ROW FIRED');
  END BEFORE EACH ROW;
  
  AFTER EACH ROW IS
  BEGIN
  dbms_output.put_line('AFTER EACH ROW FIRED');
  END AFTER EACH ROW;
  
  AFTER STATEMENT IS
  BEGIN
  dbms_output.put_line('AFTER STATEMENT FIRED');
  END AFTER STATEMENT;
END;

--The use of compund trigger is to specify firing action for each of the following four timing points.
--Triggering sequence is 
/*BEFORE STATEMENT FIRED
BEFORE EACH ROW FIRED
AFTER EACH ROW FIRED
AFTER STATEMENT FIRED*/


--Assignment 3:
--db level
CREATE OR REPLACE TRIGGER TR_DDL
BEFORE DROP
ON DATABASE
BEGIN
IF(RTRIM(TO_CHAR(SYSDATE,'DAY')) IN('SATURDAY','SUNDAY')) THEN
raise_application_error(-20001, 'DROPPING of DB Objects on Saturday and Sunday not allowed');
END IF;
END;

--schema-level
CREATE OR REPLACE TRIGGER TR_DDL
BEFORE DROP
ON SCHEMA
BEGIN
IF(RTRIM(TO_CHAR(SYSDATE,'DAY')) IN('SATURDAY','SUNDAY')) THEN
raise_application_error(-20001, 'DROPPING of DB Objects FROM SHCEMA on Saturday and Sunday not allowed');
END IF;
END;


--Assignment 4:
--using SYS as users at pluggable database level
alter session set container='XEPDB1';

CREATE TABLE LOGON_TRACK ( USERNAME VARCHAR2(10), LOGON_DATE DATE);

CREATE OR REPLACE TRIGGER TR_LOGIN
AFTER LOGON
ON DATABASE
BEGIN
INSERT INTO LOGON_TRACK VALUES(USER,SYSDATE);
END;

SELECT USERNAME,TO_CHAR(LOGON_DATE,'DD-MM-YYYY HH:MI:SS PM') FROM LOGON_TRACK;

--Assignment 5:

CREATE OR REPLACE TRIGGER SAL_RED_TR
BEFORE UPDATE OF SALARY ON EMPLOYEES
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
IF(:NEW.SALARY<:OLD.SALARY) THEN
 raise_application_error(-20001, 'Salary of employees prevented from decreasing/reducing.');
 END IF;
END;

--Assignment 6:

CREATE TABLE AUD_EMP (
USERNAME VARCHAR2(100), 
UPDATE_DATE TIMESTAMP WITH LOCAL TIME ZONE DEFAULT SYSDATE, 
EMP_ID NUMBER(3), 
OLD_SALARY NUMBER,
NEW_SALARY NUMBER
);


CREATE OR REPLACE TRIGGER AUD_LOG
AFTER UPDATE OF SALARY ON EMPLOYEES
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
INSERT INTO AUD_EMP VALUES(:OLD.FIRST_NAME|| ' '||:OLD.LAST_NAME,SYSDATE,:OLD.EMPLOYEE_ID,:OLD.SALARY,:NEW.SALARY);
END;

SELECT * FROM EMP WHERE DEPARTMENT_ID=100;
UPDATE EMPLOYEES SET SALARY =25000 WHERE EMPLOYEE_ID=100;
COMMIT;

