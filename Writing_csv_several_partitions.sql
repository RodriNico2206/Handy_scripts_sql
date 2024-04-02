DECLARE
    v_counter NUMBER := 0;
    v_total_records NUMBER;
    v_corrida NUMBER := 1;
    v_increment NUMBER;
    v_filedir VARCHAR2(50) := 'D_PRUEBA_1'; -- Specify your directory path here
    v_filename VARCHAR2(50); -- Specify your filename here
    v_filehandle UTL_FILE.file_type;
    v_linea VARCHAR2(4000); -- Declare LINEA variable here
BEGIN
    
    v_filename := TO_CHAR(v_corrida)||'_archivo.csv';

    -- Get the total count of records in the table
    SELECT COUNT(*) INTO v_total_records FROM gravity.aux2_rna;

    -- Calculate the increment value based on the total number of records
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
        
        v_increment := maxim;
    END;

    -- Open the file for writing
    v_filehandle := UTL_FILE.FOPEN(v_filedir, v_filename, 'W');

    -- Loop until all records are processed
    WHILE v_counter <= v_total_records LOOP
        
        IF v_counter>0 AND v_counter<v_total_records THEN
            v_corrida := v_corrida +1;
            v_filename:= TO_CHAR(v_corrida)||'_archivo.csv';
        END IF;        
        
        -- Open the file for writing
        v_filehandle := UTL_FILE.FOPEN(v_filedir, v_filename, 'W');
        
        -- Process records in batches
        FOR rec IN (
            SELECT TRIM(SUBSTR(linea, INSTR(linea, ' '), LENGTH(linea)))
            INTO v_linea -- Assign the value to v_linea variable
            FROM gravity.aux2_rna
            WHERE TO_NUMBER(SUBSTR(linea, 1, INSTR(linea, ' '))) > v_counter
            AND TO_NUMBER(SUBSTR(linea, 1, INSTR(linea, ' '))) <= v_counter + v_increment
        ) LOOP
            -- Write each record to the file
            UTL_FILE.PUT_LINE(v_filehandle, TRIM(SUBSTR(v_linea, INSTR(v_linea, ' '), LENGTH(v_linea)))); -- Replace 'column_name' with the actual column name
            
        END LOOP;

        -- Increment the counter
        v_counter := v_counter + v_increment;
        
        -- Close the file
        UTL_FILE.FCLOSE(v_filehandle);
        
    END LOOP;

END;
/
