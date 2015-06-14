/***********************************************************************/
/* OverWorldManager.prg v0.2.14
 *
 * Este archivo contiene el proceso que permite lanzar los diferentes escenarios del OverWorld de forma
 * directa, ademas considera los diferentes procesos para cada escenario con tan de tener diferenciacion
 *
 * Las funciones principales de este archivo son:
 * overWorldMapMan(x,y,byte mapa_actual)
 *
 * Para más información sobre el uso lea la seccion Proceso Principal
 *
 * TODO:
 * 	- Terminar los mapas faltantes (12/128) [+0.0.1]
 *	- Agregar animaciones, enemigos y toda la logica extra particular de cada escenario [+0.1]
 */
/***********************************************************************/

include "OverWorldAnimaciones.prg";

/* ------------------------------ Procesos Principales ------------------------------ */
/** Proceso overWorldMapMan
	Es el encargado de manejar el cambio de mapas, considera un cambio hacia la derecha, izquierda
	arriba y abajo.
	Funciona detectando la posicion de link en la pantalla
	Al ser usado hace un llamado al mapa en el que se desea partir
	@param x,y : debe ser la coordenada central de la pantalla
	@param mapa_actual : coordenada del mapa en el que se desea estar (i.e. 7,7 -> 077) */
PROCESS overWorldMapMan(x,y,byte mapa_actual)
PRIVATE
	/** Variables privadas
		@var id_mapa_actual : guarda la id del mapa en el que se esta actualmente
		@var id_mapa_siguiente : guarda la id del mapa al que se desea ir */
	int id_mapa_actual = 0;
	int id_mapa_siguiente = 0;
	int id_m_loop = 0;
	int id_m_overworld_nes_intro = 0;
	int id_m_overworld_nes_loop = 0;
	int id_m_overworld_snes_intro = 0;
	int id_m_overworld_snes_loop = 0;
