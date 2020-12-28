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
    let NAME_OF_FOLDER_IN_DOCUMENTS = "DataOfBeerApp"
    let NAME_OF_PRODUCERS_FILE_IN_DOCUMENTS = "FileOfProducers"
    
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
        var readBinProducers = false
        var importProducers = false
        var importBeers = false
        
        readBinProducers = readProducersInfosFromDocuments(url: URL_OF_PRODUCERS_BINARY_FILE)
     
        /*
         Print for debug
         
         */
        
        
        if !readBinProducers{
            importProducers = importProducersFromBundle(NAME_OF_PRODUCER_FILE_IN_BUNDLE, folder: NAME_OF_FOLDER_IN_BUNDLE)//donde esta import from bundle
            
            producers.forEach{ producersNamed.updateValue($0, forKey: $0.nameProducer)}
            importBeers = importBeersFromBundle(NAME_OF_PRODUCER_FILE_IN_BUNDLE, folder: NAME_OF_FOLDER_IN_BUNDLE)
            assert(importProducers && importBeers)
            producers.forEach{ $0.beersCollect = [Beer]()}
            allBeers.forEach{producersNamed[$0.producerBeer]?.beersCollect?.append($0)}
            
            
        }
        
        producers.forEach{$0.beersCollect?.sort(by: {($0.nameBeer) < ($1.nameBeer)})}
        
        
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
    
    func importProducersFromBundle(_ file:String, folder:String)->Bool{
       
        guard
            let lines = bundleReadAllLinesFromFile(file,inFolder: folder, withExtension: "txt"),
            !lines.isEmpty
            else {
            return false
        }
        let imortedProducers = lines.compactMap{Producer(record: $0, delimiter: "\t") }
        
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
            x = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(d)
            producers = x as! [Producer]
            self.producers.forEach{self.producersNamed.updateValue($0, forKey: $0.nameProducer)}
            
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
        urlsOfFile.appendPathExtension("bin")
        
        //Folder Not existant
        if !dfm.fileExists(atPath: documentsFolderPath){
            do{
                try dfm.createDirectory(at: documentsFolderURL, withIntermediateDirectories: true, attributes: nil)
                
            }catch{
                print("could not create folder in Documents: \(error.localizedDescription)")
                return false
                
            }
            
        }
        
        //escritura info de los producers
        
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
