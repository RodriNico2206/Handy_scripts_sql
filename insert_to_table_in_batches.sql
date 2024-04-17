--origin table to use

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

--destiny table to use
CREATE TABLE aux2_rna
AS
SELECT author_name, title, num_pages FROM aux1_rna
WHERE seq_number=0
/

COMMIT
/

/*
TRUNCATE TABLE AUX3_RNA;
*/


SET SERVEROUTPUT ON;

DECLARE
    v_chunk_size NUMBER := 1000; -- Number of rows to insert in each batch
    v_total_rows NUMBER; -- Total number of rows in the source table
    v_start_row NUMBER := 0;
    v_end_row NUMBER;
    v_num_exec NUMBER;
    v_resto NUMBER;
BEGIN
    -- Get the total number of rows in the source table
    SELECT COUNT(*) INTO v_total_rows FROM AUX1_RNA;
    
    IF v_chunk_size > v_total_rows THEN
        v_num_exec:= 1;
        v_chunk_size:= v_total_rows;
    
    ELSE
        SELECT TRUNC(v_total_rows/v_chunk_size) INTO v_num_exec FROM DUAL;
        
        SELECT (v_total_rows-v_num_exec * v_chunk_size) INTO v_resto FROM DUAL;
        
        --DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_num_exec) || ' <> ' || TO_CHAR(v_resto));
    END IF;
    
    v_end_row:= v_chunk_size;
    
    FOR k IN 1..v_num_exec LOOP
    
        FOR rec IN (
            SELECT * FROM AUX1_RNA
            WHERE seq_number>v_start_row AND seq_number<=v_end_row
        ) LOOP
            
            INSERT INTO AUX2_RNA (author_name, title, num_pages)
            VALUES (rec.author_name, rec.title, rec.num_pages);
            
        END LOOP;
        
        v_start_row:= v_start_row + v_chunk_size;
        v_end_row:= v_end_row + v_chunk_size;
        
        IF (k=v_num_exec AND v_resto<>0) THEN
            INSERT INTO AUX2_RNA
            SELECT author_name, title, num_pages
            FROM AUX1_RNA
            WHERE seq_number>v_start_row
            AND seq_number<=v_total_rows;
        END IF;
        
    END LOOP;
    
END;
/


--check out amout of records between origin and destiny
SELECT COUNT(*) FROM AUX2_RNA
UNION ALL
SELECT COUNT(*) FROM AUX1_RNA
/