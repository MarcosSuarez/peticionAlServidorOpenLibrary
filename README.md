# peticionAlServidorOpenLibrary

## Petición al servidor openlibrary.org


###Instrucciones:

Aplicación iOS 9 en Xcode 7 que realiza una petición a https://openlibrary.org/ y almacena en los datos usando COREDATA.

En la interfaz de usuario, observaras:

	1	Una Tabla con el título de TODOS los libros buscados.
		1.1.-	Al presionar + en la tabla te lleva a la Vista de Busqueda de Libros.
		1.2.-	Al presionar el título te muestra todos los detalles.
		
	2	Vista Busqueda de Libros encontrarás:
		2.1.-	Una caja de texto para capturar el ISBN del libro a buscar
		2.2.-	EL botón de "enter" del teclado del dispositivo deberá ser del tipo de búsqueda ("Search")
		2.3.-	El botón de limpiar ("clear") deberá estar siempre presente
		2.4.-	Una vista con el resultado de la petición (Título, Autores, Imagen) 

Un ejemplo de URL para acceder a un libro es:

https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:xxxxxxx

## Ejemplos de busqueda:
	- 978 84 376 0494 7
	- 978 84 362 6085 4
	- 094 51 792 86
	- 959 20 947 64
	- 843 62 346 18
	- 848 31 916 87

