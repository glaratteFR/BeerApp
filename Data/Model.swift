
//  Model.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 27/12/20.
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
        let sorted = dict.sorted(by: {$0.key < $1.key })
        var newDict: [String:Producer] = [:]
        for sortedDict in sorted {
            newDict[sortedDict.key]=sortedDict.value
        }
        return newDict
    }
    
    func switchKey(_ myDict: Dictionary<String,Producer>,fromKey: String, toKey: String) -> Dictionary<String,Producer>{
        print(toKey)
        var dict = myDict
        if var entry = dict.removeValue(forKey: fromKey)
        {
            dict[toKey] = entry
        }
        print(dict[toKey])
        
        
        
        return dict
    }

    
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
        //print(URL_OF_PRODUCERS_BINARY_FILE)
        
        /*
         Print for debug
         
         */
        
        
        if !readBinProducers{//if first boot
            print("TryToDownload")
           
           
            
     
            
        
                print("Downloading...")
                importBeersFromCsvOnline("defaultbeer.csv","BeerApp/Supporting_Files/beerApp-data/")
                importImgOnline("dfdffdd.csv","BeerApp/Supporting_Files/beerApp-data/")
               // sleep(3)
           
            importProducers = importProducersFromCsv("defaultbeer", folder: NAME_OF_FOLDER_IN_BUNDLE)
            
           
            
            
            producers.forEach{ producersNamed.updateValue($0, forKey: $0.nameProducer)}
            importBeers = importBeersFromCsv(NAME_OF_PRODUCER_FILE_IN_BUNDLE, folder: NAME_OF_FOLDER_IN_BUNDLE)
            
            
            
            
            print("#Read producers --> \(importProducers)")
            print("#Read beers --> \(importBeers)")
            assert(importProducers && importBeers)
            producers.forEach{ $0.beersCollect = [Beer]()}
            allBeers.forEach{producersNamed[$0.producerBeer]?.beersCollect?.append($0)}
            
            
            
        }
        var index = 0
        var uniqueValues = Set<String>()
        var resultDict = [String: Producer]()
        print(self.producersNamed.count)
        resultDict = self.producersNamed
        self.producers.removeAll()
        
     
        resultDict = sortWithKeys(resultDict)
        
        var numberIterator = resultDict.makeIterator()
        print(resultDict.count)
        while let num = numberIterator.next(){
            print(self.producersNamed.count)
            print(self.producersNamed.endIndex)
            print("DUPLICATION")
            print(num.key)
            if (num.key == numberIterator.next()?.key)
            {
                print("-------------DUPLICATE PRODUCER --------------")
                let index = self.producersNamed.index(forKey: num.key)
                self.producersNamed = switchKey(self.producersNamed,fromKey: num.key, toKey: num.key + "_02")
            }
        }
        
        var allBears:[Beer] = []

        
        self.producersNamed.forEach {(index,value) in
            
            allBears+=value.beersCollect!
            
        }
        allBears = allBears.sorted(by: { $0.nameBeer > $1.nameBeer})
        var indexBeer = 2
        /*
         nameBeer : String,
              typeBeer : String,
              producerBeer : String,
              nationalityBeer : String,
              capBeer : String,
              expDateBeer : String,
              rateBeer : String,
              IDBeer : String,
              IBUBeer : String,
              volBeer : String,
              pictureBeer : UIImage?
         
         */
        
        var oldNameBeer = allBears[0].nameBeer
        
        for (index, bear) in allBears.enumerated() {
            var nextBear = allBears[index+1]
            if bear.nameBeer == nextBear.nameBeer
            {
                if (bear.capBeer == nextBear.capBeer && bear.expDateBeer == nextBear.expDateBeer && bear.nationalityBeer == nextBear.nationalityBeer && bear.rateBeer == nextBear.rateBeer){
                    let indexProd = self.producersNamed.index(forKey: bear.nameBeer)
                    
                     self.producersNamed[indexProd!].value.beersCollect?.filter{
                        $0.nameBeer == bear.nameBeer
                    }.first?.change(p_nameBeer:bear.nameBeer+"_"+String(index))
                    if (oldNameBeer == bear.nameBeer)
                    {
                        indexBeer = indexBeer+1
                        oldNameBeer = bear.nameBeer
                        
                    }else{
                        indexBeer = 2
                    }
                    
                    
                    
                }
            }
        }
        
        
        
        
       /* resultDict.forEach { (key1,value) in
            resultDict.removeValue(forKey: key1)
            resultDict.forEach { (key2,value) in
                if (key1 == key2)
                {
                    if (resultDict)
                }
                else{
                    
                }
                
            }
        } */
        
        
        self.producers.removeAll()
        self.producersNamed.forEach{self.producers.append($0.value); index = index+1}
        allBeers.forEach{producersNamed[$0.producerBeer]?.beersCollect?.append($0)}
        /*
        print("********************")
        print(producers.count)
        print(producers[0].nameProducer)§ˇˇ§ˇˇ
        print(producers[0].beersCollect?[].nameBeer)
        */
        producers.forEach{$0.beersCollect?.sort(by: {($0.nameBeer) < ($1.nameBeer)})}
        print("********************")
        print(producers.count)
     
        
    }//end init model
    
    func importImgOnline(_ file:String, _ folder:String) -> Void {
        print("#SALTO A IMPORT FROM CSV BEERS")
        var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var path = documentDirectory[0].appendingPathComponent("img.png")
        print(FileManager.default.fileExists(atPath: path.path))
        if !(FileManager.default.fileExists(atPath: path.path)) {
            let urlStrings = "http://maxus.fis.usal.es/HOTHOUSE/daa/2020beer/fotos/lagallolocajunio21.png"
        
            /*var documentDirectory = Bundle.main.resourceURL
            var path = documentDirectory?.appendingPathComponent("save.csv")
            print(path)*/
            print(path)
            if let fileUrl = URL(string: urlStrings){
                URLSession.shared.downloadTask(with: fileUrl){
                    (tempFileUrl,response,error) in
                    if let fileTempFileUrl = tempFileUrl {
                        do {
                        
                            
                            try FileManager.default.moveItem(at: fileTempFileUrl, to: path)
                            if (FileManager.default.fileExists(atPath: path.path)) {                            print("PICTURE EXIST !!!")
                            }
                            else
                            {
                                print("PICTURE not EXIST !!!")                            }
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
    func importBeersFromCsvOnline(_ file:String, _ folder:String) -> Bool{

        print("#HHHHHHHHHHHHHHRS")

        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        let path = documentDirectory[0].appendingPathComponent("save.csv")

        print(FileManager.default.fileExists(atPath: path.path))

        if !(FileManager.default.fileExists(atPath: path.path)) {

            let urlStrings = "http://maxus.fis.usal.es/HOTHOUSE/daa/2020beer/defaultbeer.csv"

        

            /*var documentDirectory = Bundle.main.resourceURL

            var path = documentDirectory?.appendingPathComponent("save.csv")

            print(path)*/

            print(path)
            print("KKKKKKKKKKKKK")
            if let fileUrl = URL(string: urlStrings){

                URLSession.shared.downloadTask(with: fileUrl){

                    (tempFileUrl,response,error) in
                    print("GGGGGGGGGGGGG")
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
            
            print("le fichier existe déjà")
            
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

        print("#SALTO A IMPORT FROM CSV BEERS")
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        let path = documentDirectory[0].appendingPathComponent("save.csv")
        while  !(FileManager.default.fileExists(atPath: path.path)){
            print("Waiting for file..")
            sleep(UInt32(1))
        }
        //let path = Bundle.main.path(forResource: "defaultbeer", ofType: "csv")
        
        let line = try! String(contentsOf: path, encoding: String.Encoding.utf8)
        guard
            //let lines = bundleReadAllLinesFromFile(file,inFolder: folder, withExtension: "csv"),
            !line.isEmpty
            else {
            print("#Problem  --> \(file)  +  \(folder)")
            return false
        }
        print("#BEERS LEIDAS")
        var lines :[String]? = line.components(separatedBy: "\n")
        if lines?.last == ""{
            lines?.removeLast()
            
        }
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
       
        /*let filePath = Bundle.main.path(forResource: "defaultbeer", ofType: "csv")
        print("#BUNDLE  --> \(filePath) ")
       let textContent = try! String(contentsOfFile: filePath!,
                                  encoding: String.Encoding.utf8)
       print("#text  --> \(textContent) ")*/
       

        print("#SALTO A IMPORT FROM PRODUCERS CSV")
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        let path = documentDirectory[0].appendingPathComponent("save.csv")
        while  !(FileManager.default.fileExists(atPath: path.path)){
            print("Waiting for file..")
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
            print("#Problem  --> \(file)  +  \(folder)")
            return false
        }
        
        //parse by tab
        var lines :[String]? = line.components(separatedBy: "\n")
        print("#FILE  --> \(String(describing: lines)) ")
        if lines?.last == ""{
            lines?.removeLast()
            
        }
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
            print(producersNamed["Cervezas Segovia S.L."]?.beersCollect![1].nameBeer as Any)
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


