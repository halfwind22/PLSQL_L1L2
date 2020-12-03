/*Assignment 2:*/
/*A*/
CREATE OR REPLACE FUNCTION USER_ANNUAL_COMP
(employeeNumber IN NUMBER,salary IN NUMBER,commission IN NUMBER)
RETURN NUMBER
IS 
annual_compensation NUMBER;
BEGIN
annual_compensation:=(NVL(salary,0)+NVL(commission,0))*12;
RETURN annual_compensation;
END;


BEGIN
DBMS_OUTPUT.PUT_LINE('Annual Compensation: '||USER_ANNUAL_COMP(10,NULL,NULL));
END;

/*B*/
CREATE OR REPLACE FUNCTION SHOW_STRENGTH(departmentNumber IN NUMBER)
RETURN NUMBER
IS
e_invalid_ex EXCEPTION;
v_count NUMBER;
BEGIN
IF(USER_VALID_DEPTNO(departmentNumber)) THEN 
SELECT COUNT(*) INTO v_count
FROM EMPLOYEES e where e.department_id=departmentNumber;
RETURN v_count;
ELSE
RAISE e_invalid_ex;
END IF;
EXCEPTION WHEN e_invalid_ex OR NO_DATA_FOUND
          THEN DBMS_OUTPUT.PUT_LINE('invalid department number');
          RETURN 0;  
          WHEN OTHERS
          THEN DBMS_OUTPUT.PUT_LINE('Ah! Other error');         
END;


CREATE OR REPLACE FUNCTION USER_VALID_DEPTNO(departmentNumber IN NUMBER)
RETURN BOOLEAN
IS
BEGIN 
FOR x IN(select count(*) cnt
from dual
where exists (SELECT 1 from department where department_id=departmentNumber))
LOOP
IF x.cnt=1
THEN RETURN TRUE;
ELSE
RETURN FALSE;
END IF;
END LOOP;
END;

begin 
DBMS_OUTPUT.PUT_LINE('Strength of department: '||SHOW_STRENGTH(10));
end;