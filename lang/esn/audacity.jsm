;10/5/15 by Gary Campbell: moved UO_*Hlp messages to the same place in the current English file.
; Spanish messages for Audacity 2.0.0 script by Gary Campbell, translated by Fernando Gregoire last updated 14/9/2013.
/*
JAWS script for Audacity multitrack sound editor V2.0 or later (http://audacity.sourceforge.net).

    Copyright (C) 2012, 2013  Gary Campbell and Dang Manh Cuong.  All rights reserved.
    Copyright (C) 2014 Fernando Gregoire, for the Spanish translation. All rights reserved.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
    
    See the file copying.txt for details.
*/

; These are window names used to identify windows. (Should they be translated?)
Const
	WN_TOOLDOCK = "Bloqueo de herramientas", ; grandparent of toolbar buttons and selection bar controls
	WN_TRACKPANEL = "Panel de pista", ; window name of track table
	WN_SELECTION = "Selecci�n", ;window name of selection bar
	WN_TRANSPORT_TOOLBAR = "Reproducci�n", ; window name of Transport toolbar
	WN_EDIT_CHAINS = "Editar secuencias de comandos" ; name of the Edit Chains dialog

Const
	; These are used to announce different areas of the main window.  They should be translated.
	CS_Toolbars="Barras de herramientas",
	CS_SelectionBar="Barra de selecci�n",
	CS_TrackPanel="Panel de pista"

;For user options.  The text after the : should be translated, the text before must not be translated.
Const
	UO_ANNOUNCE_MESSAGES = "UOAnnounceMessages:Anunciar los mensajes de Audacity",
	UO_ANNOUNCE_TOOLBARS = "UOAnnounceToolbars:Anunciar las barras de herramientas",
	UO_ENTER_PAUSE = "UOEnterPause:ENTER pausa al reproducir/grabar"

Messages
; For user options.
@msgUO_AudacityOptionsHlp
Opciones espec�ficas para Audacity
@@
@msgUO_AnnounceMessagesHlp
Si se activa, lee mensajes para las operaciones con audio en Audacity.
@@
@msgUO_AnnounceToolbarsHlp
SI se activa, lee el nombre de las barras de herramientas cuando el foco se mueve de una barra de herramientas a otra.
@@
@msgUO_EnterPauseHlp
Si se activa, ENTER ejecuta Pausa en tanto se reproduce o se graba, y Control+ENTER env�a ENTER. De lo contrario, env�a ENTER a Audacity.
@@
EndMessages

;These are used to strip leading zeros from audio positions.
Const
	;The format of a position with value 0 containing thousands separators, not including the last 0, like the seconds format, with blanks removed
	csPositionGroupFmt = "000.00",
	;The word following the days in a position.
	csDays = "d�as",
	;The format of a position with value 0 containing hours, minutes, and seconds, up to but not including the decimal point, like the HH�MM�SS.sss  format, with blanks removed
	csPositionHHMMFmt = "00h00m00s",
	csGroupSep = ".", ; thousands separator character
	csDecimal = "," ; decimal point

Const
	;The key for pause
	csPauseKey="p"

Const
	CS_JawsGuide_LINK = "http://vip.chowo.co.uk/wp-content/uploads/jaws/Audacity-2.0.4-Guide.html", ;default URL to Audacity guide for JAWS
;This should reference the guide from which the Audacity Keys help message was taken.
CS_JawsGuide_Title = "Gu�a de Audacity 2.0.4 (en ingl�s)", 
CS_JawsGuide_Author = "David Bailes",
CS_JawsGuide_LINK_DISP = "enlace a la gu�a para JAWS" ;Name displayed in links list

Messages
@msgProgName
Audacity
@@

; Begins the hotkey help.
; %1 - string containing script version and date.
@msgScript_Ver
Combinaciones de teclas de JAWS con scripts versi�n %1, para Audacity 2.0.0 o posterior:

@@
@msgScriptKeyHelp