BEGIN	
	/* Se cargan los temas que sonaran en el OverWorld */
	id_m_overworld_nes_intro = load_song("sounds/overworld_nes_intro.ogg");
	id_m_overworld_nes_loop = load_song("sounds/overworld_nes_loop.ogg");
	id_m_overworld_snes_intro = load_song("sounds/overworld_snes_intro.ogg");
	id_m_overworld_snes_loop = load_song("sounds/overworld_snes_loop.ogg");
	
	/* Se protege del SIGNAL S_KILL */
	signal_action(S_KILL,S_IGN);
	
	/* TEST */
	write_var(0,0,0,0,mapa_actual);
	/* FIN TEST */
	
	/* Se asigna la canción loop y parte el tema normal */
	id_m_loop = id_m_overworld_nes_loop;
	//play_song(id_m_overworld_nes_intro,0);

	/* Carga el mapa inicial */
	id_mapa_actual = overWorld(x,y,mapa_actual);

	LOOP
		
		/* Si la intro deja de sonar comienza la parte loopeable */
		IF(!is_playing_song())
			//play_song(id_m_loop,-1);
		END
		
		/* Permite cambiar entre el song de nes a snes y viceversa */
		IF(key(_1))
			WHILE(key(_1) AND id_m_loop!= id_m_overworld_snes_loop) FRAME; END
			id_m_loop = id_m_overworld_snes_loop;
			play_song(id_m_overworld_snes_intro,0);
		ELIF(key(_2) AND id_m_loop!= id_m_overworld_nes_loop)
			WHILE(key(_2)) FRAME; END
			id_m_loop = id_m_overworld_nes_loop;
			play_song(id_m_overworld_nes_intro,0);
		END
	
		/* Se revisa la posicion de link para determinar en que direccion se debe cambiar el mapa */
		IF(((_id_link.x/_id_link.resolution)+19>=_limite_der) AND _id_link.orientacion==3) /** Link avanzo hacia el mapa a la derecha **/
			
			/* Se suma una coordenada en x */
			mapa_actual += 10;
			
			/* Los mapas quedan estado "idle" */
			_cambiando_mapa = 1;
			
			/* Se mata a todo los procesos no fundamentales, los fundamentales ignoran la orden */
			signal(0,S_KILL);
			
			/* Se llama al mapa en la siguiente posicion a la derecha */
			id_mapa_siguiente = overWorld(x+_limite_der,y,mapa_actual);
			
			/* Se realiza el cambio pertinente */
			_cambio_en_x = -10;
			_cambio_en_y = 0;
			
			/* Se ajusta la posicion de los mapas y de link */
			REPEAT
				FRAME;
			UNTIL(id_mapa_siguiente.x<=_centro_x)
			
			/* Ajustes finales */
			id_mapa_siguiente.x=_centro_x;
			_cambio_en_x = 0;
			_cambio_en_y = 0;
			/* Los mapas estan en estado "activo" */
			_cambiando_mapa = 0;
			
			signal(id_mapa_actual,S_KILL_TREE_FORCE);			

			/* Se actualizan las ID */
			id_mapa_actual = id_mapa_siguiente;
			
		ELIF(((_id_link.x/_id_link.resolution)-18<=0) AND _id_link.orientacion==2)  /** Link avanzo hacia el mapa a la izquierda **/
		
			/* Se resta una coordenada en x */
			mapa_actual -= 10;
		
			_cambiando_mapa = 1;
		
			/* Se mata a todo los procesos no fundamentales, los fundamentales ignoran la orden */
			signal(0,S_KILL);
			
			/* Se llama al mapa en la siguiente posicion a la izquierda */
			id_mapa_siguiente = overWorld(x-_limite_der,y,mapa_actual);
			
			_cambio_en_x = 10;
			_cambio_en_y = 0;
			
			REPEAT
				FRAME;
			UNTIL(id_mapa_siguiente.x>=_centro_x)
			
			id_mapa_siguiente.x=_centro_x;
			_cambio_en_x = 0;
			_cambio_en_y = 0;
			_cambiando_mapa = 0;
			
			signal(id_mapa_actual,S_KILL_TREE_FORCE);

			id_mapa_actual = id_mapa_siguiente;
			
		ELIF((((_id_link.y/_id_link.resolution)-49)<=0) AND _id_link.orientacion==1) /** Link avanzo hacia el mapa arriba **/
		
			/* Se resta una coordenada en y */
			mapa_actual -= 1;
		
			_cambiando_mapa = 1;
		
			/* Se mata a todo los procesos no fundamentales, los fundamentales ignoran la orden */
			signal(0,S_KILL);
			
			/* Se llama al mapa en la siguiente posicion arriba */
			id_mapa_siguiente = overWorld(x,y-_limite_inf,mapa_actual);
			
			_cambio_en_x = 0;
			_cambio_en_y = 10;
			
			REPEAT
				FRAME;
			UNTIL(id_mapa_siguiente.y>=_centro_y)
			
			id_mapa_siguiente.y=_centro_y;
			_cambio_en_x = 0;
			_cambio_en_y = 0;
			_cambiando_mapa = 0;
			
			signal(id_mapa_actual,S_KILL_TREE_FORCE);

			id_mapa_actual = id_mapa_siguiente;
			
		ELIF((_id_link.y/_id_link.resolution)>=_limite_inf AND _id_link.orientacion==0) /** Link avanzo hacia el mapa abajo **/
		
			/* Se suma una coordenada en y */
			mapa_actual += 1;
		
			_cambiando_mapa = 1;
		
			/* Se mata a todo los procesos no fundamentales, los fundamentales ignoran la orden */
			signal(0,S_KILL);
			
			/* Se llama al mapa en la siguiente posicion abajo */
			id_mapa_siguiente = overWorld(x,y+_limite_inf,mapa_actual);
			
			_cambio_en_x = 0;
			_cambio_en_y = -10;
			
			REPEAT
				FRAME;
			UNTIL(id_mapa_siguiente.y<=_centro_y)
			
			id_mapa_siguiente.y=_centro_y;
			_cambio_en_x = 0;
			_cambio_en_y = 0;
			_cambiando_mapa = 0;
			
			signal(id_mapa_actual,S_KILL_TREE_FORCE);

			id_mapa_actual = id_mapa_siguiente;
		END
	
		FRAME;
	END
