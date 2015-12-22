14/11/2015  Scripts de JAWS para Audacity V2.0 (para versi�n de los scripts 2.0 6/10/15  22:55UTC) por Gary Campbell <campg2003@gmail.com> and Dang Manh Cuong <dangmanhcuong@gmail.com>

Este paquete de scripts de JAWS proporciona compatibilidad con Audacity 2.0.0 y posterior.

Caracter�sticas:
Combinaciones de teclas para leer comienzo de selecci�n, final o longitud de selecci�n y posici�n de audio, desde cualquier sitio de la ventana principal.
Combinaciones de teclas para mover el foco a los controles comienzo de selecci�n y final/longitud de selecci�n.
Muestra ayuda de teclas r�pidas de Audacity y de JAWS.
La Gu�a de Audacity para usuarios de JAWS, por David Bailes, es accesible desde la ayuda sobre teclas de Audacity (TeclaJAWS+w).
Lee las �reas de la ventana principal: Barras de herramientas, Panel de pista y Barra de selecci�n, a medida que el foco se mueve entre �stas.
Al mover el foco de una barra de herramientas a otra, lee el nombre de la barra de herramientas.
Cuando el foco est� en las barras de herramientas, al pulsar CTRL+TAB y Shift+CTRL+TAB se mueve respectivamente al primer control de la barra de herramientas siguiente y al �ltimo control de la barra de herramientas anterior.
TeclaJAWS+Suprimir lee el estado actual del programa: detenido, reproduciendo, reproducci�n pausada, grabando o grabaci�n pausada.
Cuando Audacity est� detenido y el foco se encuentra en el panel de pista, al pulsar las flechas izquierda y derecha lee la posici�n del cursor.
Indica cuando no hay ning�n proyecto abierto (no hay pistas en el panel de pista) para muchas operaciones.
Cuando est� activo el cursor del PC y el foco se encuentra en la ventana principal, los controles de ganancia y posicionamiento de las pistas ahora se pasan a la aplicaci�n. De lo contrario, ejecutan sus funciones predeterminadas para mover el rat�n.
Las combinaciones de teclas que extienden o contraen la selecci�n leen la posici�n (o longitud) nueva.
En muchos plugins VST, hay combinaciones de teclas que mueven el foco al control de Predefiniciones y activan los pertinentes para Guardar/Cargar predefiniciones.
Se leen los nombres y valores de controles en los di�logos de muchos plugins.  
Adem�s de �sta al espa�ol por Fernando Gregoire, hay una traducci�n del archivo L�AME al vietnamita. Gracias a Nguyen Hoang Giang por proporcionarla.  Est� en el archivo audacity_readme_vi.txt en la carpeta de instalaci�n dentro de la carpeta de archivos de programa.
Puede ir a una pista por su n�mero. Tambi�n puede mover una pista a una posici�n espec�fica por un n�mero. Tambi�n puede fijar una "marca" en una pista y volver all� m�s tarde, o move o una pista all�.
Al mover una pista mediante el teclado se proporciona respuesta de voz. (Consulte m�s abajo).
El instalador ahora admite varios idiomas.

Cuando se graba o reproduce, la tecla ENTER ejecuta pausa/reanudar. En este caso, presionar CTRL+ENTER env�a ENTER. Esto me gusta porque, si no est� con las manos en el teclado, la tecla ENTER es m�s f�cil de encontrar que "p". Esto se puede desactivar con una opci�n en Ajuste de opciones de JAWS. Pru�belo y h�ganos saber si le funciona y le gusta.  

Se puede obtener la versi�n de los scripts pulsando TeclaJAWS+CTRL+V (dos veces r�pidamente para mostrarla en el visualizador virtual) y tambi�n aparece en la ayuda de teclas r�pidas de JAWS.

La URL para acceder a la Gu�a de Audacity para usuarios de JAWS se puede modificar mediante los scripts pulsando Control+Shift+j. Esto abre un di�logo que contiene un cuadro de edici�n con la URL. Actual�cela o reempl�cela y pulse Aceptar.

