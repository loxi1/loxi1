-- CREATE FUNCTION "up_op_rend" --------------------------------
```js
CREATE DEFINER=`usergoerp`@`%` PROCEDURE `up_op_rend`()
BEGIN
	DECLARE 	done INT DEFAULT FALSE;
	DECLARE		o INT;
	DECLARE 	r DECIMAL(17,6);
	DECLARE		cur1 CURSOR FOR select 
doc.id_ordendeproduccion,
(select round((dxc.cant_t_sub*100)/(doc.cant_t_sub*doc.ft_um_cov),2) from tb_documento dxc where dxc.id_documento=doc.id_sub_producto limit 1) cant_t_real
from tb_documento  doc
where doc.id_tipomovimiento=14 and doc.fecha_creado>"2018-12-31 11:59:59" ORDER BY doc.id_ordendeproduccion;
	DECLARE		CONTINUE HANDLER FOR NOT FOUND 
		SET done = TRUE;
	OPEN cur1;
	read_loop :
	LOOP
			FETCH cur1 INTO o,r;
		IF
			done THEN
				LEAVE read_loop;			
		END IF;
		IF
			o > 0 THEN
				UPDATE tb_ordendeproduccion set rendimiento_op=r where id_ordendeproduccion=o;
		END IF;
		
	END LOOP;
CLOSE cur1;
END;
```
-- -------------------------------------------------------------
