CREATE TABLE aux1_rna
AS
--SELECT ROWNUM "RowID", bp.*
--FROM (
    SELECT a.author_name, b.title, 
    b.publication_date, p.publisher_name, b.num_pages
    FROM book b
    INNER JOIN book_language bl ON bl.language_id = b.language_id
    INNER JOIN publisher p ON p.publisher_id = b.publisher_id
    INNER JOIN book_author ba ON ba.book_id = b.book_id
    INNER JOIN author a ON a.author_id = ba.author_id
    AND ROWNUM <=100
--    )bp
/

DROP TABLE aux1_rna
/

SELECT count(*) FROM aux1_rna
/

SET SERVEROUTPUT ON;

DECLARE
    v_counter NUMBER := 0;
    v_total_records NUMBER;
BEGIN
    -- Get the total count of records in the table
    SELECT COUNT(*) INTO v_total_records FROM aux1_rna;

    -- Loop until all records are processed
    WHILE v_counter < v_total_records LOOP
        -- Reset the counter for each batch
        v_counter := 0;

        -- Process records in batches of 7000
        FOR rec IN (
            SELECT * FROM (
                SELECT ROWNUM RN, a.* 
                FROM aux1_rna a
                )
            WHERE RN > v_counter
            AND RN <= v_counter + 20 --7000
        ) LOOP
            -- Process each record here
            -- For example, you can print the values of each record
            --DBMS_OUTPUT.PUT_LINE(rec.author_name || ' <> ' ||  rec.title);

            
        END LOOP;
        -- Increment the counter
        v_counter := v_counter + 20;
    END LOOP;
END;
/

SELECT * FROM  aux1_rna