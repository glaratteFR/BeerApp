
//  Model.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramoe on 27/12/20.
//

import Foundation
import UIKit
var isDownloading: Bool = true
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
    
    func sortWithKeys(_ dict:[String:Producer]) -> [String:Producer]{
        let sorted = dict.sorted(by: {$0.key > $1.key })
        var newDict: [String:Producer] = [:]
        for sortedDict in sorted {
            newDict[sortedDict.key]=sortedDict.value
        }
        return newDict
    }
    
    func switchKey(_ myDict: Dictionary<String,Producer>,fromKey: String, toKey: String) -> Dictionary<String,Producer>{
        var dict = myDict
        if var entry = dict.removeValue(forKey: fromKey)
        {
            dict[toKey] = entry
        }
        return dict
    }

    
    public override init() {
        
        let DOCS_URL = documentsURL()// RGB Tools
        
        let URL_OF_FOLDER_IN_DOCUMENTS =
            DOCS_URL.appendingPathComponent(NAME_OF_FOLDER_IN_DOCUMENTS)
        
        let URL_OF_PRODUCERS_BINARY_FILE = URL_OF_FOLDER_IN_DOCUMENTS.appendingPathComponent(NAME_OF_PRODUCERS_FILE_IN_DOCUMENTS).appendingPathExtension("txt")
        
        producers = [Producer]()
        allBeers = [Beer]()
        super.init()
        var readBinProducers = false//existen archivos de un arranque anterior?
        var importProducers = false
        var importBeers = false
        
        
        //COMIENZO DE LECTURA
        readBinProducers = readProducersInfosFromDocuments(url: URL_OF_PRODUCERS_BINARY_FILE) //Intento de lectura de archivo binario La app ya fue arrancada
        //First boot readBinProducers = false
        
        
        if !readBinProducers{//if first boot

                print("Downloading")
                importBeersFromCsvOnline("defaultbeer.csv","BeerApp/Supporting_Files/beerApp-data/")
               
           
            importProducers = importProducersFromCsv("defaultbeer", folder: NAME_OF_FOLDER_IN_BUNDLE)
            
           
            
            
            producers.forEach{ producersNamed.updateValue($0, forKey: $0.nameProducer)}
            importBeers = importBeersFromCsv(NAME_OF_PRODUCER_FILE_IN_BUNDLE, folder: NAME_OF_FOLDER_IN_BUNDLE)
            
            
            
            
            assert(importProducers && importBeers)
     
            allBeers.forEach{importImgOnline($0);}
            producers.forEach{ $0.beersCollect = [Beer]()}
            allBeers.forEach{producersNamed[$0.producerBeer]?.beersCollect?.append($0)}
    
            let p = Producer()
            p.nameProducer = "Anna producer"
            producersNamed[p.nameProducer] = p
        }
   
   
        
        self.producers.removeAll()
        producersNamed.forEach{$0.value.beersCollect?.sort(by:  {($0.nameBeer) > ($1.nameBeer)})}
       
        producersNamed.sorted(by: {$0.value.nameProducer > $1.value.nameProducer})
        
    }//end init model
    
   
    

    func importBeersFromCsvOnline(_ file:String, _ folder:String) -> Bool{


        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        let path = documentDirectory[0].appendingPathComponent("save.csv")

        if !(FileManager.default.fileExists(atPath: path.path)) {

            let urlStrings = "http://maxus.fis.usal.es/HOTHOUSE/daa/2020beer/defaultbeer.csv"


    
            if let fileUrl = URL(string: urlStrings){

                URLSession.shared.downloadTask(with: fileUrl){

                    (tempFileUrl,response,error) in
                    if let fileTempFileUrl = tempFileUrl {

                        do {

                        

                            

                            try FileManager.default.moveItem(at: fileTempFileUrl, to: path)

                            

                            let text = try String(contentsOf: path, encoding: .utf8)

                            print(text)
                            
                            
                    }

                        catch {

                            print(error)

                        }

                    }

                }.resume()
                return false
            }

           
            
        } else {

            
            return false
        }
        
       

        return true
    }






           

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

      
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        let path = documentDirectory[0].appendingPathComponent("save.csv")
        while  !(FileManager.default.fileExists(atPath: path.path)){
    
            sleep(UInt32(1))
        }
        //let path = Bundle.main.path(forResource: "defaultbeer", ofType: "csv")
        
        let line = try! String(contentsOf: path, encoding: String.Encoding.utf8)
        guard
            //let lines = bundleReadAllLinesFromFile(file,inFolder: folder, withExtension: "csv"),
            !line.isEmpty
            else {
            return false
        }
        var lines :[String]? = line.components(separatedBy: "\n")
        if lines?.last == ""{
            lines?.removeLast()
            
        }
        let importedBeers = lines!.compactMap{Beer($0, "\t") }
        
        if !importedBeers.isEmpty{
            self.allBeers = importedBeers
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
    
    
    func importProducersFromCsv(_ file:String, folder:String)->Bool{
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        let path = documentDirectory[0].appendingPathComponent("save.csv")
        while  !(FileManager.default.fileExists(atPath: path.path)){
            sleep(UInt32(1))
        }
        //let path = Bundle.main.path(forResource: "defaultbeer", ofType: "csv")
        
        let line = try! String(contentsOf: path, encoding: String.Encoding.utf8)
       // let path = Bundle.main.path(forResource: "defaultbeer", ofType: "csv")
       
        guard
            //Read file and parse by /n
            //let lines = bundleReadAllLinesFromFile("defaultbeer",inFolder: "Supporting Files", withExtension: "csv"),
            
            
            !line.isEmpty
            else {
            print("Problem  \(file)  +  \(folder)")
            return false
        }
        
    
        //parse by tab
        var lines :[String]? = line.components(separatedBy: "\n")
        print("FILE \(String(describing: lines)) ")
        if lines?.last == ""{
            lines?.removeLast()
            
        }
        let imortedProducers = lines!.compactMap{Producer(record: $0, delimiter: "\t") }//Pasa cada linea al constructor y puebla el nombre del producer y la foto
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
        do{
            d = try Data(contentsOf: url)
            
        }catch{
            print("the file \(url.path) could not be read because \(error.localizedDescription)")
            return false
        }

        do{
            producers = try JSONDecoder().decode([Producer].self,from: d)
           
            self.producers.forEach{self.producersNamed.updateValue($0, forKey: $0.nameProducer);}
        }catch{
            
            print("infor  in data could not be parsed because \(error.localizedDescription)")
            return false

        }

        return true
    }
    
    
    public func writeProducersInfosToDocuments(_ file: String, folder:String)->Bool{
        

        let documentsFolderURL = documentsURL().appendingPathComponent(folder)//maxus
        let documentsFolderPath = documentsFolderURL.path
        var urlsOfFile = documentsFolderURL.appendingPathComponent(file)
        urlsOfFile.appendPathExtension("txt")
        print("Doc Path --> \(documentsFolderPath)")
        //Folder Not existant
        if !dfm.fileExists(atPath: documentsFolderPath){
            do{
                try dfm.createDirectory(at: documentsFolderURL, withIntermediateDirectories: true, attributes: nil)
                
            }catch{
                print("could not create folder in Documents: \(error.localizedDescription)")
                return false
                
            }
            
        }
        
        var data:Data!
        do{
            data = try! JSONEncoder().encode(producers)

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
    
    func importImgOnline(_ beer: Beer) -> Void {
        //lagallolocajunio21.png
        //http://maxus.fis.usal.es/HOTHOUSE/daa/2020beer/fotos/
        var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        var noBlancName = beer.nameBeer.replacingOccurrences(of: "\\s*",
                                                with: "$1",
                                                options: [.regularExpression])
        
        let noBlancDate = beer.expDateBeer.replacingOccurrences(of: "\\s*",
                                                      with: "$1",
                                                      options: [.regularExpression])
        var nameOfImage = "\(noBlancName)\(noBlancDate).png"
        nameOfImage = nameOfImage.lowercased()
        
        let path = documentDirectory[0].appendingPathComponent(nameOfImage)
        if !(FileManager.default.fileExists(atPath: path.path)) {
            var urlStrings = "http://maxus.fis.usal.es/HOTHOUSE/daa/2020beer/fotos/"
            urlStrings = "\(urlStrings)\(nameOfImage)"
            
            if let fileUrl = URL(string: urlStrings){
                URLSession.shared.downloadTask(with: fileUrl){
                    (tempFileUrl,response,error) in
                    if let fileTempFileUrl = tempFileUrl {
                        do {
                        
                            
                            try FileManager.default.moveItem(at: fileTempFileUrl, to: path)
                            if (FileManager.default.fileExists(atPath: path.path)) {
                                print("PICTURE EXIST !!!");
                                print(path.path)
                            }
                            else
                            {
                                print("PICTURE not EXIST !!!")
                         
                            }
                    }
                        catch {
                            print(error)
                        }
                    }
                }.resume()
            }
            
        } else {
            
            

            print("PICTURE ALREADY EXIST !!!!!")
   
          
        }
        

    
    }
    
    
    
    
    public func encode(with coder: NSCoder) {
        coder.encode(producers, forKey: "producers")
        coder.encode(allBeers, forKey: "allBeers")
    }
    
    public required init?(coder decoder: NSCoder) {
        //maybe instead of porducers is producersNamed
        self.producers = decoder.decodeObject(forKey: "producers") as! [Producer]
        self.allBeers  = decoder.decodeObject(forKey: "allBeers") as! [Beer]
    }
    
    
    
}

