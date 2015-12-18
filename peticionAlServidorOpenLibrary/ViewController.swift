//
//  ViewController.swift
//  peticionAlServidorOpenLibrary
//
//  Created by Marcos Suarez on 17/12/15.
//  Copyright © 2015 Marcos Suarez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldISBN: UITextField!
    
    @IBOutlet weak var visualDatosBusqueda: UITextView!
    
    var textoRecibido:String = ""
     
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func buscarISBN(isbn: String = "978-84-376-0494-7")
    {
        // definimos la dirección web
        let url = NSURL(string: "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)")
        
        // defino la sesion.
        let sesion = NSURLSession.sharedSession()
        
        // busco los datos de esa WEB.
        let datosURL = sesion.dataTaskWithURL(url!) { (datos, respuestaURL, errores) -> Void in
            
            // Si hay un error, lo notifico.
            if errores != nil {
                // No hay conexión a Internet presentar una alerta.
                self.mostrarAlerta(errores)
            } else {
                // recogo los datos recibidos.
                var texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                // informo si se encontró el libro
                if texto == "{}" { texto = "No se encontró la referencia"}
                
                // presento los datos recibidos.
                print("datos recibidos: \(texto!.description)")
                self.modificarTextoDatos(texto!.description)
            }
        }
        datosURL.resume()
    }
    
    func modificarTextoDatos(texto:String)
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.visualDatosBusqueda.text = texto
        })
        
    }
    
    // Alerta No hay Internet.
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
    
    // Se presionó BUSCAR.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == textFieldISBN
        {
            // Quitar el teclado.
            textFieldISBN.resignFirstResponder()
            // iniciar la busqueda.
            print(" Se introdujo:\(textField.text!)")
            buscarISBN(textField.text!)
        }
        return true
    }
    
    // Control de posibles caracteres.
    

}

