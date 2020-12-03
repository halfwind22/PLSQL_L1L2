--ASSIGNMENT2

/*A.*/
DECLARE
iFirstEmpNo VARCHAR2(30):=&iFirstEmpNo;
iSecondEmpNo VARCHAR2(30):=&iSecondEmpNo;
v_sal EMPLOYEES.SALARY%TYPE;
v_emp_id EMPLOYEES.employee_id%TYPE;
cursor c_sal is
SELECT salary,employee_id FROM employee WHERE employee_id IN(iFirstEmpNo,iSecondEmpNo)
FOR UPDATE OF SALARY;
v_sal1 VARCHAR2(30);
v_sal2 VARCHAR2(30);
BEGIN
open c_sal;
LOOP
FETCH c_sal INTO v_sal,v_emp_id;
EXIT WHEN c_sal%NOTFOUND=TRUE OR c_sal%FOUND=FALSE;
IF(v_emp_id=iFirstEmpNo) THEN
UPDATE EMPLOYEE SET SALARY=SALARY+(.1*SALARY) WHERE CURRENT OF c_sal;
ELSIF(v_emp_id=iSecondEmpNo) THEN
UPDATE EMPLOYEE SET SALARY=SALARY+(.2*SALARY) WHERE CURRENT OF c_sal;
END IF;
END LOOP;
IF(c_sal%rowcount=0) THEN
RAISE NO_DATA_FOUND;
END IF;
CLOSE c_sal; 
EXCEPTION WHEN NO_DATA_FOUND THEN
           DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND,ENTER ATLEAST 1 VALID EMPLOYEE NUMBER');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('OTHER ERROR');       
COMMIT;            
END;

/*B.*/

--i
DECLARE
CURSOR C_sl IS
SELECT first_name,salary from EMPLOYEE
FETCH FIRST 10 ROWS ONLY; 
v_name employee.first_name%type;
v_salary employee.salary%type;
BEGIN
OPEN C_sl;
LOOP
 FETCH C_sl INTO v_name,v_salary;
 EXIT WHEN C_sl%NOTFOUND=TRUE;
 DBMS_OUTPUT.PUT_LINE(v_name||' '||v_salary);
END LOOP;
CLOSE C_sl;
END;

--ii
DECLARE
CURSOR C_sl IS
SELECT first_name,salary from EMPLOYEE
FETCH FIRST 10 ROWS ONLY; 
v_name employee.first_name%type;
v_salary employee.salary%type;
BEGIN
OPEN C_sl;
 FETCH C_sl INTO v_name,v_salary;
WHILE C_sl%FOUND
LOOP
 DBMS_OUTPUT.PUT_LINE(v_name||' '||v_salary);
  FETCH C_sl INTO v_name,v_salary;
END LOOP;
CLOSE C_sl;
END;

--iii
DECLARE
CURSOR C_sl IS
SELECT first_name,salary from EMPLOYEE
FETCH FIRST 10 ROWS ONLY; 
v_name employee.first_name%type;
v_salary employee.salary%type;
BEGIN
FOR X in C_sl
LOOP
 DBMS_OUTPUT.PUT_LINE(X.first_name||' '||X.salary);
END LOOP;
END;

/*C.*/
DECLARE
CURSOR C_des(j_id VARCHAR2) IS
SELECT first_name,salary,department_id from EMPLOYEE
WHERE job_id=j_id; 
v_name employee.first_name%type;
v_salary employee.salary%type;
BEGIN
FOR X in C_des('IT_PROG')
LOOP
 DBMS_OUTPUT.PUT_LINE(X.first_name||' '||X.salary||' '||X.department_id);
END LOOP;
END;
