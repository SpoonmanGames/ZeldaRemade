/***********************************************************************/
/* Grafico.prg V0.3.2
 *
 * Este archivo contiene muchas funciones graficas utiles:
 *	- efectoEntradaImagen(int posicion_deseada_x, int posicion_deseada_y,
 *						   file,graph,z,
 *						   alpha,flags,
 *						   unsigned byte tipo_efecto, unsigned byte vel_efecto)
 *
 *  - animacion(int inicial, int final)
 *
 * Para agregarse sin problemas deben estar incluidos los siguientes mod:
 *	-
 *
 * Constantes Globales Utiles:
 *	- NO_FLAGS : No tendra flags especiales (en flags)
 *	- B_HMIRROR : Blit the graph horizontally mirrored (en flags).
 *	- B_VMIRROR	: Blit the graph vertically mirrored (en flags).
 *	- B_TRANSLUCENT : Blit the graph with half transparency (en flags).
 * 	- B_ALPHA : Blit the graph in some way (en flags).
 * 	- B_ABLEND : Blit the graph using additive blending (nice effect for fire) (en flags).
 * 	- B_SBLEND : Blit the graph using subtractive blending (nice effect for ghosting) (en flags).
 *	- B_NOCOLORKEY : Blit the transparent parts of the graph as black (color 0) (en flags).
 *
 *	- APARECER_POR_IZQ : usada para el tipo_efecto en efectoEntradaImagen()
 *	- APARECER_POR_DER : usada para el tipo_efecto en efectoEntradaImagen()
 *	- APARECER_POR_ABAJO : usada para el tipo_efecto en efectoEntradaImagen()
 *	- APARECER_POR_ARRIBA : usada para el tipo_efecto en efectoEntradaImagen()
 *
 * Para más información sobre el uso lea las secciones Constantes Globales, Variables Globales,
 * y Procesos y Funciones Principales
 *
 * TODO:
 *	- Agregar más funciones ya hechas [+0,1 por funcion]
 *	- Agregar efectos nuevos a efectoEntradaImagen [+0.0.1 por efecto]
 *	- Agregar efectos segundarios a efectoEntradaImagen (como rotar,fade on) [+0.0.1 por efecto]
 */
/***********************************************************************/

/* ----------------------------- Constantes Globales ----------------------------- */
CONST
/** @var NO_FLAGS : usada para los valores flags, permite no asignar un flags 
	@var APARECER_POR_IZQ : usada en efectoEntradaImagen (en unsigned byte tipo_efecto)
	@var APARECER_POR_DER : usada en efectoEntradaImagen (en unsigned byte tipo_efecto)
	@var APARECER_POR_ABAJO : usada en efectoEntradaImagen (en unsigned byte tipo_efecto)
	@var APARECER_POR_ARRIBA : usada en efectoEntradaImagen (en unsigned byte tipo_efecto)*/
	NO_FLAGS = 0;
	
	APARECER_POR_IZQ = 0;
	APARECER_POR_DER = 1;
	APARECER_POR_ABAJO = 2;
	APARECER_POR_ARRIBA = 3;
END
/* --------------------------- Fin Constantes Globales --------------------------- */

/* ------------------------------ Variables Globales ----------------------------- */
GLOBAL
	/** @var _rango_discrecion_izq : Esencial para efectoEntradaImagen, define el punto original del graph a la izq 
		@var _rango_discrecion_der : Esencial para efectoEntradaImagen, define el punto original del graph a la der 
		@var _rango_discrecion_sup : Esencial para efectoEntradaImagen, define el punto original del graph arriba 
		@var _rango_discrecion_inf : Esencial para efectoEntradaImagen, define el punto original del graph abajo  */
	int _rango_discrecion_izq = 0;
	int _rango_discrecion_der = 0;
	int _rango_discrecion_sup = 0;
	int _rango_discrecion_inf = 0;
END
/* ---------------------------- Fin Variables Globales --------------------------- */