Para verbalizar la posici�n inicial de la selecci�n, pulse %keyfor (SaySelectionStart).
Para verbalizar la posici�n final de la selecci�n o la longitud, pulse %keyfor(SaySelectionEnd).
Para mover el foco a estos controles, pulse la tecla dos veces r�pidamente.
Para verbalizar el valor de posici�n del audio, pulse %keyfor(SayActiveCursor).
Para verbalizar el cursor activo mientras est� activo el del PC, pulse %keyfor(SayActiveCursor) dos veces r�pidamente.
Para aumentar la ganancia de la pista que tiene el foco, pulse %keyfor (MouseUp).
Para reducir la ganancia de la pista que tiene el foco, pulse %keyfor (MouseDown).
Para ajustar el posicionamiento est�reo hacia la izquierda, pulse %keyfor (MouseLeft).
Para ajustar el posicionamiento est�reo hacia la derecha, pulse %keyfor (MouseRight).
Mientras el foco est� en la ventana principal, las cuatro �ltimas teclas reemplazan los scripts de JAWS predeterminados para mover el rat�n. Si desea activar la funcionalidad original mientras est� en la ventana principal, active el cursor de JAWS.
Para activar o desactivar la voz, pulse %keyfor(MuteSynthesizer).
Para activar o desactivar los mensajes de aviso, pulse %keyfor (AnnounceOnOff)).  Esto duplica la opci�n Anunciar los mensajes de Audacity que se encuentra en Ajuste de opciones de JAWS.
Para m�s info, vea el archivo whats new.txt.
En una barra de herramientas, pulse %KeyFor (NextDocumentWindow) para moverse a la siguiente
En una barra de herramientas, pulse %KeyFor (PreviousDocumentWindow) para moverse a la anterior
Para leer el estado del programa (reproduciendo/pausado/grabando/detenido), pulse %KeyFor(SayAudacityState)
Para restablecer todas las opciones de los scripts a sus valores predeterminados, pulse %keyfor (ResetConfig)
Para conmutar entre las dos listas del di�logo Editar secuencias de comandos, pulse %keyfor (SwitchChainsList).
Para obtener ayuda sobre las teclas r�pidas de Audacity, pulse %keyfor(AudacityKeysHelp).
Para obtener la ayuda predeterminada sobre teclas r�pidas de Windows, pulse %keyfor(AudacityKeysHelp) dos veces r�pidamente.

Si est� activada la opci�n "ENTER pausa al reproducir/grabar", al pulsar %KeyFor(ENTER) en tanto se reproduce o graba, se env�a la tecla Pausa. Para ejecutar ENTER en esta situaci�n, utilice %KeyFor(CtrlEnter).

En algunos plugins VST comunes, como L1V:
Para llevar el foco al control de predefinidos, pulse %keyfor (VSTPreset).
Para cargar una predefinici�n existente, pulse %keyfor (VSTLoadPreset).
Para guardar la configuraci�n actual como predefinici�n, pulse %keyfor (VSTSavePreset).

Para cambiar la configuraci�n de los scripts para Audacity, pulse %KeyFor (AdjustJawsOptions).

@@
@msgPresetHotkeyHelp
Para llevar el foco a la opci�n predefinidos, pulse %keyfor (VSTPreset).
Para cargar una predefinici�n existente, pulse %keyfor (VSTLoadPreset).
Para guardar la configuraci�n actual como predefinici�n, pulse %keyfor (VSTSavePreset).

@@

;Spoken before loading the Audacity for JAWS web page.
@msgLoadingJawsGuide_L
cargando p�gina web de la Gu�a de Audacity para JAWS
@@
@msgLoadingJawsGuide_S
Gu�a para JAWS
@@

;Text of Audacity hotkey help that appears before the link to the Audacity guide for JAWS.
;We don't use a % substitution for the link because it must be added to the virtual buffer by a separate function call to make it a link.
;�1 -- Audacity guide title
;%2 Audacity guide author
;There is a newline before and after the guide link.
@msgAudacityHotKeyHelp1
Combinaciones de teclas predeterminadas para Audacity v2.0.4 (de la %1, por %2). Acceda a la gu�a (en ingl�s) en
@@
;Text of hotkey help following the link to the guide.  The first character of the message starts a new line.  I can't get a blank line at the start of the message.
@msgAudacityHotkeyHelp2


