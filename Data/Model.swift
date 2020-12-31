//
//  Model.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 27/12/20.
//

import Foundation
import UIKit

public class Model : NSObject, NSCoding{

    let NAME_OF_FOLDER_IN_BUNDLE = "beerApp-data"
    let NAME_OF_BEER_FILE_IN_BUNDLE = "data-of-beers"
    let NAME_OF_PRODUCER_FILE_IN_BUNDLE = "data-of-producers"
    
    let NAME_OF_FOLDER_IN_DOCUMENTS = "Supporting Files"//supportingfiles? carpeta contenedorta //Supporting Files //DataOfBeerApp
    let NAME_OF_PRODUCERS_FILE_IN_DOCUMENTS = "FileOfProducers"// archivo binario

    
    public var producers:[Producer]
    public var allBeers:[Beer]
    var producersNamed = [String:Producer]()
    private let dfm = FileManager.default
    
    
    public override init() {
        
        let DOCS_URL = documentsURL()// RGB Tools
        
        let URL_OF_FOLDER_IN_DOCUMENTS =
            DOCS_URL.appendingPathComponent(NAME_OF_FOLDER_IN_DOCUMENTS)
        
        let URL_OF_PRODUCERS_BINARY_FILE = URL_OF_FOLDER_IN_DOCUMENTS.appendingPathComponent(NAME_OF_PRODUCERS_FILE_IN_DOCUMENTS).appendingPathExtension("bin")
        
        producers = [Producer]()
        allBeers = [Beer]()
        super.init()
        var readBinProducers = false//existen archivos de un arranque anterior?
        var importProducers = false
        var importBeers = false
        
        
        //COMIENZO DE LECTURA
        print("INTENTO DE CARGA DE BINARIO")
        readBinProducers = readProducersInfosFromDocuments(url: URL_OF_PRODUCERS_BINARY_FILE) //Intento de lectura de archivo binario La app ya fue arrancada
        //First boot readBinProducers = false
        print(URL_OF_PRODUCERS_BINARY_FILE)
        
        /*
         Print for debug
         
         */
        
        
        if !readBinProducers{//if first boot
          
            importProducers = importProducersFromCsv("defaultbeer", folder: NAME_OF_FOLDER_IN_DOCUMENTS)
            //importProducers = importProducersFromCsv("defaultbeer", folder: NAME_OF_FOLDER_IN_BUNDLE)
            
            
            producers.forEach{ producersNamed.updateValue($0, forKey: $0.nameProducer)}
            importBeers = importBeersFromCsv(NAME_OF_PRODUCER_FILE_IN_BUNDLE, folder: NAME_OF_FOLDER_IN_BUNDLE)
            print("#Read producers --> \(importProducers)")
            print("#Read beers --> \(importBeers)")
            assert(importProducers && importBeers)
            producers.forEach{ $0.beersCollect = [Beer]()}
            allBeers.forEach{producersNamed[$0.producerBeer]?.beersCollect?.append($0)}
            
            
        }
        var index = 0
        self.producers.removeAll()
        self.producersNamed.forEach{self.producers.append($0.value); index = index+1}
        
        /*
        print("********************")
        print(producers.count)
        print(producers[0].nameProducer)
        print(producers[0].beersCollect?[].nameBeer)
        */
        producers.forEach{$0.beersCollect?.sort(by: {($0.nameBeer) < ($1.nameBeer)})}
        print("********************")
        print(producers.count)

        
    }//end init model
    
    
    func importBeersFromBundle(_ file:String, folder:String)->Bool{
       
        guard
            let lines = bundleReadAllLinesFromFile(file,inFolder: folder, withExtension: "txt"),
            !lines.isEmpty
            else {
            return false
        }
        let importedBeers = lines.compactMap{Beer($0, "\t") }
        
        if !importedBeers.isEmpty{
            
            self.allBeers = importedBeers//siguiente mal¿
            return true
            
        }else{
            return false
        }
        
    }
    
    func importBeersFromCsv(_ file:String, folder:String)->Bool{
        print("#SALTO A IMPORT FROM CSV BEERS")
        let path = Bundle.main.path(forResource: "defaultbeer", ofType: "csv")
        let line = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        guard
            //let lines = bundleReadAllLinesFromFile(file,inFolder: folder, withExtension: "csv"),
            !line.isEmpty
            else {
            print("#Problem  --> \(file)  +  \(folder)")
            return false
        }
        print("#BEERS LEIDAS")
        let lines :[String]? = line.components(separatedBy: "\n")
        let importedBeers = lines!.compactMap{Beer($0, "\t") }
        
        if !importedBeers.isEmpty{
            print("#BEERS CONSTRUIDAS")
            self.allBeers = importedBeers//siguiente mal¿
            print("#IMPORTED BEERS  --> \(importedBeers) ")
            return true
            
        }else{
            return false
        }
        
    }
    
