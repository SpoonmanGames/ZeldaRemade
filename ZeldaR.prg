/***********************************************************************/
/* ZeldaR.prg v0.0.15
 *
 * Este archivo contiene el proceso principal del juego y el que inicia todo
 *
 * Las funciones principales de este archivo son:
 * Main()
 *
 * Hace llamado de los siguientes .prg:
 *	- import.prg : donde se encuentran los mod necesarios
 *	- include.prg : donde se encuentran .prg de procesos generales
 *
 * Datos Generales del programa:
 *	- El Z más "profundo" o mas "atras" es 200
 *
 * Para más información sobre el uso lea las secciones Variables Globales y 
 * Procesos Principales
 *
 */
/***********************************************************************/

include "DLL/import.prg";

/* ------------------------------ Variables Globales ----------------------------- */
GLOBAL
	/** Variables Globales
		@var _limite_der : determina el limite derecho en la resolucion estandar del juego
		_limite_der+1: limite real de imagen
		@var _limite_inf : determina el limite inferior en la resolucion estandar del juego
		_limite_inf+1: limite real de image
		@var _fps : determina a cuantos fps correra el juego
		@var _fps_emergencia : determina cuantos fps puede saltarse el juego en caso de sobre carga
		@var _centro_x : determina la posicion central de la pantalla en resolucion estandar por coordenada x
		@var _centro_y : determina la posicion central de la pantalla en resolucion estandar por coordenada y
		@var _mapa_durezas : determina el mapa de durezas que usaran los personajes en el juego 
		@var _file_durezas : determina el fpg de donde sacaran la info de los mapas de durezas 
		@var _id_color_blanco : guarda la ID del color blanco dado por rgb()
		@var _id_fpg_ow : determina el fpg de donde se sacara la info del OverWorld
		@var _id_link : gurda la ID del proceso LINK */
	int _limite_der = 511;
	int _limite_inf = 335;
	byte _fps = 60;
	byte _fps_emergencia = 9;
	
	int _centro_x = 255;
	int _centro_y = 167;
	
	int _mapa_durezas = 0;
	int _file_durezas = 0;
	
	int _id_color_blanco = 0;
	
	int _id_fpg_ow = 0;
	
	int _cambiando_mapa = 0;
	int _cambio_en_x = 0;
	int _cambio_en_y = 0;

	link _id_link;	
END

DECLARE PROCESS link(x,y)
	PUBLIC
		/** Variables Publicas
		@var orientacion : grafico de la orientacion en la que ha quedado mirando, determina si es posible 
		hacer movimientos en mas de una direccion y en cuales
		orientacion = 0 -> abajo
		orientacion = 1 -> arriba
		orientacion = 2 -> izquierda
		orientacion = 3 -> derecha
		orientacion = 4 -> estandar */
		byte orientacion = 0;
	END
END
/* ---------------------------- Fin Variables Globales --------------------------- */

include "DLL/include.prg";
include "OverWorldManager.prg";
include "MCR(Z).prg";
include "Link.prg";

/* ------------------------------ Proceso Principal ------------------------------ */
/** Proceso Main
	Ajusta las variables generales del juego y lanza el proceso principal del juego*/
PROCESS Main();
BEGIN
	
	/* Variables referentes a la pantalla y resolucion */
	set_title("Zelda Remake v0.0.15");
	set_mode(_limite_der+1,_limite_inf+1,MODE_32BITS,MODE_WINDOW);	
	set_fps(_fps,_fps_emergencia);
	
	/* Se obtiene la ID del color blanco */
	_id_color_blanco=rgb(255,255,255);
	
	/* Se carga el FPG principal con los mapas y durezas del OverWorld */
	_id_fpg_ow = load_fpg("images/overworld.fpg");
	
	/* Se protege del SIGNAL S_KILL */
	signal_action(S_KILL,S_IGN);
	
	/* Se crea a link */
	_id_link = link(_centro_x,_centro_y);
	
	/* Se crea el OverWorld */
	overWorldMapMan(_centro_x,_centro_y,077);
	
	LOOP
		IF(key(_ESC))
			let_me_alone();
			unload_fpg(_id_fpg_ow);
			BREAK;
		END
		FRAME;
	END
	
END
/*****************************/
/* ---------------------------- Fin Proceso Principal ---------------------------- */