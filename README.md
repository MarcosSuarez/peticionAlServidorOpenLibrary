# peticionAlServidorOpenLibrary

##Tarea: Petición al servidor openlibrary.org


###Instrucciones:

En este entregable desarrollarás una aplicación usando Xcode que realice una petición a https://openlibrary.org/

Para ello deberás crear una interfaz de usuario, usando la herramienta Storyboard que contenga:
	1	Una caja de texto para capturar el ISBN del libro a buscar
	2	EL botón de "enter" del teclado del dispositivo deberá ser del tipo de búsqueda ("Search")
	3	El botón de limpiar ("clear") deberá estar siempre presente
	4	Una vista texto (Text View) para mostrar el resultado de la petición

Un ejemplo de URL para acceder a un libro es:

https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:978-84-376-0494-7

Su programa deberá sustituir el último código de la URL anterior (en este caso 978-84-376-0494-7) por lo que se ponga en la caja de texto
Al momento de presionar buscar en el teclado, se deberá mostrar los datos crudos (sin procesar) producto de la consulta en la vista texto en concordancia con el ISBN que se ingreso en la caja de texto
En caso de error (problemas con Internet), se deberá mostrar una alerta indicando esta situación
Sube tu solución a GitHub e ingresa la URL en el campo correspondiente

###Criterios de evaluación:

1.  ¿Existe una enlace a GitHub con el proyecto?
	-	Si (1 punto)
	-	No (0 puntos)

2. ¿El programa está hecho en Swift?
	-	Si (1 punto)
	-	No (0 puntos)

3. ¿Tiene un campo de texto que permite la captura del ISBN?
	-	Si (1 punto)
	-	No (0 puntos)

4. ¿Al hacer clic sobre el campo de texto, el teclado que emerge muestra la tecla de “Entrada” como “Búsqueda”?
	-	Si (1 punto)
	-	No (0 puntos)

5. La marca de "limpiar" en la caja de texto aparece todo el tiempo
	-	Si (1 punto)
	-	No (0 puntos)

6. En caso de falla en Internet, se muestra una alerta indicando ese problema
	-	Si (1 punto)
	-	No (0 puntos)

7. Se muestra el resultado en concordancia al ISBN ingresado
	-	Si (5 puntos)
	-	No (0 puntos)
