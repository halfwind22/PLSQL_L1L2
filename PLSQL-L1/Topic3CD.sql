--TOPIC 3
--ASSIGNMENT1

/*A.*/
DECLARE
v_emp_rec EMPLOYEES%ROWTYPE;
v_emp_no EMPLOYEES.EMPLOYEE_ID%TYPE:=&employee_id;
BEGIN
SELECT *
INTO v_emp_rec
FROM EMPLOYEES 
WHERE employee_id=v_emp_no;
 DBMS_OUTPUT.PUT_LINE('EmployeeNumber: '||v_emp_rec.employee_id||
 ', EmployeeName:'||v_emp_rec.first_name||' '||v_emp_rec.last_name||
 ', Salary: '||v_emp_rec.salary||', DepartmentNumber: '||v_emp_rec.department_id);
END;

/*B.*/
DECLARE
TYPE DeptRecord IS RECORD
(iDeptno department.department_id%TYPE, 
 sDeptName department.department_name%TYPE, 
 sDeptLoc department.location_id%TYPE
);
v_dep_rec DeptRecord;
v_d_rec DEPARTMENT%ROWTYPE;
v_sDeptName VARCHAR2(30):='&v_sDeptName';
v_sDeptLoc VARCHAR2(4):='&sDeptLoc';
v_iDeptno department.department_id%TYPE;
BEGIN
SELECT MAX(DEPARTMENT_ID)+1
INTO v_iDeptno
FROM DEPARTMENT;
IF (v_sDeptName IS NOT NULL AND LENGTH(v_sDeptName)<=21 AND v_sDeptLoc IN('BDC','CDC','HDC')) THEN
v_dep_rec.iDeptno:=v_iDeptno;
v_dep_rec.sDeptName:=v_sDeptName;
v_dep_rec.sDeptLoc:=v_sDeptLoc;
--Method 1
/*v_d_rec.department_id:=v_iDeptno;
v_d_rec.department_name:=v_sDeptName;
v_d_rec.location_id:=v_sDeptLoc;
INSERT INTO DEPARTMENT VALUES v_d_rec;*/
--Method 2
INSERT INTO DEPARTMENT(department_id,department_name,location_id)
VALUES(v_dep_rec.iDeptno,v_dep_rec.sDeptName,v_dep_rec.sDeptLoc);
END IF;
COMMIT;
END;

/*C.*/
DECLARE
TYPE INT_ARRAY IS VARRAY(10) OF NUMBER;
v_arr INT_ARRAY;
v_mx NUMBER:=0;
BEGIN
v_arr:=INT_ARRAY(300,23,54,784,123,99,1432,4,71000,18);
FOR X IN v_arr.FIRST..v_arr.LAST
LOOP
IF(v_arr(X)>v_mx) THEN
v_mx:=v_arr(X);
END IF;
END LOOP;
DBMS_OUTPUT.PUT_LINE('MAX :'||v_mx);
END;

--ASSIGNMENT2

/*A.*/
DECLARE
TYPE INT_ARRAY IS VARRAY(10) OF NUMBER;
v_arr INT_ARRAY;
v_mx NUMBER:=0;
x NUMBER(2):=1;
BEGIN
v_arr:=INT_ARRAY(300,23,54,784,123,99,1432,4,71000,18);
LOOP
EXIT WHEN x=v_arr.COUNT;
IF(v_arr(x)>v_arr(x+1)) THEN
v_mx:=v_arr(x);
v_arr(x):=v_arr(x+1);
v_arr(x+1):=v_mx;
x:=1;
ELSE 
  x:=x+1;
END IF;
END LOOP;

DBMS_OUTPUT.PUT_LINE('ASCENDING');
FOR  i IN v_arr.first..v_arr.last
LOOP
DBMS_OUTPUT.PUT_LINE(v_arr(i));
END LOOP;
x:=1;
LOOP
EXIT WHEN x=v_arr.COUNT;
IF(v_arr(x)<v_arr(x+1)) THEN
v_mx:=v_arr(x);
v_arr(x):=v_arr(x+1);
v_arr(x+1):=v_mx;
x:=1;
ELSE 
  x:=x+1;
END IF;
END LOOP;

DBMS_OUTPUT.PUT_LINE('DESCENDING');
FOR  i IN v_arr.first..v_arr.last
LOOP
DBMS_OUTPUT.PUT_LINE(v_arr(i));
END LOOP;

END;

/*B.*/
DECLARE
TYPE INT_ARRAY IS VARRAY(10) OF NUMBER;
v_arr INT_ARRAY;
v_n_key NUMBER:=&v_n_key;
v_mx NUMBER:=0;
x NUMBER(2):=1;
BEGIN
v_arr:=INT_ARRAY(300,23,54,784,123,99,1432,4,71000,18);
LOOP
EXIT WHEN x=v_arr.COUNT;
IF(v_arr(x)>v_arr(x+1)) THEN
v_mx:=v_arr(x);
v_arr(x):=v_arr(x+1);
v_arr(x+1):=v_mx;
x:=1;
ELSE 
  x:=x+1;
END IF;
END LOOP;

FOR  i IN v_arr.first..v_arr.last
LOOP
DBMS_OUTPUT.PUT_LINE(v_arr(i));
END LOOP;

DBMS_OUTPUT.PUT_LINE('The '||v_n_key||' minimum element is '||v_arr(v_n_key));
END;


/*C.*/
DECLARE
TYPE INT_ARRAY IS VARRAY(10) OF NUMBER;
v_arr INT_ARRAY;
v_e_key NUMBER:=&v_n_key;
v_found BOOLEAN := TRUE;
BEGIN
v_arr:=INT_ARRAY(300,23,54,784,123,99,1432,4,71000,18);
FOR  i IN v_arr.first..v_arr.last
LOOP
IF (v_arr(i)=v_e_key) THEN 
v_found:=FALSE;
DBMS_OUTPUT.PUT_LINE('Element '||v_e_key||' exists at position'||i);
END IF;
END LOOP;
IF(v_found) THEN
DBMS_OUTPUT.PUT_LINE('Element not Found');
END IF;
END;

/*D.*/
DECLARE
TYPE INT_ARRAY IS TABLE OF NUMBER;
v_arr INT_ARRAY:=INT_ARRAY(300,23,54,784,123,99,1432,4,71000,18);
v_e_key NUMBER:=&v_n_key;
i INT;
BEGIN
DBMS_OUTPUT.PUT_LINE('BEFORE DELETION');
FOR  i IN v_arr.first..v_arr.last
LOOP
DBMS_OUTPUT.PUT_LINE(v_arr(i));
END LOOP;

IF v_arr.EXISTS(v_e_key) THEN
 v_arr.DELETE(v_e_key);
DBMS_OUTPUT.PUT_LINE('AFTER DELETION');
i:=v_arr.first;
 LOOP
 EXIT WHEN i=v_arr.last;
  DBMS_OUTPUT.PUT_LINE(v_arr(i));
 i:=v_arr.next(i);
 END LOOP;
ELSE 
DBMS_OUTPUT.PUT_LINE('Element not Found,array sie is 10,Accept a number between 1 to 10 from the user');
END IF;

END;