//
//  ViewController.swift
//  peticionAlServidorOpenLibrary
//
//  Created by Marcos Suarez on 17/12/15.
//  Copyright © 2015 Marcos Suarez. All rights reserved.
//
//   https://openlibrary.org/

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Variables visuales.
    
    @IBOutlet weak var textFieldISBN: UITextField!
    
    @IBOutlet weak var visualDatosBusqueda: UITextView!
    
    @IBOutlet weak var campoTitulo: UILabel!
    
    @IBOutlet weak var imagenLibro: UIImageView!
    
    // MARK: Variables Control Datos.
    
    var infoISBN:String = ""
    var infoTitulo: String = "titulo del libro"
    var autores = "Autores:\n"
    var imagenPortada = UIImage(named: "logo_OL-lg")
    var sePuedeBuscar: Bool = true
    
    // MARK: Ciclos del View
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldISBN.text = infoISBN
        campoTitulo.text = infoTitulo
        visualDatosBusqueda.text = autores
        imagenLibro.image = imagenPortada
    }

    override func viewDidAppear(animated: Bool) {
        textFieldISBN.enabled = sePuedeBuscar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func reseteoDatos()
    {
        textFieldISBN.text = infoISBN
        campoTitulo.text = "buscando titulo.."
        visualDatosBusqueda.text = "Autores:\n"
        imagenLibro.image = UIImage(named: "logo_OL-lg")
    }
    
    // MARK: Busqueda de  LIBRO.
    
    func buscarISBN(isbn: String)
    {
        // Borrar datos viejos.
        reseteoDatos()
        
        // definimos la dirección web
        let url = NSURL(string: "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)")
        
        // defino la sesion.
        let sesion = NSURLSession.sharedSession()
        
        // busco los datos de esa WEB.
        let datosURL = sesion.dataTaskWithURL(url!) { (datos, respuestaURL, errores) -> Void in
            
            // devolver al hilo principal
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if errores == nil {
                    // recogo los datos recibidos.
                    let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                    
                    // informo si se encontró el libro
                    if texto == "{}" {
                        self.campoTitulo.text = "No se encontró la referencia"
                    }
                    else { self.filtrarDatosEnJSON(datos!, isbn: isbn) }
                }
                else {
                    // No hay conexión a Internet presentar una alerta.
                    self.mostrarAlerta(errores)
                }
            })
        }
        datosURL.resume()
    }
    
    // Recibe la data y filtra la información.
    func filtrarDatosEnJSON(datos:NSData, isbn:String)
    {
        do {
            // convierto los datos al formato JSON.
            let datosEnJson = try NSJSONSerialization.JSONObjectWithData(datos, options: NSJSONReadingOptions.MutableLeaves)
            // paso el objeto completo a diccionario.
            let jsonAdiccionario = datosEnJson as! NSDictionary
            
            // En el diccionario selecciono el objeto que me interesa.
            let objetoISBN = jsonAdiccionario["ISBN:\(isbn)"] as! NSDictionary
            
            // creo nueva entidad Libro.
            let nuevoLibroEntidad = NSEntityDescription.insertNewObjectForEntityForName("Libro", inManagedObjectContext: contextoBaseDatos!)
            
            // Creo una variable donde guardar los autores.
            var autoresEntidades = Set<NSObject>()
            
            // Título del libro.
            infoTitulo = objetoISBN["title"] as! String
            
            if infoTitulo != "" { self.campoTitulo.text = "\(infoTitulo)" }
            else { self.campoTitulo.text = "No se encontró el titulo"}
            
            // Arreglo que contiene los autores, si existen...
            if let objetoAutores = objetoISBN["authors"] as? NSArray
            {
                // busco los nombres de todos los autores
                for item in objetoAutores
                {
                    let diccionarioConDatos = item as! Dictionary<String,String>
                    let autor = diccionarioConDatos["name"]!
                    
                    // Si el autor NO existe lo agrego a la base de Datos.
                    
                    // 1. Creo un objeto del tipo Autor.
                    let hayUnAutorEntidad = NSEntityDescription.entityForName("Autor", inManagedObjectContext: contextoBaseDatos!)
                    // 2. Creo la petición para buscar.
                    let peticion = hayUnAutorEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("peticionAutor", substitutionVariables: ["nombre" : autor])
                    
                    // 3. busco si realmente existe el nuevo autor.
                    do {
                        let entidadAutorEncontrada = try contextoBaseDatos?.executeFetchRequest(peticion!) as! [NSObject]
                        
                        // Si la consulta se encontró, el autor existe.
                        if entidadAutorEncontrada.count > 0 {
                            // lo agrego a la lista de autores.
                            autoresEntidades.insert(entidadAutorEncontrada.first!)
                        } else {
                            // No existe el autor, lo agrego a la base de datos.
                            let nuevoAutor = NSEntityDescription.insertNewObjectForEntityForName("Autor", inManagedObjectContext: contextoBaseDatos!)
                            nuevoAutor.setValue(autor, forKey: "nombre")
                            // lo agrego a la lista de autores.
                            autoresEntidades.insert(nuevoAutor)
    
                        }
                    } catch {
                        print("Error al buscar el nombre del autor del libro")
                    }

                    autores += "\(autor) \n"
                }
            }
            self.visualDatosBusqueda.text = autores
            
            // busco la portada del libro, si existe..
            if  let objetoUrlsImagenes = objetoISBN["cover"],
                let urlImagen = objetoUrlsImagenes["medium"]
            {
                let urlDelLibro = NSURL(string: urlImagen as! String)
                imagenPortada = UIImage(data: NSData(contentsOfURL: urlDelLibro!)!)!
                
                imagenLibro.image = imagenPortada
            }
            else { imagenLibro.image = UIImage(named: "logo_OL-lg") }
            
            // Agrego la info en la estructura del libro.
            //let datosDelLibro = InfoLibro(titulo: infoTitulo, ISBN: infoISBN, autores: autores, imagen: imagenPortada!)
            // Guardo el libro en la lista.
            //listaDeLibros.append(datosDelLibro)
            
            
            // defino el ISBN
            nuevoLibroEntidad.setValue(infoISBN, forKey: "isbn")
            // defino el Titulo.
            nuevoLibroEntidad.setValue(infoTitulo, forKey: "titulo")
            // defino La imagen
            nuevoLibroEntidad.setValue(UIImagePNGRepresentation(imagenLibro.image!), forKey: "imagen")
            // defino los Autores.
            nuevoLibroEntidad.setValue(autoresEntidades, forKey: "escritoPor")
            // Guardo la información en la base de Datos.
            do {
                try contextoBaseDatos?.save()
            } catch {
                print("Problemas guardando la base de datos")
            }
            
            
        } catch {
            self.visualDatosBusqueda.text = "Existe un problema con la estructura de los datos"
        }
    }
    
    
    // MARK: Alerta No hay Internet.
    func mostrarAlerta(errorRecibido: NSError?)
    {
        // Creo la Alerta.
        let alerta = UIAlertController(title: "Problemas con la conexión", message: errorRecibido!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        
        // Defino que hacer cuando se presiona el botón.
        let accionAlerta = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (accionArealizar) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        // Agrego al controlador la acción.
        alerta.addAction(accionAlerta)
        
        // presento la alerta.
        self.presentViewController(alerta, animated: true) { () -> Void in
            print("Se produjo un error en la comunicación:")
            print("Codigo: \(errorRecibido!.code)")
            print("Descripción: \(errorRecibido!.localizedDescription)")
            print("Razón: \(errorRecibido!.localizedFailureReason)")
            print("Descripción: \(errorRecibido!.localizedRecoverySuggestion)")
        }
    }

    // MARK: Funciones del Teclado
    
    // Se presionó BUSCAR.
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == textFieldISBN
        {
            // Quitar el teclado.
            textFieldISBN.resignFirstResponder()
            // Guardar ISBN
            infoISBN = textField.text!
            
            var existeLibro:Bool =  false
            
            // Buscar si existe el libro.
            
            let libroEntidad =  NSEntityDescription.entityForName("Libro", inManagedObjectContext: contextoBaseDatos!)
            let peticion = libroEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("peticionLibro", substitutionVariables: ["isbn" : infoISBN])
            
            do {
                let libroEntidad2 = try contextoBaseDatos?.executeFetchRequest(peticion!)
                
                // Verifico si la consulta se encontró
                if libroEntidad2?.count > 0 {
                    existeLibro = true
                    // recupero los datos.
                    print("Leyendo de la base de Datos")
                    textFieldISBN.text = libroEntidad2?.first!.valueForKey("isbn") as? String
                    campoTitulo.text = libroEntidad2?.first!.valueForKey("titulo") as? String
                    // muestro la imagen.
                    imagenLibro.image = UIImage(data: libroEntidad2?.first!.valueForKey("imagen") as! NSData)
                    // busco los autores y los muestro.
                    let listadoDeAutores = libroEntidad2!.first!.valueForKey("escritoPor") as! Set<NSObject>
                    var totalDeAutores = ""
                    for cadaAutor in listadoDeAutores
                    {
                        totalDeAutores += cadaAutor.valueForKey("nombre") as! String + "\n"
                    }
                    
                    visualDatosBusqueda.text = "Autores: \n" + totalDeAutores
                }
            } catch {
                
            }
            
            /* 
            
            --- Ya no se necesita se busca directamente en la base de datos. -----

            for libro in listaDeLibros {
                if libro.ISBN == infoISBN {
                    print("presento libro existente")
                    textFieldISBN.text = libro.ISBN
                    campoTitulo.text = libro.titulo
                    visualDatosBusqueda.text = libro.autores
                    imagenLibro.image = libro.imagen
                    existeLibro = true
                    break
                }
            }
            */
            
            if !existeLibro {
                // iniciar la busqueda.
                print("inicio busqueda")
                buscarISBN(textField.text!)
            }
        }
        return true
    }
    
    // Control de posibles caracteres.
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        switch string {
        case "0","1","2","3","4","5","6","7","8","9","-","": return true
        default: return false
        }
    }
    
    // Quitar teclado si se toca en cualquier sitio
    @IBAction func toqueEnView(sender: UITapGestureRecognizer) {
        
        textFieldISBN.resignFirstResponder()
    }

}