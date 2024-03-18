col head new_v v_head nopri
col fecha_inicio new_v v_fecha_inicio nopri
col fecha_fin new_v v_fecha_fin nopri
col execution_time new_v v_execution_time nopri
/

SELECT RPAD(LPAD(' ', 40, '*'), 40, '*') head FROM dual

/

pro &v_head
/
select TO_DATE('2023-11-01 10:30:00', 'YYYY-MM-DD HH24:MI:SS') fecha_fin
from DUAL
/

select TO_DATE('2023-11-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS') fecha_inicio
from DUAL
/


SELECT ROUND((to_date('&v_fecha_fin', 'YYYY-MM-DD HH24:MI:SS') - to_date('&v_fecha_inicio','YYYY-MM-DD HH24:MI:SS')) * 24 * 60
) AS execution_time
FROM dual
/

pro duracion de ejecucion &v_execution_time

