create table aux_1
NOLOGGING AS
SELECT * FROM author
WHERE rownum<=1
/

create table aux_2
NOLOGGING AS
SELECT * FROM book
WHERE rownum<=1
/

COMMIT
/
BEGIN
FOR i IN 1..2 LOOP
    DECLARE
        name varchar2(50);
    BEGIN
        name:= 'DROP TABLE aux_' || TO_CHAR(i);
        
        EXECUTE IMMEDIATE name;
        
    END;
END LOOP;
END;
/

SELECT * FROM aux_1