Para instalar: 
Coloque el instalador en una carpeta de su m�quina.
Ejec�telo para instalar los archivos. Tambi�n le permite elegir dentro de qu� versiones de JAWS instalar y si instalar para el usuario actual o todos los usuarios. Si elige el tipo de instalaci�n completa, podr� quitarla desde Agregar o Quitar Programas y crear� una carpeta en la carpeta Archivos de programa (Program Files) para almacenar el desinstalador. Si elige el tipo de instalaci�n S�lo Scripts, no ser� quitable desde Agregar o Quitar Programas, no crear� ninguna carpeta en la carpeta Archivos de programa (Program Files) ni entradas del registro.  
Si elige el tipo de instalaci�n S�lo Scripts, los archivos L�AME y Novedades se instalar�n en la carpeta de scripts de JAWS de cada versi�n, y What's new.txt se llamar� audacity_whatsnew.txt. (En una instalaci�n de S�lo Scripts el archivo L�AME en vietnamita no se instalar�).
El instalador compilar� el paquete de scripts en cada versi�n de JAWS.
Si desea modificar el instalador o simplemente tiene curiosidad de c�mo funciona, puede instalar el c�digo fuente del instalador seleccionando el tipo de instalaci�n Personalizada y eligiendo el componente Instalar c�digo fuente del Instalador.


Los scripts poseen varias opciones que controlan algunas de sus caracter�sticas, a las cuales se puede acceder pulsando TeclaJAWS+v. En versiones de JAWS anteriores a la 13 estas opciones se almacenan en el archivo audacity.jsi en la carpeta PersonalizedSettings de la instalaci�n de JAWS. En versiones posteriores a la 13 se almacenan en audacity.jcf, en la secci�n NonJCFOptions. Si actualiza desde una versi�n de JAWS anterior a la 13 a la 13 o posterior la configuraci�n de audacity.jsi no se transfiere, de modo que tendr� que volver a establecerla.


Ir a pistas y moverlas.
Es posible moverse a una pista por su n�mero, mover una pista a una posici�n espec�fica por un n�mero y recordar la posici�n de una pista para regresar all� m�s tarde, o para mover una pista all�. Asimismo, si mueve una pista con el teclado se brinda respuesta de voz. Esta caracter�stica s�lo funciona en Audacity 2.1.1 y posterior, y para funcionar requiere cierta configuraci�n en Audacity. Debe asignar el comando de Audacity Mover la Pista Activa hacia Arriba a Control+Shift+FlechaArriba y Mover la Pista Activa hacia Abajo a Control+Shift+FlechaAbajo. Para hacerlo:
1. En Audacity abra Preferencias (CTRL+p) y vaya a la categor�a Teclado (pulse t).
2. Tabule al cuadro de edici�n y escriba "mover activa" (usando la presentaci�n en �rbol).
3. Tabule a la presentaci�n en �rbol y busque Mover la pista activa hacia abajo.
4. Presione TAB hasta el campo atajo y pulse Control+Shift+FlechaAbajo.
5. Presione TAB hasta el bot�n Establecer y pulse ESPACIO para activarlo.
6. Pulse Shift+TAB dos veces para regresar a la presentaci�n en �rbol.
7. Busque el comando Mover la pista activa hacia arriba y as�gnele Control+Shift+FlechaArriba del mismo modo.
8. Tabule hasta Aceptar y pulse la BARRA ESPACIADORA.

Si desea utilizar teclas distintas, tendr� que cambiar las asignaciones en audacity.jkm.

Esta versi�n del framework del instalador contiene el primer esbozo de compatibilidad con varios idiomas. Ahora trata los pares versi�n/idioma como anteriormente trataba las versiones, con lo que ahora la presentaci�n en lista de selecci�n de versiones ahora muestra entradas como 16.0/enu. Actualmente se admiten ingl�s y espa�ol. Tenga en cuenta que actualmente la estructura de traducci�n de JAWS 17 se desconoce y, por lo tanto, es probable que no se admita.


Problemas:

