/* ----------------------------- Constantes Globales ----------------------------- */
CONST
	/** Constantes Globales
		@var MOVER_ABAJO : usadas por avanzar() para identificar la direccion en la que se movera el proceso padre
		@var MOVER_ARRIBA : usadas por avanzar() para identificar la direccion en la que se movera el proceso padre
		@var MOVER_IZQ : usadas por avanzar() para identificar la direccion en la que se movera el proceso padre
		@var MOVER_DER : usadas por avanzar() para identificar la direccion en la que se movera el proceso padre */
	MOVER_ABAJO = 1;
	MOVER_ARRIBA = 2;
	MOVER_IZQ = 3;
	MOVER_DER = 4;
END
/* --------------------------- Fin Constantes Globales --------------------------- */

PROCESS avanzar(int velocidad, byte direccion, int file_durezas, int mapa_durezas)
PRIVATE
	int colisionador_izq = 0;
	int colisionador_cen = 0;
	int colisionador_der = 0;
	int colisionador_pies = 0;
	int corrector = 0;
BEGIN
	signal_action(S_KILL,S_IGN);
	x=(father.x/father.resolution);
	y=(father.y/father.resolution);
						
	SWITCH(direccion)
		CASE MOVER_ABAJO:			
			colisionador_izq = map_get_pixel(file_durezas,mapa_durezas,x-16,y);
			colisionador_cen = map_get_pixel(file_durezas,mapa_durezas,x,y);
			colisionador_der = map_get_pixel(file_durezas,mapa_durezas,x+17,y);
			colisionador_pies = map_get_pixel(file_durezas,mapa_durezas,x,y-16);
			
			IF(colisionador_cen == _id_color_blanco)
				IF(colisionador_izq == _id_color_blanco AND colisionador_der != _id_color_blanco)
					father.x += (velocidad*2)/3;
				END
				IF(colisionador_izq != _id_color_blanco AND colisionador_der == _id_color_blanco)
					father.x -= (velocidad*2)/3;
				END
			ELSE
				father.y += velocidad;
				corrector = map_get_pixel(file_durezas,mapa_durezas,x-16,y-16);
				IF(corrector == _id_color_blanco)
					father.x += (velocidad*2)/3;
				END
				corrector = map_get_pixel(file_durezas,mapa_durezas,x+17,y-16);
				IF(corrector == _id_color_blanco)
					father.x -= (velocidad*2)/3;
				END
			END
			
		END
		CASE MOVER_ARRIBA:
			colisionador_izq = map_get_pixel(file_durezas,mapa_durezas,x-16,y-32);
			colisionador_cen = map_get_pixel(file_durezas,mapa_durezas,x,y-32);
			colisionador_der = map_get_pixel(file_durezas,mapa_durezas,x+17,y-32);
			colisionador_pies = map_get_pixel(file_durezas,mapa_durezas,x,y-16);
			
			IF(colisionador_cen == _id_color_blanco)
				IF(colisionador_izq == _id_color_blanco AND colisionador_der != _id_color_blanco)
					father.x += (velocidad*2)/3;
				END
				IF(colisionador_izq != _id_color_blanco AND colisionador_der == _id_color_blanco)
					father.x -= (velocidad*2)/3;
				END
			ELSE
				father.y -= velocidad;
				corrector = map_get_pixel(file_durezas,mapa_durezas,x-16,y-16);
				IF(corrector == _id_color_blanco)
					father.x += (velocidad*2)/3;
				END
				corrector = map_get_pixel(file_durezas,mapa_durezas,x+17,y-16);
				IF(corrector == _id_color_blanco)
					father.x -= (velocidad*2)/3;
				END
			END
		END
		CASE MOVER_IZQ:
			colisionador_izq = map_get_pixel(file_durezas,mapa_durezas,x-14,y-32);
			colisionador_cen = map_get_pixel(file_durezas,mapa_durezas,x-14,y-16);
			colisionador_der = map_get_pixel(file_durezas,mapa_durezas,x-14,y);
			colisionador_pies = map_get_pixel(file_durezas,mapa_durezas,x+3,y-16);
			
			IF(colisionador_cen == _id_color_blanco)
				IF(colisionador_izq == _id_color_blanco AND colisionador_der != _id_color_blanco)
					father.y += (velocidad*2)/3;
				END
				IF(colisionador_izq != _id_color_blanco AND colisionador_der == _id_color_blanco)
					father.y -= (velocidad*2)/3;
				END
			ELSE
				father.x -= velocidad;
				corrector = map_get_pixel(file_durezas,mapa_durezas,x+3,y-32);
				IF(corrector == _id_color_blanco)
					father.y += (velocidad*2)/3;
				END
				corrector = map_get_pixel(file_durezas,mapa_durezas,x+3,y);
				IF(corrector == _id_color_blanco)
					father.y -= (velocidad*2)/3;
				END
			END
		END
		CASE MOVER_DER:
			colisionador_izq = map_get_pixel(file_durezas,mapa_durezas,x+14,y-32);
			colisionador_cen = map_get_pixel(file_durezas,mapa_durezas,x+14,y-16);
			colisionador_der = map_get_pixel(file_durezas,mapa_durezas,x+14,y);
			colisionador_pies = map_get_pixel(file_durezas,mapa_durezas,x-3,y-16);
			
			IF(colisionador_cen == _id_color_blanco)
				IF(colisionador_izq == _id_color_blanco AND colisionador_der != _id_color_blanco)
					father.y += (velocidad*2)/3;
				END
				IF(colisionador_izq != _id_color_blanco AND colisionador_der == _id_color_blanco)
					father.y -= (velocidad*2)/3;
				END
			ELSE
				father.x += velocidad;
				corrector = map_get_pixel(file_durezas,mapa_durezas,x-3,y-32);
				IF(corrector == _id_color_blanco)
					father.y += (velocidad*2)/3;
				END
				corrector = map_get_pixel(file_durezas,mapa_durezas,x-3,y);
				IF(corrector == _id_color_blanco)
					father.y -= (velocidad*2)/3;
				END
			END
		END
	END
END