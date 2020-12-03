/*Assignment1*/
DROP  table Logger;
create table Logger(
id NUMBER,
event_time timestamp
);

DROP SEQUENCE LOG_SEQ;
CREATE SEQUENCE LOG_SEQ;

CREATE OR REPLACE procedure TEST_PROC
IS
BEGIN
INSERT INTO Logger values(LOG_SEQ.NEXTVAL,SYSDATE);
commit;
END;


SELECT LOG_SEQ.nextval from dual;
select* FROM Logger;

BEGIN
  DBMS_SCHEDULER.create_job (
    job_name        => 'Demo_Job_TEST_PROC',
    job_type        => 'STORED_PROCEDURE',
    job_action      => 'TEST_PROC',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY;INTERVAL=5',
    end_date => '17-SEP-20 11.30.00 AM',
    auto_drop => FALSE,
    comments => 'My new job');
END;



EXEC DBMS_SCHEDULER.ENABLE('Demo_Job_TEST_PROC');

SELECT job_name,job_creator,job_type,job_action,enabled,state FROM USER_SCHEDULER_JOBS;

SELECT log_id,log_date,job_name,operation,status,additional_info FROM USER_scheduler_job_log
order by log_id;


EXEC DBMS_SCHEDULER.DISABLE('Demo_Job_TEST_PROC');

EXEC DBMS_SCHEDULER.drop_job(job_name => 'Demo_Job_TEST_PROC');



/*Assignment2*/
--Wrapping using DDL_WRAP package

DECLARE
v_code VARCHAR2(500):='CREATE OR REPLACE FUNCTION RET_DATE
RETURN DATE 
IS
v_date DATE;
BEGIN
SELECT SYSDATE INTO v_date from dual;
RETURN v_date;
END;
';
BEGIN
dbms_ddl.create_wrapped(v_code);
END;

SELECT LINE,TEXT FROM USER_SOURCE where name='RET_DATE';

--Using WRAP utility
/*CheckDoc*/

@C:\Newfolder\test.plb;
SELECT LINE,TEXT FROM USER_SOURCE where name='RET_DATE';