Combinaciones de teclas para comandos generales 
Abrir archivo de audio Ctrl + O 
Importar archivo de audio Ctrl + Shift + I 
Nuevo proyecto Ctrl + N 
Guardar proyecto Ctrl + S 
Di�logo de Preferencias Ctrl + P 
Moverse c�clicamente hacia adelante por Barras de herramientas, Tabla de pistas y Barra de selecci�n Ctrl + F6 
Moverse c�clicamente hacia atr�s por Barras de herramientas, Tabla de pistas y Barra de selecci�n Ctrl + Shift + F6 
Zoom normal Ctrl + 2 
Acercar Ctrl + 1 
Alejar Ctrl + 3 

Reproducci�n
Comando Combinaci�n de teclas 
Iniciar/Detener Barra Espaciadora 
Iniciar/Detener y mover cursor Shift + A 
Pausa/reanudar P 
Rebobinar per�odo corto durante reproducci�n Flecha Izquierda 
Adelantar per�odo corto durante reproducci�n Flecha Derecha 
Rebobinar per�odo largo durante reproducci�n Shift + Flecha Izquierda 
Adelantar per�odo largo durante reproducci�n Shift + Flecha Derecha 
Reproducir vista previa de corte/eliminaci�n C 
Reproducci�n en bucle Shift + Barra Espaciadora 
Di�logo Dispositivo de salida Shift + O 

Tabla de pistas
Comando Combinaci�n de teclas 
Moverse a pista anterior Flecha Arriba 
Moverse a pista siguiente Flecha Abajo 
Alternar selecci�n de pista con el foco Enter 
Seleccionar todas las pistas (y todo el audio) Ctrl + A 
Deseleccionar todas las pistas (y todos los rangos de tiempo) Ctrl + Shift + A 
Abrir el men� de la pista que posee el foco Tecla Aplicaciones o Shift + M 
Cerrar (Eliminar) la pista con el foco Shift + C 

Pista de audio
Comando Combinaci�n de teclas 
Cambiar ganancia de pista con el foco Shift + G 
Cambiar posicionamiento est�reo de pista con el foco Shift + P 
Silenciar/Desactivar silencio en la pista con el foco Shift + U 
Silenciar todas las pistas Ctrl + U 
Desactivar silencio en todas las pistas Ctrl + Shift + U 
Solo/Desactivar solo en la pista con el foco Shift + S 