ONEXIT
	IF(id_m_overworld_nes_intro!=0) unload_song(id_m_overworld_nes_intro); END
	IF(id_m_overworld_nes_loop!=0) unload_song(id_m_overworld_nes_loop); END
	IF(id_m_overworld_snes_intro!=0) unload_song(id_m_overworld_snes_intro); END
	IF(id_m_overworld_snes_loop!=0) unload_song(id_m_overworld_snes_loop); END
END
/***************************/
/* --------------------------- Fin Procesos Principales -------------------------- */

/* ------------------------ Procesos y Funciones Privados ------------------------ */
/** Funcion overWorld
	Carga el mapa indicado en la posicion indicada
	Es usada por overWorldMapMan para cargar los mapas
	@param x,y : posicion x,y del mapa, debe ser el centro de la pantalla con la desviacion correspondiente al cambio
	@param mapa_actual : mapa que se va a cargar, dado en coordenadas
	@return ID del escenario cargado */
FUNCTION int overWorld(x,y,byte mapa_actual)
BEGIN
	/* Resive la coordenada, carga el escenario indicado y retorna la ID del escenario */
	SWITCH(mapa_actual)
		CASE 055:
			RETURN overWorld_055(x,y);
		END
		CASE 056:
			RETURN overWorld_056(x,y);
		END
		CASE 057:
			RETURN overWorld_057(x,y);
		END
		CASE 065:
			RETURN overWorld_065(x,y);
		END
		CASE 066:
			RETURN overWorld_066(x,y);
		END
		CASE 067:
			RETURN overWorld_067(x,y);
		END
		CASE 075:
			RETURN overWorld_075(x,y);
		END
		CASE 076:
			RETURN overWorld_076(x,y);
		END
		CASE 077:
			RETURN overWorld_077(x,y);
		END
		CASE 085:
			RETURN overWorld_085(x,y);
		END
		CASE 086:
			RETURN overWorld_086(x,y);
		END
		CASE 087:
			RETURN overWorld_087(x,y);
		END
	END
END
/***************************/

/** Proceso overWorld_055
	Corresponde al escenario en la coordenada 5,5
	Este proceso se preocupa de administrar todo lo que corresponde a su escenario
	@param x,y : posicion del fondo */
PROCESS overWorld_055(x,y)
PRIVATE
	byte iniciando;
BEGIN
	z = 200;
	
	/* Se protege del SIGNAL S_KILL */
	signal_action(S_KILL,S_IGN);
	
	/* Se cargan los file correspondientes */
	file = _id_fpg_ow;
	_file_durezas = file;
	
	/* Se asigna el graph y el mapa de durezas */
	graph = 055;	
	_mapa_durezas = graph+200;
	
	iniciando = 1;
	LOOP
		SWITCH(_cambiando_mapa)
			CASE 0:
				IF(iniciando==1)
					flores(88,160);
					flores(120,160);
					flores(72,176);
					flores(104,176);
					flores(136,176);
					flores(280,240);
					flores(312,240);
					flores(344,240);
					flores(376,240);
					flores(408,240);
					flores(264,256);
					flores(296,256);
					flores(328,256);
					flores(360,256);
					flores(392,256);
					flores(424,256);
					iniciando=0;
				END
			END
			CASE 1:
				x += _cambio_en_x;
				y += _cambio_en_y;
			END
		END
		FRAME;
	END
END
/***************************/

/** Proceso overWorld_056
	Corresponde al escenario en la coordenada 5,6
	Este proceso se preocupa de administrar todo lo que corresponde a su escenario
	@param x,y : posicion del fondo */
PROCESS overWorld_056(x,y)
PRIVATE
	byte iniciando;
