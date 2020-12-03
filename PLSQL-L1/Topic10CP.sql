/*Assignment 2:*/

--1)

CREATE SEQUENCE  "HR"."SEQ"  
MINVALUE 1 MAXVALUE 99 INCREMENT BY 1
 START WITH 21 CACHE 20 NOORDER  NOCYCLE 
 NOKEEP  NOSCALE  GLOBAL ;

--2)

CREATE OR REPLACE PACKAGE Conference_Automation IS
  PROCEDURE CREATE_BOOKINGS(CCode IN VARCHAR2,Hname IN VARCHAR2,StartDate IN DATE,EndDate IN DATE);
  PROCEDURE TOTAL_BOOKINGS(HallType IN VARCHAR2,TOTAL_NO_BOOK OUT NUMBER);
  PROCEDURE BOOKING_REPORT(CompCode IN NUMBER);
  PROCEDURE RENT_COST_CALC(vTransId IN NUMBER);
END;  



CREATE OR REPLACE PACKAGE BODY Conference_automation IS

    FUNCTION hall_cap (
        htype IN NUMBER
    ) RETURN BOOLEAN IS
    BEGIN
        IF ( upper(htype) = 'SMALL' OR upper(htype) = 'MEDIUM' OR upper(htype) = 'LARGE' ) THEN
            RETURN true;
        ELSE
            dbms_output.put_line('Hall Capacity	: Must be either Small or Medium or Large');
            RETURN false;
        END IF;
    END;

    FUNCTION ccode_val (
        ccode IN VARCHAR2
    ) RETURN BOOLEAN IS
        CURSOR c IS
        SELECT
            ccode
        FROM
            company;

        compcode company.ccode%TYPE;
    BEGIN
        OPEN c;
        LOOP
            FETCH c INTO compcode;
            EXIT WHEN c%notfound = true;
            IF ( ccode = compcode AND ccode > 99 AND ccode < 1000 ) THEN
                RETURN true;
            END IF;

        END LOOP;

        CLOSE c;
        RETURN false;
    END;

    PROCEDURE create_bookings (
        ccode       IN   VARCHAR2,
        hname       IN   VARCHAR2,
        startdate   IN   DATE,
        enddate     IN   DATE
    ) IS
    BEGIN
        INSERT INTO booking VALUES (
            seq.NEXTVAL,
            ccode,
            hname,
            startdate,
            enddate
        );

        IF ( SQL%rowcount = 1 ) THEN
            dbms_output.put_line('RECORD INSERTED SUCCESSFULLY');
        ELSE
            dbms_output.put_line('SOME OTHER ERROR:INSERTION UNSUCCESSFUL');
        END IF;

        COMMIT;
    END;

    PROCEDURE total_bookings (
        halltype        IN    VARCHAR2,
        total_no_book   OUT   NUMBER
    ) AS
    BEGIN
        SELECT
            SUM(noofbookings)
        INTO total_no_book
        FROM
            halls
        GROUP BY
            htype
        HAVING
            upper(htype) = upper(halltype);

    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('NO SUCH HALL TYPE EXISTS');
        WHEN OTHERS THEN
            dbms_output.put_line('SOME OTHER ERROR');
    END;

    PROCEDURE booking_report (
        compcode IN NUMBER
    ) IS
        CURSOR c IS
        SELECT
            *
        FROM
            booking
        WHERE
            ccode = compcode;

        v_book booking%rowtype := NULL;
    BEGIN
        OPEN c;
        LOOP
            FETCH c INTO v_book;
            EXIT WHEN c%notfound = true;
            dbms_output.put_line('********************************************************************');
            dbms_output.put_line('Transaction Id'
                                 || ' '
                                 || 'Hall Name'
                                 || ' '
                                 || 'Start Date'
                                 || ' '
                                 || 'End Date');

            dbms_output.put_line(v_book.transid
                                 || ' '
                                 || v_book.hname
                                 || ' '
                                 || v_book.startdate
                                 || ' '
                                 || v_book.enddate);

        END LOOP;

        IF c%rowcount = 0 THEN
            RAISE no_data_found;
        END IF;
        CLOSE c;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('COMPANY HAS NOT YET DONE ANY BOOKING,PLEASE CHEK AGAIN');
        WHEN OTHERS THEN
            dbms_output.put_line('SOME OTHER ERROR');
    END;

    PROCEDURE rent_cost_calc (
        vtransid IN NUMBER
    ) IS
        no_days    NUMBER;
        rent_day   NUMBER;
    BEGIN
        SELECT
            h.rent,
            ( b.enddate - b.startdate ) + 1
        INTO
            rent_day,
            no_days
        FROM
            booking   b
            INNER JOIN halls     h ON h.hname = b.hname
        WHERE
            b.transid = vtransid;

        dbms_output.put_line('TOTAL COST OF RENTING FOR TRANCATION ID '
                             || vtransid
                             || ' IS: '
                             || rent_day * no_days);
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('iNVALID TRANSACTION id,PLEASE CHEK AGAIN');
        WHEN program_error THEN
            dbms_output.put_line('PROGRAM_ERROR');
        WHEN too_many_rows THEN
            dbms_output.put_line('TOO_MANY_ROWS');
    END;

END;

create or replace TRIGGER trUpdate 
AFTER INSERT
ON BOOKING
FOR EACH ROW
BEGIN
UPDATE HALLS SET NoOfBookings=NoOfBookings+1
WHERE HName=:NEW.HName; 
DBMS_OUTPUT.PUT_LINE('N0 of Bookings updated');
END;