/*Assignment2
Check Doc*/
create or replace procedure p1
is
n number:=0;
begin
FOR i IN 1..500000
LOOP
SELECT TO_NUMBER(TO_CHAR(SYSDATE,'RR')) INTO n FROM DUAL;
n:=n+i;
END LOOP;
end;

ALTER PROCEDURE P1 COMPILE ;

SET TIMING on;

EXECUTE p1;

ALTER PROCEDURE P1 COMPILE PLSQL_CODE_TYPE=NATIVE;

/*Assignment3
Check Doc*/
create or replace procedure p1
is
n number:=0;
begin
FOR i IN 1..500000
LOOP
SELECT TO_NUMBER(TO_CHAR(SYSDATE,'RR')) INTO n FROM DUAL;
n:=n+i;
END LOOP;
end;

ALTER PROCEDURE P1 COMPILE ;

SET TIMING on;

create or replace procedure CALL_PROC_ARITH
IS
BEGIN
for i in 1..10
loop
P1;
end loop;
END;

select NAME,TYPE,PLSQL_CODE_TYPE,plsql_optimize_level from user_plsql_object_settings where name IN(
'CALL_PROC_ARITH','P1');

/*Assignment4*/
--NOCOPY hint to improve performance when paramter Mode in procedures is OUT/IN OUT.
--This reduces extra buffer usage by preventing copy in and copy out.
--But in case of exception actual parameters are not returned,only buffer values.
CREATE OR REPLACE PROCEDURE P_TEST_With_No_Copy(x IN OUT NUMBER)
IS
BEGIN
x:=x*10;
dbms_output.put_line('VALUES OF X INSIDE subprogrm with NOCOPY is '||x);
IF(x>100) THEN
RAISE VALUE_ERROR;
END IF;
END;


CREATE OR REPLACE PROCEDURE P_TEST(x IN OUT NOCOPY NUMBER)
IS
BEGIN
x:=x*10;
dbms_output.put_line('VALUES OF X INSIDE subprogrm with NOCOPY is '||x);
IF(x>100) THEN
RAISE VALUE_ERROR;
END IF;
END;

CREATE OR REPLACE PROCEDURE CALL_P_TEST
IS
v_x NUMBER:=8;
BEGIN
P_TEST(v_x);
dbms_output.put_line('NO Error with NOCOPY hint: '||v_x);
P_TEST_With_No_Copy(v_x);
dbms_output.put_line('NO Error: without NOCOPY hint'||v_x);
EXCEPTION WHEN VALUE_ERROR THEN
dbms_output.put_line('EXCEPTION: '||v_x);
END;

EXEC CALL_P_TEST;

--PRAGMA INLINE
/*By default the PLSQL_OPTIMIZE_LEVEL is set to 2.To make subprograms inline(which is a feature of
--PLSQL_OPTIMIZE_LEVEL=3)we use explicit INLINE PRAGMA.This leads to performance improvement.*/
--CASE1:Without INLINE PRAGMA.
DECLARE
      v_return NUMBER;
      v_start NUMBER;
    FUNCTION add_numbers (
        p1   IN   NUMBER,
        p2   IN   NUMBER
    ) RETURN NUMBER AS
    BEGIN
        RETURN p1 + p2;
    END add_numbers;
  
   BEGIN
     v_start := DBMS_UTILITY.get_time;
  
     FOR i IN 1..100000000
     LOOP
     v_return := add_numbers(1, i);
     END LOOP;
  
     DBMS_OUTPUT.put_line('Elapsed Time: ' || (DBMS_UTILITY.get_time - v_start)/100 || ' seconds');
END;

/*Output:Elapsed Time: 42.38 seconds*/

--CASE2:With INLINE PRAGMA.
DECLARE
      v_return NUMBER;
      v_start NUMBER;
    FUNCTION add_numbers (
        p1   IN   NUMBER,
        p2   IN   NUMBER
    ) RETURN NUMBER AS
    BEGIN
        RETURN p1 + p2;
    END add_numbers;
  
   BEGIN
     v_start := DBMS_UTILITY.get_time;
  
     FOR i IN 1..100000000
     LOOP
     PRAGMA INLINE (add_numbers, 'YES');
     v_return := add_numbers(1, i);
     END LOOP;
  
     DBMS_OUTPUT.put_line('Elapsed Time: ' || (DBMS_UTILITY.get_time - v_start)/100 || ' seconds');
END;


/*Output:Elapsed Time: 14.88 seconds */

/*Assignment5*/

CREATE OR REPLACE FUNCTION DEL_ROWS
(TAB_NAME IN VARCHAR2,WHERE_CONDITION IN VARCHAR2)
RETURN NUMBER
IS
PRAGMA AUTONOMOUS_TRANSACTION;
v_stmt varchar2(1000);
v_no_rec number;
BEGIN
v_stmt:='DELETE FROM '||TAB_NAME||' WHERE '||WHERE_CONDITION;
dbms_output.put_line(v_stmt);
EXECUTE IMMEDIATE v_stmt;
v_no_rec:=SQL%ROWCOUNT;
COMMIT;
RETURN v_no_rec;
END;

EXEC dbms_output.put_line(DEL_ROWS('EMPLOYEES','DEPARTMENT_ID=40'));

SELECT DEL_ROWS('EMPLOYEES','DEPARTMENT_ID=50') FROM DUAL;

/*Assignment6*/
CREATE OR REPLACE procedure DROP_OBJ(OBJ_NAME IN VARCHAR2,OBJ_TYPE IN VARCHAR2)
IS
begin
EXECUTE IMMEDIATE 'DROP '||OBJ_TYPE||' '||OBJ_NAME;
EXCEPTION WHEN NO_DATA_FOUND
          THEN dbms_output.put_line('OBJECT DOES NOT EXISTS'); 
COMMIT;
end;