BEGIN
	z = 200;
	
	/* Se protege del SIGNAL S_KILL */
	signal_action(S_KILL,S_IGN);
	
	file = _id_fpg_ow;
	_file_durezas = file;
	graph = 056;	
	_mapa_durezas = graph+200;
	
	iniciando = 1;
	LOOP
		SWITCH(_cambiando_mapa)
			CASE 0:
				IF(iniciando==1)
					flores(88,0);
					flores(88,32);
					flores(88,64);
					flores(104,16);
					flores(104,48);
					flores(104,80);
					flores(120,0);
					flores(120,32);
					flores(120,64);					
					flores(56,160);
					flores(88,160);
					flores(120,160);
					flores(40,176);
					flores(72,176);
					flores(104,176);
					flores(136,176);
					flores(264,0);
					flores(296,0);
					flores(280,16);
					flores(312,16);
					flores(264,32);
					flores(296,32);
					flores(280,48);
					flores(312,48);
					flores(280,80);
					flores(312,80);
					flores(344,80);
					flores(376,80);
					flores(408,80);
					flores(440,80);
					flores(296,96);
					flores(328,96);
					flores(360,96);
					flores(392,96);
					flores(424,96);
					flores(456,96);
					flores(280,112);
					flores(296,128);
					flores(280,144);
					flores(296,160);
					flores(280,176);
					flores(296,192);
					flores(440,112);
					flores(456,128);
					flores(440,144);
					flores(456,160);
					flores(440,176);
					flores(456,192);
					flores(280,208);
					flores(312,208);
					flores(344,208);
					flores(376,208);
					flores(408,208);
					flores(440,208);
					flores(296,224);
					flores(328,224);
					flores(360,224);
					flores(392,224);
					flores(424,224);
					flores(456,224);
					iniciando=0;
				END
			END
			CASE 1:
				x += _cambio_en_x;
				y += _cambio_en_y;
			END
		END
		FRAME;
	END
END
/***************************/

/** Proceso overWorld_057
	Corresponde al escenario en la coordenada 5,7
	Este proceso se preocupa de administrar todo lo que corresponde a su escenario
	@param x,y : posicion del fondo */
PROCESS overWorld_057(x,y)
PRIVATE
	byte iniciando;
BEGIN
	z = 200;
	
	/* Se protege del SIGNAL S_KILL */
	signal_action(S_KILL,S_IGN);
	
	file = _id_fpg_ow;
	_file_durezas = file;
	graph = 057;	
	_mapa_durezas = graph+200;
	
	iniciando = 1;
	LOOP
		SWITCH(_cambiando_mapa)
			CASE 0:
				IF(iniciando==1)
					flores(40,96);
					flores(72,96);
					flores(104,96);
					flores(136,96);
					flores(56,112);
					flores(88,112);
					flores(120,112);					
					flores(40,224);
					flores(72,224);
					flores(104,224);
					flores(56,240);
					flores(88,240);
					flores(344,240);
					flores(376,240);
					flores(408,240);
					flores(360,224);
					flores(392,224);
					flores(392,64);
					
					iniciando=0;
				END
			END
			CASE 1:
				x += _cambio_en_x;
				y += _cambio_en_y;
			END
		END
		FRAME;
	END
END
/***************************/

/** Proceso overWorld_065
	Corresponde al escenario en la coordenada 6,5
	Este proceso se preocupa de administrar todo lo que corresponde a su escenario
	@param x,y : posicion del fondo */
PROCESS overWorld_065(x,y)
PRIVATE
	byte iniciando;
BEGIN
	z = 200;
	
	/* Se protege del SIGNAL S_KILL */
	signal_action(S_KILL,S_IGN);
	
	file = _id_fpg_ow;
	_file_durezas = file;
	graph = 065;	
	_mapa_durezas = graph+200;
	
	iniciando = 1;
	LOOP
		SWITCH(_cambiando_mapa)
			CASE 0:
				IF(iniciando==1)
					flores(152,208);
					flores(184,208);
					flores(216,208);					
					flores(248,208);					
					flores(168,224);
					flores(200,224);
					flores(232,224);					
					flores(264,224);					
					flores(152,240);
					flores(184,240);
					flores(216,240);					
					flores(248,240);					
					flores(168,256);
					flores(200,256);
					flores(232,256);					
					flores(264,256);					
					flores(456,144);
					flores(488,144);					
					flores(472,160);
					flores(504,160);					
					flores(456,176);
					flores(488,176);					
					flores(472,192);
					flores(504,192);
					
					iniciando=0;
				END
			END
			CASE 1:
				x += _cambio_en_x;
				y += _cambio_en_y;
			END
		END
		FRAME;
	END
