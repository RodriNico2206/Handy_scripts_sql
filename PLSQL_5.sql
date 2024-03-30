CREATE TABLE aux1_rna
AS
SELECT ROWNUM seq_number, bp.*
FROM (
    SELECT a.author_name, b.title, 
    b.publication_date, p.publisher_name, b.num_pages
    FROM book b
    INNER JOIN book_language bl ON bl.language_id = b.language_id
    INNER JOIN publisher p ON p.publisher_id = b.publisher_id
    INNER JOIN book_author ba ON ba.book_id = b.book_id
    INNER JOIN author a ON a.author_id = ba.author_id
   )bp
/

DROP TABLE aux1_rna
/

CREATE TABLE aux2_rna
NOLOGGING AS
SELECT seq_number||' '|| AUTHOR_NAME||'||'||TITLE||'||'||
TO_CHAR(PUBLICATION_DATE)||'||'||PUBLISHER_NAME||'||'||NUM_PAGES linea
FROM aux1_rna
/

DROP TABLE aux2_rna
/

SELECT count(*) FROM aux2_rna
/

SET SERVEROUTPUT ON;

DECLARE
    v_counter NUMBER := 0;
    v_total_records NUMBER;
    v_corrida NUMBER := 1;
    v_increment NUMBER;
BEGIN

    -- Get the total count of records in the table
    SELECT COUNT(*) INTO v_total_records FROM aux2_rna;

    DECLARE
        dividend NUMBER := v_total_records;
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
        
        --DBMS_OUTPUT.PUT_LINE('Maximum Common Divisor (GCD): ' || maxim);
        v_increment := maxim;
    END;

    -- Loop until all records are processed
    WHILE v_counter <= v_total_records LOOP
        -- Reset the counter for each batch
        
        IF v_counter>0 AND v_counter<v_total_records THEN
            v_corrida := v_corrida +1;
        END IF;

        -- Process records in batches
        FOR rec IN (
            SELECT TRIM( SUBSTR(linea, INSTR(linea, ' '), LENGTH(linea) ) )
            FROM aux2_rna
            WHERE TO_NUMBER( SUBSTR(linea, 1, INSTR(linea, ' ') ) ) >v_counter
            AND TO_NUMBER( SUBSTR(linea, 1, INSTR(linea, ' ') ) )<= v_counter + v_increment
        ) LOOP
            -- Process each record here
            -- For example, you can print the values of each record
            NULL;

            
        END LOOP;
        -- Increment the counter
        v_counter := v_counter + v_increment;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('N° de CSV''s generados: ' ||TO_CHAR(v_corrida)||'<>'||TO_CHAR(v_increment)||'<>'||TO_CHAR(v_total_records));


END;
/