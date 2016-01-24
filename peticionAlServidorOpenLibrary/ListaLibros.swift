//
//  ListaLibros.swift
//  peticionAlServidorOpenLibrary
//
//  Created by Marcos Suarez on 2/1/16.
//  Copyright © 2016 Marcos Suarez. All rights reserved.
//

import UIKit
import CoreData

var contextoBaseDatos: NSManagedObjectContext? = nil

struct InfoLibro {
    let titulo: String
    let ISBN: String
    let autores: String
    let imagen: UIImage
    
    init(titulo: String, ISBN: String, autores:String, imagen: UIImage)
    {
        self.titulo = titulo
        self.ISBN = ISBN
        self.autores = autores
        self.imagen = imagen
    }
}

// Lista con los libros.
//var listaDeLibros = [InfoLibro]()

class ListaLibros: UITableViewController {
    
    var listaDeLibros = [InfoLibro]()
    
    @IBAction func alPresionarBotonPlus(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("irADetalle", sender: sender)
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Defino de donde se saca el contexto.
        contextoBaseDatos = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    override func viewWillAppear(animated: Bool) {
        buscarLibros()
    }
    
    func buscarLibros() {
        // limpio la lista de libros.
        listaDeLibros.removeAll()
        // busco la lista de libros.
        let librosEntidad = NSEntityDescription.entityForName("Libro", inManagedObjectContext: contextoBaseDatos!)
        let peticion = librosEntidad?.managedObjectModel.fetchRequestTemplateForName("peticionLibros")
        
        do {
            
            let arregloObjetosLibros = try contextoBaseDatos?.executeFetchRequest(peticion!)
            
            for cadaObjetoLibro in arregloObjetosLibros!
            {
                let ponerTitulo = cadaObjetoLibro.valueForKey("titulo") as! String
                let ponerISBN = cadaObjetoLibro.valueForKey("isbn") as! String
                let ponerImagen = UIImage(data: cadaObjetoLibro.valueForKey("imagen") as! NSData)
                var ponerNombresAutores = ""
                let listadoAutores = cadaObjetoLibro.valueForKey("escritoPor") as! Set<NSObject>
                // busco todos los autores.
                
                
                let libroAgregar = InfoLibro(titulo: ponerTitulo, ISBN: ponerISBN, autores: ponerNombresAutores, imagen: ponerImagen!)
                
                listaDeLibros.append(libroAgregar)
            }
            
        } catch {
            print("NO encontré la petición a Libros")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Regresa el número de secciones.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Regresa el número de filas.
        return listaDeLibros.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Celda", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = listaDeLibros[indexPath.row].titulo
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "irADetalle" && sender is UITableViewCell
        {
            // Creo el nuevo ViewController
            let mostrarDatosLibrosVC = segue.destinationViewController as! ViewController
            
            let indiceTabla = tableView.indexPathForSelectedRow
            
            // Presento el titulo del Navegador.
            mostrarDatosLibrosVC.title = "BASE DE DATOS"
            // Quito la opción de realizar modificaciones en el campoTexto.
            mostrarDatosLibrosVC.sePuedeBuscar = false
            // Agregamos la información del libro.
            mostrarDatosLibrosVC.infoTitulo = listaDeLibros[indiceTabla!.row].titulo
            mostrarDatosLibrosVC.infoISBN = listaDeLibros[indiceTabla!.row].ISBN
            mostrarDatosLibrosVC.autores = listaDeLibros[indiceTabla!.row].autores
            mostrarDatosLibrosVC.imagenPortada = listaDeLibros[indiceTabla!.row].imagen
        }
    }
}