/* ------------------------ Procesos y Funciones Principales --------------------- */
/** Proceso efectoEntradaImagen
	Permite darle un efecto de entrada a un grafico determinado de un archivo fpg determinado
	@param posicion_deseada_x : posicion deseada a la que llegue el graph en x
	@param posicion_deseada_y : posicion deseada a la que llegue el graph en y 
	@param file : archivo desde donde se sacara la imagen
	@param graph : numero del graph a usar desde el file
	@param alpha : transparencia del graph seleccionado
	@param flags : efecto flags usado sobre el graph seleccionado 
	@param tipo_efecto : tipo de efecto de entrada que tendra el graph seleccionado
	@param vel_efecto : velocidad a la que se llevara acabo el efecto seleccionado 
	
	AVISO: Antes de usar estep proceso se deben definir de forma obligatoria los valores de las siguientes
	variables globales:
	@var _rango_discrecion_izq
	@var _rango_discrecion_der
	@var _rango_discrecion_sup
	@var _rango_discrecion_inf
	Los cuales definen los puntos de aparición escenciales para cada efecto 
	(más detalle en la seccion Variables Globales)
	
	TIPS: 
	 - APARECER_POR_IZQ solo usa _rango_discrecion_izq
	 - APARECER_POR_DER solo usa _rango_discrecion_der
	 - APARECER_POR_ABAJO solo usa _rango_discrecion_inf
	 - APARECER_POR_ARRIBA solo usa _rango_discrecion_sup */
PROCESS efectoEntradaImagen(int posicion_deseada_x, int posicion_deseada_y,
					  file,graph,z,
					  alpha,flags,
					  unsigned byte tipo_efecto, unsigned byte vel_efecto)
BEGIN
	SWITCH(tipo_efecto)
		CASE APARECER_POR_IZQ: // Aparecer desde izquierda
			y=posicion_deseada_y;
			x=_rango_discrecion_izq;
			WHILE(x<posicion_deseada_x)
				x+=vel_efecto;
				FRAME;
			END
			x=posicion_deseada_x;
		END
		
		CASE APARECER_POR_DER: // Aparecer desde derecha
			y=posicion_deseada_y;
			x=_rango_discrecion_der;
			WHILE(x>posicion_deseada_x)
				x-=vel_efecto;
				FRAME;
			END
			x=posicion_deseada_x;
		END	
		
		CASE APARECER_POR_ABAJO: // Aparecer desde abajo
			x=posicion_deseada_x;
			y=_rango_discrecion_inf;
			WHILE(y>posicion_deseada_y)
				y-=vel_efecto;
				FRAME;
			END
			y=posicion_deseada_y;
		END
		
		CASE APARECER_POR_ARRIBA: // Aparecer desde arriba
			x=posicion_deseada_x;
			y=_rango_discrecion_sup;
			WHILE(y<posicion_deseada_y)
				y+=vel_efecto;
				FRAME;
			END
			y=posicion_deseada_y;
		END	
	END
	
	/* Mantiene vivo el graph */
	LOOP
		FRAME;
	END
END
/**************************************/

/**** Funcion Animacion ****/
/** Permite animar un grafico mediante una seccion de graficos, el grafico animado corresponde al del father
	El Graph avanza de uno en uno segun el rango especificado y el grafico actual
	@var inicial : grafico inicial de la animación general
	@var final : grafico final de la animación general */
FUNCTION animacion(int inicial, int final)
BEGIN
	father.graph=father.graph+1;						//Hace avanzar el graph
	IF(father.graph<inicial OR father.graph>final)		//Evalua que este en el rango
		father.graph=inicial;							// Si no lo esta se deja el graph inicial
	END
END
/**************************************/

/**** Funcion daVinci ****/
/** Permite dibujar un rectangulo de cualquier dimensión sobre un grafico especifico del file especificado,
	tambien permite elegir el color y la posición donde se dibujará
	@param id_file : identificador del file donde se encuentra el grafico 
	@param num_graph : numero del grafico en el que se dibujara 
	@param color : id del color generado via RGB() 
	@param X0 : esquina superior izquierda del rectangulo en x
	@param Y0 : esquina superior izquiera del rectangulo en y
	@param X1 : esquina inferior derecha del rectangulo en x 
	@param Y1 : esquina inferior derecha del rectangulo en y */
FUNCTION daVinci(int id_file, int num_graph, int color, int X0, int Y0, int X1, int Y1)
BEGIN
	drawing_map(id_file,num_graph);
	
	drawing_color(COLOR);
	
	draw_box(X0,Y0,X1,Y1);
END
/**************************************/

/* ---------------------- Fin Procesos y Funciones Principales ------------------- */