Esta versi�n agrega la capacidad de silenciar en la vista previa de efectos como Amplificar. A veces esto no se desactiva. Si sucede esto, conmutar el foco a un sitio distinto que Audacity y volver lo desactivar�.

Los campos de posici�n a veces no se acortan. Esto sucede porque la funci�n de JAWS GetWindowText devuelve tan s�lo los n�meros sin h, m, :, etc. No sabemos lo que lo provoca. He podido corregirlo saliendo de Audacity y reinici�ndolo. Esto se observ� con JAWS 10, 15 y 16.

Un efecto colateral de que ENTER pause al grabar o reproducir es que no puede utilizar ENTER para seleccionar/deseleccionar pistas mientras graba o reproduce. Esto tambi�n afecta al ingreso a una etiqueta mientras graba o reproduce. En este caso, la tecla ENTER agrega "p" en la etiqueta en lugar de terminarla. Para enviar ENTER en este caso, utilice Control+ENTER.

Al escribir una etiqueta en una pista de etiqueta, JAWS acostumbra a leer las funciones de Audacity que se efect�an mediante letras, aun cuando las letras se escriben en la etiqueta. Si utiliza m�todos est�ndares para la creaci�n de etiquetas, ahora suprimimos este comportamiento. Esta caracter�stica se activa con las combinaciones de teclas Control+b y Control+m y se desactiva al pulsar ENTER. (Tambi�n se desactiva si se mueve con las flechas a otra pista o el foco se mueve fuera del panel de pista). No se activar� si se mueve a la pista de etiqueta con las flechas y comienza a escribir. Si cambia las asignaciones de teclas est�ndares de estos comandos, tambi�n tendr� que cambiar audacity.jkm en concordancia.

Cuando el foco est� en una pista de etiqueta, al pulsar TAB se intentar� leer la etiqueta "actual". Esto se hace buscando texto en un fondo blanco. Esto est� pensado para dar respuesta de voz al tabular a una etiqueta en una pista de etiqueta. No siempre funciona, en especial con un mont�n de etiquetas. En realidad, esta capacidad est� activa en cualquier momento en que el foco se encuentre en el panel de pista.

Si redefine la tecla ENTER del teclado num�rico y configura JAWS para tratar las teclas del teclado extendido por separado, ambas teclas ENTER se asignar�n a la tecla ENTER para escribir. Si esta caracter�stica no le gusta, la puede desactivar agregando un punto y coma en las l�neas para ENTER, NumPadEnter y Control+ENTER en audacity.jkm, y quitando los punto y comas en las l�neas que contienen /* y */ antes y despu�s de los scripts Enter y CtrlEnter en audacity.jss.  

Los scripts se desarrollaron con Audacity 2.0.3, 2.0.4, 2.0.5, 2.1.0, y 2.1.1 y JAWS 10.0.1178u en Windows XP SP3, y JAWS 13-16 en un port�til que ejecuta Windows 7, 8.1 y 10. Probablemente funcione en cualquier versi�n de JAWS posterior a la 5.0, aunque puede que las opciones de Audacity en Ajuste de la Cantidad de Informaci�n de JAWS no se vean muy bien. El desarrollo reciente se ha hecho con JAWS 16 en Windows 10. Aunque sigue habiendo compatibilidad con versiones de JAWS anteriores, el c�digo actual no se ha probado con �stas. En este momento no hay compatibilidad espec�fica con braille.

Compatibilidad con Varios Idiomas
Los mensajes y constantes de cadenas de los scripts est�n en audacity.jsm para facilitar la traducci�n. Fernando Gregoire ha colaborado con una traducci�n al espa�ol. �Gracias!

Los mensajes del instalador ahora pueden traducirse. El texto de los mensajes ahora se ha separado del c�digo del instalador, de modo que se puedan preparar conjuntos de mensajes para cada idioma. Los �nicos idiomas que se admiten actualmente son ingl�s y espa�ol.

Me interesar�an comentarios sobre los scripts y sugerencias de mejoras, pero no puedo prometer ninguna actualizaci�n.

