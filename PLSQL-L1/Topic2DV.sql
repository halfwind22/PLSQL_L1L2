--TOPIC 2
--ASSIGNMENT1

/*A.*/
DECLARE
CHK_NUMBER NUMBER:=&CHK_NUMBER;
BEGIN 
IF MOD(CHK_NUMBER,2)=0 THEN
   DBMS_OUTPUT.PUT_LINE('EVEN '||CHK_NUMBER);
ELSE
  DBMS_OUTPUT.PUT_LINE('ODD '||CHK_NUMBER);
END IF;  
END;


/*B.*/
DECLARE
/*-------------sieve of eratosthenes---------------*/
TYPE PRIME_REC IS VARRAY(100) OF BOOLEAN;
p_list PRIME_REC;
v_counter NUMBER:=1;
BEGIN
  p_list:=PRIME_REC(
FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,
FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,
FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,
FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,
FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,
FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,
FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,
FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,
FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,
FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,
FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,
FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,
FALSE,FALSE,FALSE,FALSE);
  
   FOR i in 2..p_list.last
   LOOP
   v_counter:=2*i;
    LOOP
    EXIT WHEN v_counter>p_list.last;
    p_list(v_counter):=TRUE;
    v_counter:=v_counter+i;
    END LOOP;
   END LOOP;
   
FOR i in p_list.first..p_list.last
  LOOP  
    IF p_list(i)=FALSE THEN
    DBMS_OUTPUT.PUT_LINE(i);
    END IF;
  END LOOP;  
END;

/*C.*/
DECLARE
v_month NUMBER(2):=&v_month;
BEGIN
CASE WHEN v_month=1 THEN 
     DBMS_OUTPUT.PUT_LINE('January');
     WHEN v_month=2 THEN 
     DBMS_OUTPUT.PUT_LINE('February');
     WHEN v_month=3 THEN 
     DBMS_OUTPUT.PUT_LINE('March');
     WHEN v_month=4 THEN 
     DBMS_OUTPUT.PUT_LINE('April');
     WHEN v_month=5 THEN 
     DBMS_OUTPUT.PUT_LINE('May');
     WHEN v_month=6 THEN 
     DBMS_OUTPUT.PUT_LINE('June');
     WHEN v_month=7 THEN 
     DBMS_OUTPUT.PUT_LINE('July');
     WHEN v_month=8 THEN 
     DBMS_OUTPUT.PUT_LINE('August');
     WHEN v_month=9 THEN 
     DBMS_OUTPUT.PUT_LINE('September');
     WHEN v_month=10 THEN 
     DBMS_OUTPUT.PUT_LINE('October');
     WHEN v_month=11 THEN 
     DBMS_OUTPUT.PUT_LINE('November');
     WHEN v_month=12 THEN 
     DBMS_OUTPUT.PUT_LINE('December');
     WHEN v_month<1 OR v_month>12 THEN
     DBMS_OUTPUT.PUT_LINE('Invalid Month');
END CASE;     
END;

/*D.*/
DECLARE
v_num1 NUMBER:=&v_num1;
v_num2 NUMBER:=&v_num2;
v_num3 NUMBER:=&v_num3;
BEGIN
IF v_num1>v_num2 THEN 
    IF v_num1>v_num3 THEN
       DBMS_OUTPUT.PUT_LINE(v_num1||' IS THE GREATEST');
    ELSE
       DBMS_OUTPUT.PUT_LINE(v_num3||' IS THE GREATEST');
    END IF;   
ELSIF v_num2>v_num3 THEN 
      DBMS_OUTPUT.PUT_LINE(v_num2||' IS THE GREATEST');
ELSE
      DBMS_OUTPUT.PUT_LINE(v_num3||' IS THE GREATEST');
END IF;
END;

/*E.*/
DECLARE
v_sum NUMBER:=0;
v_div NUMBER:=1;
BEGIN
FOR i IN 2..100
   LOOP <<outer_loop>>
   v_div:=1;
    v_sum:=0;
   LOOP <<inner_loop>>
    EXIT WHEN (v_div>(i/2));
     IF(MOD(i,v_div)=0) THEN
        v_sum:=v_sum+v_div;
     END IF;
   v_div:=v_div+1;
   END LOOP inner_loop; 
  IF( v_sum=i) THEN
  DBMS_OUTPUT.PUT_LINE(i||' IS A PERFECT NUMBER');
  END IF;  
END LOOP outer_loop;  
END;

