DECLARE
    dividend NUMBER := 14346;
    divisor NUMBER;
    maxim NUMBER;
BEGIN
    divisor := 1;-- Initialize to 1, the smallest possible divisor
    maxim:= 0;
    FOR i IN 1..dividend LOOP
        divisor:= i;
        IF MOD(dividend, i) = 0  AND i >= maxim AND i<>dividend THEN
            maxim:= divisor;
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Maximum Common Divisor (GCD): ' || maxim);
END;