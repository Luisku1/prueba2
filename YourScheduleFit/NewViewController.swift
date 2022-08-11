//
//  NewViewController.swift
//  YourScheduleFit
//
//  Created by UNAM FCA 08 on 18/05/22.
//

import UIKit
import SafariServices

struct NoticiasModelo: Codable{
    
    let articles : [Noticia]
    
}

// las variables se deben llamar exactamente igual que en el API

struct Noticia : Codable {
    
    let title : String?
    let description : String?
    let url : String?
    let urlToImage : String?
    
}

class NewViewController: UIViewController {

    
    var articuloNoticias : [Noticia] = [ ]
    
    @IBOutlet weak var tablaNoticias: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // registrar la celda personalizada que hice
        tablaNoticias.register(UINib(nibName: "CeldaNoticiaTableViewCell", bundle: nil), forCellReuseIdentifier: "celdaNoticia")

        tablaNoticias.delegate = self
        tablaNoticias.dataSource = self
        
        // metodo para buscar las noticias
        buscarNoticias()
        
        func buscarNoticias(){
            let urlString = "https://newsapi.org/v2/top-headlines?apiKey=f0797ef3b62d4b90a400ed224e0f82b7&country=mx"
            
            // objeto del tipo URL creado de la manera segura
            if let url = URL(string: urlString){
                //objeto del tipo dato, la cual es la data necesaria para poder decodificar de manera segura
                if let data = try? Data(contentsOf: url) {
                    // decodificador que me permite extraer la informaciòn que necesito
                    let decodificador = JSONDecoder()
                    if let datosDecodificados = try? decodificador.decode(NoticiasModelo.self, from: data){
                        
                        articuloNoticias = datosDecodificados.articles
                        
                        tablaNoticias.reloadData()
                    }
                }
            }
        }
            
    }

}

extension NewViewController: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articuloNoticias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaNoticias.dequeueReusableCell(withIdentifier: "celdaNoticia", for: indexPath) as! CeldaNoticiaTableViewCell
        
        celda.tituloNoticiaLabel.text = articuloNoticias[indexPath.row].title
        celda.descripcionNoticiaLabel.text = articuloNoticias[indexPath.row].description
        
        // para mandar la imagen debo crear una imagen del tipo data
        if let url = URL(string : articuloNoticias[indexPath.row].urlToImage ?? ""){
            // si se crea la imagen vamos a crear un objeto del tipo dato
            if let imagenData = try? Data(contentsOf: url){
                celda.imagenNoticiaIV.image = UIImage(data: imagenData)
            }
                
        }
        
        return celda
    }
    
    // metodo que me sirve para identificar cuando un usuario selecciona una celda
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath : IndexPath){
        tablaNoticias.deselectRow(at: indexPath, animated: true)
        
        // cuando el usuario seleccione una celda voy a crear una url segura
        //uso de guard para crear una url segura
        guard let urlMostrar = URL(string: articuloNoticias[indexPath.row].url ?? "") else { return }
        
        // se crea un ViewController de Safari Services
        
        let VCSS = SFSafariViewController(url: urlMostrar)
        // presentamos el ViewCrontoller que acabamos de crear
        present(VCSS, animated: true)
    }
    
    
}