--ASSIGNMENT2
/*A.*/
DECLARE
v_emp_no EMPLOYEES.employee_id%TYPE:=&v_emp_no;
v_sal_temp employees.salary%TYPE;
v_class VARCHAR2(20);
v_emp_name employees.first_name%TYPE;
BEGIN
SELECT salary,first_name 
into v_sal_temp,v_emp_name
from employees
where employee_id=v_emp_no;
v_class:=CASE WHEN v_sal_temp>=5000 THEN 'Ultra Deluxe'
              WHEN v_sal_temp>=2500 AND v_sal_temp<5000 THEN 'Super Deluxe'
              ELSE 'Deluxe'
         END;
DBMS_OUTPUT.PUT_LINE('EMPLOYEE ID/NUMBER: '||v_emp_no||' NAME: '||v_emp_name||' SALARY: '||v_sal_temp||' CLASS: '||v_class);         
END;

/*B.*/
DECLARE
v_dept_id department.department_id%TYPE:=&v_dept_id;
v_dept_name department.department_name%TYPE;
BEGIN
SELECT department_name
INTO v_dept_name
FROM department
WHERE department_id=v_dept_id;
CASE WHEN v_dept_name='TT' THEN 
     DBMS_OUTPUT.PUT_LINE('remark: Talent Transformation');
 WHEN v_dept_name='BAS' THEN 
     DBMS_OUTPUT.PUT_LINE('remark: Business Administration Services');
 WHEN v_dept_name='PES' THEN 
     DBMS_OUTPUT.PUT_LINE('remark: Product Engineering Service');
 WHEN v_dept_name='FS' THEN 
     DBMS_OUTPUT.PUT_LINE('remark: Financial Service');
 WHEN v_dept_name='CTE' THEN 
     DBMS_OUTPUT.PUT_LINE('remark: Center For Technology Excellence');     
END CASE;     
END;

/*C.*/

create or replace FUNCTION num_to_word (
    n_val IN NUMBER
) RETURN VARCHAR2 AS
    v_result VARCHAR2(20);
BEGIN
    SELECT
        decode(n_val, 1, 'one', 2, 'two',
               3, 'three', 4, 'four', 5,
               'five', 6, 'six', 7, 'seven',
               8, 'eight', 9, 'nine', 10,
               'ten', 11, 'eleven', 12, 'twelve',
               13, 'thirteen', 14, 'fourteen', 15,
               'fifteen', 16, 'sixteen', 17, 'seventeen',
               18, 'eighteen', 19, 'nineteen', 20,
               'twenty', 21, 'twenty-one', 22, 'twenty-two',
               23, 'twenty-three', 24, 'twenty-four', 25,
               'twenty-five', 26, 'twenty-six', 27, 'twenty-seven',
               28, 'twenty-eight', 29, 'twenty-nine', 30,
               'thirty', 31, 'thirty-one', 32, 'thirty-two',
               33, 'thirty-three', 34, 'thirty-four', 35,
               'thirty-five', 36, 'thirty-six', 37, 'thirty-seven',
               38, 'thirty-eight', 39, 'thirty-nine', 40,
               'forty', 41, 'forty-one', 42, 'forty-two',
               43, 'forty-three', 44, 'forty-four', 45,
               'forty-five', 46, 'forty-six', 47, 'forty-seven',
               48, 'forty-eight', 49, 'forty-nine', 50,
               'fifty')
    INTO v_result
    FROM
        dual;

    RETURN v_result;
END;

BEGIN
FOR i IN 1..50
LOOP
DBMS_OUTPUT.PUT_LINE(num_to_word(i));
END LOOP;
END;

/*D.*/

CREATE TABLE Course(course_id NUMBER PRIMARY KEY,
course_name VARCHAR2(10));

INSERT INTO Course VALUES(100,'Maths');
INSERT INTO Course VALUES(110,'Physics');

DECLARE 
v_course Course%ROWTYPE;
v_course_ID course.course_id%TYPE;
CURSOR C_Course(c_id IN NUMBER) IS
SELECT * 
FROM Course 
WHERE course_id=c_id
FOR UPDATE;
BEGIN
OPEN C_Course(100);
FETCH C_Course INTO v_course;
DBMS_OUTPUT.PUT_LINE(v_course.course_id||' '||v_course.course_name);
  IF C_Course%FOUND THEN 
   DELETE FROM Course WHERE CURRENT OF C_Course;
ELSE
    DBMS_OUTPUT.PUT_LINE('No such course');
END IF; 
CLOSE C_Course;
COMMIT;
END;

/*E.*/
--Assign a random value is odd.If even assign random number-1.

CREATE TABLE DEPT_ASSN(DEPTNO NUMBER(2),
DEPT_NAME VARCHAR2(20));

declare
v_dname VARCHAR(20):='&v_dname';
v_x NUMBER(2);
begin
select ROUND(dbms_random.value(1,21),0) into v_x from dual;
INSERT INTO DEPT_ASSN VALUES(DECODE(MOD(v_x,2),0,v_x-1,v_x),v_dname);
commit;
end;