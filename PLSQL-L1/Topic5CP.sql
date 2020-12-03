--ASSIGNMENT 1
/*A*/
CREATE OR REPLACE PROCEDURE disp_emp_details (
    iempno    IN    NUMBER,
    sgrade    OUT   VARCHAR2,
    ssalary   OUT   VARCHAR2
) IS
BEGIN
    SELECT
        job_id,
        salary
    INTO
        sgrade,
        ssalary
    FROM
        employees
    WHERE
        employee_id = iempno;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('specified employee number does not exist in ''Employee'' table');
    WHEN OTHERS THEN
        dbms_output.put_line('OTHER ERROR');
END;

VARIABLE V_GRADE VARCHAR2(25);
VARIABLE V_SAL NUMBER;
BEGIN
disp_emp_details(10,:V_GRADE,:V_SAL);
IF :V_GRADE IS NOT NULL AND :V_SAL IS NOT NULL THEN 
dbms_output.put_line(' Employee grade is: '||:V_GRADE||' and salary is: '||:V_SAL); 
END IF;
END;


/*B*/
CREATE OR REPLACE PROCEDURE display_records (
    join_date IN DATE
) IS

    CURSOR c_emp_recd IS
    SELECT
        employee_id,
        department_id,
        salary
    FROM
        employees
    WHERE
        hire_date > join_date;

    v_emp_no              employee.employee_id%TYPE;
    v_emp_department_no   employee.department_id%TYPE;
    v_emp_salary          employee.salary%TYPE;
e_ndf EXCEPTION;
PRAGMA EXCEPTION_INIT(e_ndf,-100);
BEGIN
    OPEN c_emp_recd;
    FETCH c_emp_recd INTO
        v_emp_no,
        v_emp_department_no,
        v_emp_salary;
    IF ( c_emp_recd%rowcount = 0 ) THEN
        RAISE e_ndf;
    ELSE
        dbms_output.put_line('EmployeeNumber        Salary         DepartmentNumber');
        dbms_output.put_line('-------------------------------------------------------');
        LOOP
            EXIT WHEN c_emp_recd%notfound = true;
            dbms_output.put_line(' '
                                 || v_emp_no
                                 || '                   '
                                 || v_emp_salary
                                 || '                '
                                 || v_emp_department_no);

            FETCH c_emp_recd INTO
                v_emp_no,
                v_emp_department_no,
                v_emp_salary;
        END LOOP;

    END IF;

    CLOSE c_emp_recd;
EXCEPTION
    WHEN e_ndf THEN
        dbms_output.put_line('there are no employees who have joined after the specified date');
        dbms_output.put_line(sqlerrm);
        dbms_output.put_line(sqlcode);
    WHEN OTHERS THEN
        dbms_output.put_line('SOME OTHER ERROR');
END;





BEGIN
DISPLAY_RECORDS(to_date('20-FEB-2006'));
END;

BEGIN
DISPLAY_RECORDS(sysdate);
END;