Movimiento del cursor
Comando Combinaci�n de teclas 
Moverse al comienzo de las pistas (tiempo cero) Inicio 
Moverse al final de todo el audio Fin 
Moverse al comienzo del audio en las pistas seleccionadas J 
Moverse al final del audio en las pistas seleccionadas K 
Nueva posici�n del cursor en posici�n de reproducci�n ` 
Detener reproducci�n y mover cursor Shift + A 
Rebobinar per�odo corto Coma 
Adelantar per�odo corto Punto 
Rebobinar per�odo largo Shift + Coma 
Adelantar per�odo largo Shift + Punto 
Cursor un poquito a la izquierda Flecha Izquierda 
Cursor un poquito a la derecha Flecha Derecha 

Selecci�n de un rango de tiempo
Comando Combinaci�n de teclas 
Seleccionar un rango de tiempo que incluya todo el audio y seleccionar todas las pistas Ctrl + A 
Comienzo de selecci�n al principio de las pistas (tiempo 0) Shift + Inicio 
Final de selecci�n al final de todo el audio Shift + Fin 
Final de selecci�n en posici�n de reproducci�n + 
Comienzo de selecci�n al principio del audio en las pistas seleccionadas Shift + J 
Final de selecci�n al final del audio en las pistas seleccionadas Shift + K 
Para mover el final de la selecci�n un poquito a la derecha Shift + Flecha Derecha 
Para mover el final de la selecci�n un poquito hacia la izquierda Ctrl + Shift + Flecha Izquierda 
Para mover el comienzo de la selecci�n un poquito a la derecha Ctrl + Shift + Flecha Derecha 
Para mover el comienzo de la selecci�n un poquito a la izquierda Shift + Flecha Izquierda 

Edici�n
Comando Combinaci�n de teclas 
Deshacer Ctrl + Z 
Rehacer Ctrl + Y 
Borrar audio seleccionado Suprimir 
Cortar audio seleccionado Ctrl + X 
Copiar audio seleccionado Ctrl + C 
Pegar Ctrl + V 
Reemplazar audio seleccionado por silencio Ctrl + L 
Cerrar (Eliminar) pista con el foco Shift + C 

Grabaci�n
Comando Combinaci�n de teclas 
Grabar R 
A�adir grabaci�n Shift + R 
Pausa/reanudar P 
Detener Barra Espaciadora 
Di�logo Servidor de audio Shift + H 
Di�logo Dispositivo de entrada Shift + I 
Di�logo de cantidad de canales Shift + N 
@@

@msg_App_Start
Bienvenido a Audacity. Para mostrar la lista de teclas r�pidas de JAWS para Audacity, pulse %Keyfor(AudacityScriptkeyHelp).
@@

;Is the same text for Start and End acceptable in msgMoveSelection, msgMoveTo, and msgSelectedTo in all languages??
@msgStart
comienzo
@@

@msgEnd
final
@@

@msgLeft
izquierda
@@

@msgRight
derecha
@@

@msgSelectionStart
Comienzo de selecci�n
@@

@msgSelectionEnd
Final de selecci�n
@@

; %1 = "start" or "end" of selection, %2 = direction ("left" or "right").
@msgMoveSelection_L
Mover %1 de selecci�n a la %2
@@
@msgMoveSelection
%1 %2
@@

@MsgNoProject_l
No hay ning�n proyecto abierto.
@@

@msgNoProject_s
Sin proyecto
@@

@msgSelection
selecci�n
@@

@msgTrack
pista
@@

@msgAllAudio
todo el audio
@@

@msgSelectedTracks
pistas seleccionadas
@@

; %1 is where we move, like start or end, %2 is of what, e.g. track or selection.
@MSGMoveTo
Moverse al %1 de %2
@@

; %1 = where we are selectiog to, like start or end.
@MSGSelectedTo
Seleccionado hasta el %1
@@

@MsgStartOfFile
Seleccionado desde el principio del archivo.
@@

@MSgEndOfFile
Seleccionado hasta el final del archivo.
@@

@MSGDelete_l
Borrar audio seleccionado
@@

@MSGDelete_s
Borrar
@@

;Messages for program states.
@msgPause
pausado
@@
@msgPlay
reproduciendo
@@
@msgStop
detenido
@@
@msgRecord
grabando
@@

@msgDeselectAll
deseleccionar todo
@@

@MSGSelectAll
Seleccionadas todas las pistas
@@

@msgCloseFocusedTrack
cerrar pista con el foco
@@

@msgNotStopped_l
No se puede realizar esta operaci�n salvo que est� detenido.
@@
@msgNotStopped_s
no detenido.
@@

@msgNoTransportToolbar
No se encuentra la barra de herramientas de reproducci�n. Para que estos scripts funcionen, la barra de herramientas de reproducci�n debe habilitarse.
@@

@msgCopyAudio
Copiar audio seleccionado en portapapeles
@@

@msgCutAudio
cortar audio seleccionado en portapapeles
@@

@msgAnnounceOff
Anuncio de mensajes desactivado
@@

@msgAnnounceOn
Anuncio de mensajes activado
@@

@msgResetScriptOptions
Las opciones de los scripts se restablecieron a sus valores predeterminados
@@

@msgNoSelection
Para utilizar esta funci�n, debe habilitar la barra de herramientas de selecci�n
@@
@msg_Script_Version
Versi�n de los scripts para JAWS %1, para Audacity 2.0.0 o posterior.
@@
@MsgNoTrackSelected
Para utilizar esta funci�n, debe seleccionar la pista actual antes. Pulse enter para seleccionarla.
@@

;messages for warning dialog when import uncompress audio
@msgCopy
Hacer una copia de los archivos antes de editar (m�s seguro)
@@

@msgDirectEdit
Leer %los archivos directamente desde el original (m�s r�pido)
@@

@msgDoNotWarn
No volver a preguntar y utilizar siempre la opci�n seleccionada
@@

;Messages for the two lists in the Edit Chains dialog.
@msgChains
Secuencias de comandos
@@
@msgChainCommands
Secuencia de comandos
@@
EndMessages
