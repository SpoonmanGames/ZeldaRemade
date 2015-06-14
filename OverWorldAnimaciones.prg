PROCESS flores(x,y)
PRIVATE
	byte delay = 0;
BEGIN
	file = _id_fpg_ow;
	graph = 500;
	z = 199;
	
	LOOP

		IF(delay==10)
			delay=0;
			animacion(500,502);
		END
	
		delay++;
		FRAME;
	END
	
END
