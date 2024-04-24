SET SERVEROUTPUT ON;
DECLARE
    l_original_string VARCHAR2(100) := 'green_yellow_029';
    l_prefix VARCHAR2(100);
    occur NUMBER:= 2; --number of occurrence of character founded
BEGIN
    -- Extract the prefix from the original string
    l_prefix := SUBSTR(l_original_string, 1, INSTR(l_original_string, '_', 1, occur));

    -- Output the result
    DBMS_OUTPUT.put_line('Prefix: ' || l_prefix);
END;
/