    func importProducersFromBundle(_ file:String, folder:String)->Bool{
        
       
        guard
            //Read file and parse by /n
            let lines = bundleReadAllLinesFromFile(file,inFolder: folder, withExtension: "txt"),
            !lines.isEmpty
            else {
            return false
        }
        //parse by tab
        let imortedProducers = lines.compactMap{Producer(record: $0, delimiter: "\t") }
        
        if !imortedProducers.isEmpty{
            
            self.producers = imortedProducers
            self.producers.forEach{ self.producersNamed.updateValue($0, forKey: $0.nameProducer)}//posible error nameProducer
            return true
            
        }else{
            return false
        }
        
    }
    
    
    //Jorge
    func importProducersFromCsv(_ file:String, folder:String)->Bool{
       print("#SALTO A IMPORT FROM CSV")
        /*let filePath = Bundle.main.path(forResource: "defaultbeer", ofType: "csv")
        print("#BUNDLE  --> \(filePath) ")
       let textContent = try! String(contentsOfFile: filePath!,
                                  encoding: String.Encoding.utf8)
       print("#text  --> \(textContent) ")*/
        let path = Bundle.main.path(forResource: "defaultbeer", ofType: "csv")
        let line = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        guard
            //Read file and parse by /n
            //let lines = bundleReadAllLinesFromFile("defaultbeer",inFolder: "Supporting Files", withExtension: "csv"),
            
            
            !line.isEmpty
            else {
            print("#Problem  --> \(file)  +  \(folder)")
            return false
        }
        
        //parse by tab
        let lines :[String]? = line.components(separatedBy: "\n")
        print("#FILE  --> \(lines) ")
        let imortedProducers = lines!.compactMap{Producer(record: $0, delimiter: "\t") }//Pasa cada linea al constructor y puebla el nombre del producer y la foto
        print("#SALTO A IMPORT FROM CSV POST READ ALL LINES")
        print("#IMPORTED PRODUCERS  --> \(imortedProducers) ")
        if !imortedProducers.isEmpty{
            
            self.producers = imortedProducers
            self.producers.forEach{ self.producersNamed.updateValue($0, forKey: $0.nameProducer)}//posible error nameProducer
            return true
            
        }else{
            return false
        }
        
    }
    
    
    
    
    func readProducersInfosFromDocuments(url: URL)->Bool{
        var d:Data!
        var x:Any?
        print("SALTO A READPRODUCERS INFO FROM DOC")
        do{
            d = try Data(contentsOf: url)
            
        }catch{
            print("the file \(url.path) could not be read because \(error.localizedDescription)")
            return false
        }
        do{
            x = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(d)
            producers = x as! [Producer]

            self.producers.forEach{self.producersNamed.updateValue($0, forKey: $0.nameProducer);print($0.nameProducer)}
            print(producersNamed["Cervezas Segovia S.L."]?.beersCollect![1].nameBeer)
            //****************************************************************************
        }catch{
            
            print("infor  in data could not be parsed because \(error.localizedDescription)")
            return false

        }
        return true
    }
    
    
    public func writeProducersInfosToDocuments(_ file: String, folder:String)->Bool{
        
        print("#SALTO A WRITEPRODUCERSINFOTODOCUMENTS")
        let documentsFolderURL = documentsURL().appendingPathComponent(folder)//maxus
        let documentsFolderPath = documentsFolderURL.path
        var urlsOfFile = documentsFolderURL.appendingPathComponent(file)
        urlsOfFile.appendPathExtension("bin")
        print("Doc Path --> \(documentsFolderPath)")
        //Folder Not existant
        if !dfm.fileExists(atPath: documentsFolderPath){
            do{
                print("No existe")
                try dfm.createDirectory(at: documentsFolderURL, withIntermediateDirectories: true, attributes: nil)
                
            }catch{
                print("could not create folder in Documents: \(error.localizedDescription)")
                return false
                
            }
            
        }
        
        //escritura info de los producers
        print("#SALTO A escritura producers")
        var data:Data!
        do{
            
            data = try NSKeyedArchiver.archivedData(withRootObject: producers, requiringSecureCoding: true)
        }catch{
            print("Could Not serialize producers: \(error.localizedDescription)")
            return false
        }
        do{
            try data.write(to: urlsOfFile)
            
        }catch{
            print("could not write producers to binary file: \(error.localizedDescription)")
            return false
            
        }
        /*
        debug posibility
         */
        return true
    }
    
    
    
    
    
    
    public func encode(with coder: NSCoder) {
        coder.encode(producers, forKey: "producers")
        coder.encode(allBeers, forKey: "allBeers")
    }
    
    public required init?(coder decoder: NSCoder) {
        self.producers = decoder.decodeObject(forKey: "producers") as! [Producer]
        self.allBeers  = decoder.decodeObject(forKey: "allBeers") as! [Beer]
    }
    
    
    
}
