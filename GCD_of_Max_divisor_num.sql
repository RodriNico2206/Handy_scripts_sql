SET SERVEROUTPUT ON;

DECLARE
    dividend NUMBER := 60000;
    maxim NUMBER;
    prevMaxim NUMBER := 1; -- Initialize prevMaxim to 1 before the loop
BEGIN
    FOR j IN 1..3 LOOP
        maxim := 1; -- Initialize maxim to 1 before each inner loop

        FOR i IN 1..dividend LOOP
            IF MOD(dividend, i) = 0 AND i >= maxim AND i < dividend THEN
                maxim := i;
            END IF;
        END LOOP;

        IF maxim = 1 THEN
            maxim := prevMaxim; -- Restore prevMaxim if maxim becomes 1
        ELSE
            prevMaxim := maxim; -- Update prevMaxim if maxim is not 1
        END IF;
        
        dividend := maxim; -- Update dividend for the next iteration
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Maximum Common Divisor (GCD): ' || maxim);
END;