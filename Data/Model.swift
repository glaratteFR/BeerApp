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
        
        let DOCS_URL = documentsUrl()//maxus
        let URL_OF_FOLDER_IN_DOCUMENTS =
            DOCS_URL.appendingPathComponent(NAME_OF_FOLDER_IN_DOCUMENTS)
        
        let URL_OF_PRODUCERS_BINARY_FILE = URL_OF_FOLDER_IN_DOCUMENTS.appendingPathComponent(NAME_OF_PRODUCERS_FILE_IN_DOCUMENTS).appendingPathExtension("bin")
        
        producers = [Producer]()
        allBeers = [Beer]()
        super.init()
        var readBinProducers = false
        var importProducers = false
        var importBeers = false
        
        readBinProducers = readHousesInfosFromDocuments(url: URL_OF_PRODUCERS_BINARY_FILE)
        
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
    
    
    
    public func encode(with coder: NSCoder) {
        <#code#>
    }
    
    public required init?(coder: NSCoder) {
        <#code#>
    }
    
    
    
}