END
/***************************/

/** Proceso overWorld_066
	Corresponde al escenario en la coordenada 6,6
	Este proceso se preocupa de administrar todo lo que corresponde a su escenario
	@param x,y : posicion del fondo */
PROCESS overWorld_066(x,y)
PRIVATE
	byte iniciando;
BEGIN
	z = 200;
	
	/* Se protege del SIGNAL S_KILL */
	signal_action(S_KILL,S_IGN);
	
	file = _id_fpg_ow;
	_file_durezas = file;
	graph = 066;	
	_mapa_durezas = graph+200;
	
	iniciando = 1;
	LOOP
		SWITCH(_cambiando_mapa)
			CASE 0:
				IF(iniciando==1)
					flores(56,80);
					flores(88,80);
					flores(120,80);					
					flores(152,80);
					flores(72,96);
					flores(104,96);
					flores(136,96);					
					flores(168,96);					
					flores(56,112);
					flores(88,112);
					flores(120,112);					
					flores(152,112);
					flores(72,128);
					flores(104,128);
					flores(136,128);				
					flores(168,128);					
					flores(184,208);
					flores(216,208);
					flores(248,208);					
					flores(280,208);
					flores(200,224);
					flores(232,224);
					flores(264,224);					
					flores(296,224);					
					flores(184,240);
					flores(216,240);
					flores(248,240);					
					flores(280,240);
					flores(200,256);
					flores(232,256);
					flores(264,256);					
					flores(296,256);					
					flores(312,80);
					flores(344,80);
					flores(376,80);					
					flores(408,80);
					flores(328,96);
					flores(360,96);
					flores(392,96);					
					flores(424,96);
					flores(312,112);
					flores(344,112);
					flores(376,112);					
					flores(408,112);
					flores(328,128);
					flores(360,128);
					flores(392,128);					
					flores(424,128);					
					flores(440,144);
					flores(472,144);
					flores(456,160);					
					flores(488,160);
					flores(440,176);
					flores(472,176);
					flores(456,192);					
					flores(488,192);
					
					iniciando=0;
				END
			END
			CASE 1:
				x += _cambio_en_x;
				y += _cambio_en_y;
			END
		END
		FRAME;
	END
END
/***************************/

/** Proceso overWorld_067
	Corresponde al escenario en la coordenada 6,7
	Este proceso se preocupa de administrar todo lo que corresponde a su escenario
	@param x,y : posicion del fondo */
PROCESS overWorld_067(x,y)
PRIVATE
	byte iniciando;
BEGIN
	z = 200;
	
	/* Se protege del SIGNAL S_KILL */
	signal_action(S_KILL,S_IGN);
	
	file = _id_fpg_ow;
	_file_durezas = file;
	graph = 067;	
	_mapa_durezas = graph+200;
	
	iniciando=1;
	LOOP
		SWITCH(_cambiando_mapa)
			CASE 0:
				IF(iniciando==1)
					flores(8,96);
					flores(40,96);
					flores(72,96);
					flores(104,96);
					flores(136,96);
					flores(168,96);					
					flores(24,112);
					flores(56,112);
					flores(88,112);
					flores(120,112);
					flores(152,112);
					flores(184,112);					
					flores(8,224);
					flores(40,224);
					flores(72,224);
					flores(104,224);
					flores(24,240);
					flores(56,240);
					flores(88,240);					
					flores(232,224);
					flores(264,224);
					flores(296,224);
					flores(328,224);
					flores(360,224);
					flores(392,224);
					flores(248,240);
					flores(280,240);
					flores(312,240);
					flores(344,240);
					flores(376,240);
					flores(408,240);
					flores(392,64);
					
					iniciando=0;
				END
			END
			CASE 1:
				x += _cambio_en_x;
				y += _cambio_en_y;
			END
		END
		FRAME;
	END
END
/***************************/

/** Proceso overWorld_075
	Corresponde al escenario en la coordenada 7,5
	Este proceso se preocupa de administrar todo lo que corresponde a su escenario
	@param x,y : posicion del fondo */
PROCESS overWorld_075(x,y)
PRIVATE
	byte iniciando;
