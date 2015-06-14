/***********************************************************************/
/* Link.prg v0.1.0
 *
 * Este archivo contiene el proceso que permite crear y controlar a link en el juego
 *
 * Las funciones principales de este archivo son:
 * link(x,y)
 *
 * Para más información sobre el uso lea la seccion Proceso Principal
 *
 * TODO:
 * 	- Revisar velocidad de la animacion al moverse de izq a der y viceversa [+0.1]
 */
/***********************************************************************/

/* ------------------------------ Proceso Principal ------------------------------ */
/** Proceso link
	Permite controlar totalmente a link en el juego
	@param x,y : posicion inicial del personaje */
PROCESS link(x,y)
PRIVATE
	/** Variables Privadas
		@var delay : contador de frames para animar el proceso
		@var velocidad_animacion : velocidad a la que se ejecuta la animacion 
		@var graph_inicial : grafico inicial de la animacion 
		@var graph_final : grafico final de la animacion */
	byte delay = 2;
	byte velocidad_animacion;
	byte graph_inicial = 010;
	byte graph_final = 010;
BEGIN
	
	/* Se protege del SIGNAL S_KILL */
	signal_action(S_KILL,S_IGN);
	
	/* Carga el file donde se encuentran todos los graph de link */
	file = load_fpg("images/link.fpg");
	
	/* Se asigna el graph_inicial al proceso */
	graph = graph_inicial;
	
	/* Link tiene un Z central respecto al mundo */
	z = 100;
	resolution = 100;
	
	/* Se ajusta la posicion inicial respecto a la resolution */
	x *= resolution;
	y *= resolution;
	
	LOOP
		SWITCH(_cambiando_mapa)
			/* Case 0: link se puede mover sin problemas  */
			CASE 0:
				/* Si link se mueve hacia abajo y esta en posicion estandar o abajo previamente */
				IF(key(_DOWN) AND (orientacion==4 OR orientacion==0))
					/* No hay flags y su orientacion es hacia abajo */
					flags=0;
					orientacion = 0;
					velocidad_animacion = 2;
					
					/* Normalmente ... */
					IF(!key(_UP))
						avanzar(300,MOVER_ABAJO,_file_durezas,_mapa_durezas);
						graph_inicial = 010;
						graph_final = 021;				
					ELSE
					/* Si preciona arriba link se movera hacia arriba */
						avanzar(300,MOVER_ARRIBA,_file_durezas,_mapa_durezas);
						graph_inicial = 030;
						graph_final = 041;
					END
					
					/* Si se mueve hacia la izq avanzara hacia la izquierda en menor velocidad */
					IF(key(_LEFT))
						avanzar(200,MOVER_IZQ,_file_durezas,_mapa_durezas);
					END
					/* Si se mueve hacia la der se movera hacia la derecha en menor velocidad, pero si
					   presiona izquierda el personaje se movera hacia la izquierda */
					IF(key(_RIGHT))
						IF(!key(_LEFT))
							avanzar(200,MOVER_DER,_file_durezas,_mapa_durezas);
						END
					END
				ELIF(key(_UP) AND (orientacion==4 OR orientacion==1))
					flags=0;
					orientacion = 1;
					velocidad_animacion = 2;
					graph_inicial = 030;
					graph_final = 041;
					
					IF(!key(_DOWN) OR key(_DOWN))
						avanzar(300,MOVER_ARRIBA,_file_durezas,_mapa_durezas);
					END
					
					IF(key(_LEFT))
						avanzar(200,MOVER_IZQ,_file_durezas,_mapa_durezas);
					END			
					IF(key(_RIGHT))
						IF(!key(_LEFT))
							avanzar(200,MOVER_DER,_file_durezas,_mapa_durezas);
						END
					END
					
				ELIF(key(_LEFT) AND (orientacion==4 OR orientacion==2))
					flags=1;
					orientacion = 2;
					velocidad_animacion = 3;
					graph_inicial = 050;
					graph_final = 061;
					
					IF(!key(_RIGHT) OR key(_RIGHT))
						avanzar(300,MOVER_IZQ,_file_durezas,_mapa_durezas);
					END
					
					IF(key(_UP))
						avanzar(200,MOVER_ARRIBA,_file_durezas,_mapa_durezas);
					END
					IF(key(_DOWN))
						IF(!key(_UP))
							avanzar(200,MOVER_ABAJO,_file_durezas,_mapa_durezas);
						END
					END
					
				ELIF(key(_RIGHT) AND (orientacion==4 OR orientacion==3))
					orientacion = 3;
					velocidad_animacion = 3;
					graph_inicial = 050;
					graph_final = 061;
					
					IF(!key(_LEFT))
						flags=0;
						avanzar(300,MOVER_DER,_file_durezas,_mapa_durezas);
					ELSE
						flags=1;
						avanzar(300,MOVER_IZQ,_file_durezas,_mapa_durezas);
					END				
					
					IF(key(_UP))
						avanzar(200,MOVER_ARRIBA,_file_durezas,_mapa_durezas);
					END
					IF(key(_DOWN))
						IF(!key(_UP))
							avanzar(200,MOVER_ABAJO,_file_durezas,_mapa_durezas);
						END
					END
				ELSE
					IF(orientacion==0)
						graph_inicial = 001;
						graph_final = 001;
						orientacion = 4;
					END
					IF(orientacion==1)
						graph_inicial = 002;
						graph_final = 002;
						orientacion = 4;
					END
					IF(orientacion==2 OR orientacion==3)
						graph_inicial = 003;
						graph_final = 003;
						orientacion = 4;
					END
				END //Fin IF de movimientos
				
				/* Cada velocidad_animacion frames el grafico se animará */
				IF(delay>=velocidad_animacion)
					delay=0;
					animacion(graph_inicial,graph_final);
				END
			END
			/* Case 1: link esta cambiando de mapa por lo que solo su grafico esta animado */
			CASE 1:
				
				x += _cambio_en_x*resolution;
				y += _cambio_en_y*resolution;
				
				IF(orientacion==0)
					avanzar(150,MOVER_ABAJO,_file_durezas,_mapa_durezas);
				ELIF(orientacion==1)
					avanzar(150,MOVER_ARRIBA,_file_durezas,_mapa_durezas);
				ELIF(orientacion==2)
					avanzar(150,MOVER_IZQ,_file_durezas,_mapa_durezas);
				ELIF(orientacion==3)
					avanzar(150,MOVER_DER,_file_durezas,_mapa_durezas);
				END
				
				IF(delay>=velocidad_animacion)
					delay=0;
					animacion(graph_inicial,graph_final);
				END
			END
		END //Fin Switch
			
		
		delay++;
		FRAME;
	END
END
/*****************************************/
/* ---------------------------- Fin Proceso Principal ---------------------------- */