Aqu� va el texto de la ayuda de teclas r�pidas de JAWS:
Combinaciones de teclas de JAWS con scripts versi�n 2.0 12/05/15  21:15UTC, para Audacity 2.0.0 o posterior:
Para verbalizar la posici�n inicial de la selecci�n, pulse Alt+AcentoGrave.
Para verbalizar la posici�n final de la selecci�n o la longitud, pulse Alt+M�s.
Para mover el foco a estos controles, pulse la tecla dos veces r�pidamente.
Para verbalizar el valor de posici�n del audio, pulse Alt+Suprimir.
Para verbalizar el cursor activo mientras est� activo el del PC, pulse Alt+Suprimir dos veces r�pidamente.
Para aumentar la ganancia de la pista activa, pulse Alt+May�scula+Flecha Arriba.
Para reducir la ganancia de la pista activa, pulse Alt+May�scula+Flecha Abajo.
Para ajustar el posicionamiento est�reo hacia la izquierda, pulse Alt+May�scula+Flecha Izquierda.
Para ajustar el posicionamiento est�reo hacia la derecha, pulse Alt+May�scula+Flecha Derecha.
Mientras el foco est� en la ventana principal, las cuatro �ltimas teclas reemplazan los scripts de JAWS predeterminados para mover el rat�n. Si desea activar
la funcionalidad original mientras est� en la ventana principal, active el cursor de JAWS.

Para ir a una pista por su n�mero, pulse Tecla JAWS+a, i.
Para mover la pista actual a una posici�n de pista por su n�mero, pulse Tecla JAWS+a, m.
Para marcar la pista actual, pulse Tecla JAWS+a, k.
Para ir a la pista marcada, pulse Tecla JAWS+a, May�scula+i.
Para ir a la pista marcada y marcar la pista de partida, pulse Tecla JAWS+a, x.
Para mover la pista actual a la posici�n de la pista marcada y fijar la marca en la pista actual, pulse Insert+a, May�scula+m.

Para activar o desactivar la voz, pulse May�scula+Insert+S.
Para activar o desactivar los mensajes de aviso, pulse Control+`).  Esto duplica la opci�n Anunciar los mensajes de Audacity que se encuentra en Ajuste
de opciones de JAWS.
Para m�s info, vea el archivo whats new.txt.
En una barra de herramientas, pulse Control+Tab para moverse a la siguiente
En una barra de herramientas, pulse Control+May�scula+Tab para moverse a la anterior
Para leer el estado del programa (reproduciendo/pausado/grabando/detenido), pulse Tecla JAWS+Suprimir
Para restablecer todas las opciones de los scripts a sus valores predeterminados, pulse May�scula+Control+`
Para conmutar entre las dos listas del di�logo Editar secuencias de comandos, pulse F6.
Para obtener ayuda sobre las teclas r�pidas de Audacity, pulse Insert+w.
Para obtener la ayuda predeterminada sobre teclas r�pidas de Windows, pulse Insert+w dos veces r�pidamente.

Si est� activada la opci�n "ENTER pausa al reproducir/grabar", al pulsar Enter en tanto se reproduce o graba, se env�a la tecla Pausa. Para ejecutar ENTER
en esta situaci�n, utilice Control+Enter.

En algunos plugins VST comunes, como L1V:
Para llevar el foco al control de predefinidos, pulse Alt+P.
Para cargar una predefinici�n existente, pulse Alt+C.
Para guardar la configuraci�n actual como predefinici�n, pulse Alt+G.

Si Silenciar en Vista Previa est� activado y aprieta el bot�n Vista Previa de un efecto, a veces el silencio resultante de la vista previa no se desactiva.
Esto provocar� p�rdida de la respuesta de voz como consecuencia de cambios del foco. Puede corregirlo cambiando a un sitio diferente de Audacity y volviendo
despu�s.

Para cambiar la configuraci�n de los scripts para Audacity, pulse .

Para cambiar la URL de la Gu�a de JAWS para Audacity, pulse May�scula+Control+J

Lista de Teclas r�pidas de JAWS
Para cerrar este mensaje, pulse ESCAPE. 

�Disfrute!