BEGIN
	z = 200;
	
	/* Se protege del SIGNAL S_KILL */
	signal_action(S_KILL,S_IGN);
	
	file = _id_fpg_ow;
	_file_durezas = file;
	graph = 075;	
	_mapa_durezas = graph+200;
	
	iniciando = 1;
	LOOP
		SWITCH(_cambiando_mapa)
			CASE 0:
				IF(iniciando==1)
					flores(40,112);
					flores(72,112);
					flores(104,112);
					flores(136,112);
					flores(328,112);
					flores(360,112);
					flores(392,112);
					flores(424,112);					
					flores(56,128);
					flores(88,128);
					flores(120,128);
					flores(152,128);
					flores(344,128);
					flores(376,128);
					flores(408,128);
					flores(440,128);					
					flores(136,160);
					flores(168,160);
					flores(200,160);
					flores(232,160);
					flores(264,160);
					flores(296,160);
					flores(328,160);
					flores(152,176);
					flores(184,176);
					flores(216,176);
					flores(248,176);
					flores(280,176);
					flores(312,176);
					flores(344,176);					
					flores(40,208);
					flores(72,208);
					flores(104,208);
					flores(136,208);
					flores(328,208);
					flores(360,208);
					flores(392,208);
					flores(424,208);					
					flores(56,224);
					flores(88,224);
					flores(120,224);
					flores(152,224);
					flores(344,224);
					flores(376,224);
					flores(408,224);
					flores(440,224);	
					
					iniciando=0;
				END
			END
			CASE 1:
				x += _cambio_en_x;
				y += _cambio_en_y;
			END
		END
		FRAME;
	END
END
/***************************/

/** Proceso overWorld_076
	Corresponde al escenario en la coordenada 7,6
	Este proceso se preocupa de administrar todo lo que corresponde a su escenario
	@param x,y : posicion del fondo */
PROCESS overWorld_076(x,y)
PRIVATE
	byte iniciando;
BEGIN
	z = 200;
	
	/* Se protege del SIGNAL S_KILL */
	signal_action(S_KILL,S_IGN);
	
	file = _id_fpg_ow;
	_file_durezas = file;
	graph = 076;	
	_mapa_durezas = graph+200;
	
	iniciando = 1;
	LOOP
		SWITCH(_cambiando_mapa)
			CASE 0:
				IF(iniciando==1)
					flores(72,96);
					flores(104,96);
					flores(120,96);
					flores(152,96);
					flores(88,112);
					flores(136,112);
					flores(72,128);
					flores(104,128);
					flores(120,128);
					flores(152,128);
					flores(88,144);
					flores(136,144);					
					flores(248,64);
					flores(232,80);					
					flores(424,96);
					flores(456,96);
					flores(440,112);					
					flores(200,224);
					flores(232,224);
					flores(264,224);					
					flores(216,240);
					flores(248,240);					
					flores(232,256);
					flores(264,256);					
					flores(248,272);
					
					iniciando=0;
				END
			END
			CASE 1:
				x += _cambio_en_x;
				y += _cambio_en_y;
			END
		END
		FRAME;
	END
END
/***************************/

/** Proceso overWorld_077
	Corresponde al escenario en la coordenada 7,7
	Este proceso se preocupa de administrar todo lo que corresponde a su escenario
	@param x,y : posicion del fondo */
PROCESS overWorld_077(x,y)
PRIVATE
	byte iniciando;
BEGIN
	z = 200;
	
	/* Se protege del SIGNAL S_KILL */
	signal_action(S_KILL,S_IGN);
	
	file = _id_fpg_ow;
	_file_durezas = file;
	graph = 077;	
	_mapa_durezas = graph+200;
	iniciando = 1;
	
	LOOP
		SWITCH(_cambiando_mapa)
			CASE 0:
				IF(iniciando==1)
					flores(136,64);
					flores(168,64);
					flores(152,80);
					flores(184,80);
					flores(136,96);
					flores(168,96);
					flores(152,112);
					flores(184,112);
					flores(86,160);
					flores(118,160);
					flores(102,176);
					flores(392,192);
					flores(424,192);
					flores(408,208);
					iniciando=0;
				END
			END
			CASE 1:
				x += _cambio_en_x;
				y += _cambio_en_y;
			END
		END
		FRAME;
	END
