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
                print("Se produjo un error en la comunicación: \(errores)")
            }
            let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            
            // presento los datos recibidos.
            print("datos recibidos: \(texto!)")
            self.textoRecibido = texto! as String
        }
        datosURL.resume()
    }
    
    // Se presionó BUSCAR.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == textFieldISBN
        {
            // Quitar el teclado.
            
            // iniciar la busqueda.
            print(" Se introdujo:\(textField.text!)")
            buscarISBN(textField.text!)
        }
        print("Se presionó enter")
        return true
    }
    
    

}