END
/***************************/

/** Proceso overWorld_085
	Corresponde al escenario en la coordenada 8,5
	Este proceso se preocupa de administrar todo lo que corresponde a su escenario
	@param x,y : posicion del fondo */
PROCESS overWorld_085(x,y)
PRIVATE
	byte iniciando;
BEGIN
	z = 200;
	
	/* Se protege del SIGNAL S_KILL */
	signal_action(S_KILL,S_IGN);
	
	file = _id_fpg_ow;
	_file_durezas = file;
	graph = 085;	
	_mapa_durezas = graph+200;
	
	iniciando = 1;
	LOOP
		SWITCH(_cambiando_mapa)
			CASE 0:
				IF(iniciando==1)
					flores(392,80);
					flores(424,80);
					flores(408,96);
					flores(440,96);					
					flores(8,160);
					flores(40,160);
					flores(72,160);
					flores(104,160);
					flores(136,160);
					flores(168,160);
					flores(200,160);
					flores(232,160);
					flores(264,160);
					flores(296,160);
					flores(328,160);
					flores(360,160);				
					flores(24,176);
					flores(56,176);
					flores(88,176);
					flores(120,176);
					flores(152,176);
					flores(184,176);
					flores(216,176);
					flores(248,176);
					flores(280,176);
					flores(312,176);
					flores(344,176);
					flores(376,176);			
					flores(392,240);
					flores(424,240);
					flores(408,256);
					flores(440,256);				
					flores(248,272);
					flores(264,288);
					flores(248,304);
					flores(264,322);
					iniciando=0;
				END
			END
			CASE 1:
				x += _cambio_en_x;
				y += _cambio_en_y;
			END
		END
		FRAME;
	END
END
/***************************/

/** Proceso overWorld_086
	Corresponde al escenario en la coordenada 8,6
	Este proceso se preocupa de administrar todo lo que corresponde a su escenario
	@param x,y : posicion del fondo */
PROCESS overWorld_086(x,y)
PRIVATE
	byte iniciando;
BEGIN
	z = 200;
	
	/* Se protege del SIGNAL S_KILL */
	signal_action(S_KILL,S_IGN);
	
	file = _id_fpg_ow;
	_file_durezas = file;
	graph = 086;	
	_mapa_durezas = graph+200;
	
	iniciando = 1;
	LOOP
		SWITCH(_cambiando_mapa)
			CASE 0:
				IF(iniciando==1)
					flores(264,0);
					flores(248,16);
					flores(232,32);
					flores(264,32);
					flores(248,48);
					flores(280,48);
					
					flores(248,160);
					flores(264,176);
					
					flores(248,288);
					flores(264,304);
					flores(248,320);
					iniciando=0;
				END
			END
			CASE 1:
				x += _cambio_en_x;
				y += _cambio_en_y;
			END
		END
		FRAME;
	END
END
/***************************/

/** Proceso overWorld_087
	Corresponde al escenario en la coordenada 8,7
	Este proceso se preocupa de administrar todo lo que corresponde a su escenario
	@param x,y : posicion del fondo */
PROCESS overWorld_087(x,y)
PRIVATE
	byte iniciando;
BEGIN
	z = 200;
	
	/* Se protege del SIGNAL S_KILL */
	signal_action(S_KILL,S_IGN);
	
	file = _id_fpg_ow;
	_file_durezas = file;
	graph = 087;	
	_mapa_durezas = graph+200;
	
	iniciando = 1;
	LOOP
		SWITCH(_cambiando_mapa)
			CASE 0:
				IF(iniciando==1)
					flores(248,0);
					flores(264,16);
					flores(248,32);
					flores(264,48);
					flores(392,160);
					flores(280,240);
					iniciando=0;
				END
			END
			CASE 1:
				x += _cambio_en_x;
				y += _cambio_en_y;
			END
		END
		FRAME;
	END
END
/***************************/
/* ---------------------- Fin Procesos y Funciones Privados ---------------------- */