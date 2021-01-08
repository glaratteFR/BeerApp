//
//  Beer.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 27/12/20.
//

import Foundation
import UIKit

let pathToUnknownImage  = Bundle.main.url(forResource: "def", withExtension: "jpg")!//Magier place holder jorge?¿
let unknownImage = UIImage(contentsOfFile: pathToUnknownImage.path)


public class Beer : NSObject, NSCoding, NSSecureCoding{
    
    public static var supportsSecureCoding: Bool = true
    
    public func change(p_nameBeer:String)
    {
        self.nameBeer=p_nameBeer
    }
    
    var nameBeer : String
    var typeBeer : String
    var producerBeer : String
    var nationalityBeer : String
    var capBeer : String
    var expDateBeer : String
    var rateBeer : String
    var IDBeer : String
    var IBUBeer : String
    var volBeer : String
    var pictureBeer : UIImage? = nil
    var duplicate : String
    
    override public init() {
        self.nameBeer = "Unkonwn"
        self.typeBeer = "Unkonwn"
        self.producerBeer = "Unkonwn"
        self.nationalityBeer = "Unkonwn"
        self.capBeer = "Unkonwn"
        self.expDateBeer = "January 1"
        self.rateBeer = "Unkonwn"
        self.IDBeer = "Unkonwn"
        self.IBUBeer = "Unkonwn"
        self.volBeer = "Unkonwn"
        self.pictureBeer = unknownImage

        self.duplicate = "1"

        var noBlancName = self.nameBeer.replacingOccurrences(of: "\\s*",
                                                with: "$1",
                                                options: [.regularExpression])
        
        let noBlancDate = self.expDateBeer.replacingOccurrences(of: "\\s*",
                                                      with: "$1",
                                                      options: [.regularExpression])
        var nameOfImage = "\(noBlancName)\(noBlancDate)"
        nameOfImage = nameOfImage.lowercased()
        self.IDBeer = nameOfImage

    }
    
    init(nameBeer : String,
         typeBeer : String,
         producerBeer : String,
         nationalityBeer : String,
         capBeer : String,
         expDateBeer : String,
         rateBeer : String,
         IDBeer : String,
         IBUBeer : String,
         volBeer : String,
         pictureBeer : UIImage?,
         duplicate :String) {
        self.nameBeer = nameBeer
        self.typeBeer = typeBeer
        self.producerBeer = producerBeer
        self.nationalityBeer = nationalityBeer
        self.capBeer = capBeer
        self.expDateBeer = expDateBeer
        self.rateBeer = rateBeer
        self.IDBeer = IDBeer
        self.IBUBeer = IBUBeer
        self.volBeer = volBeer
        self.pictureBeer = pictureBeer
        self.duplicate = "1"
    }
    
    init?(_ record: String, _ del: String) {
        let tokens = record.components(separatedBy: del)
        print("#SALTO A CLASE BEER")
        guard
            tokens.count == 11, // Number of elements to import from CSV
            let tempBeerName = tokens.first,
            !tempBeerName.isEmpty
        else {            print("#Problem with tokens --> \(tokens.count)")
            print("#Problem with  --> \(tokens[0])")
            return nil}
        
        let tempTypeBeer = tokens[1]
        guard !tempTypeBeer.isEmpty else {

            return nil
        }
        
        let tempProducerBeer = tokens[2]
        guard !tempProducerBeer.isEmpty else {
            return nil
        }
        
        let tempNationalityBeer = tokens[3]
        guard !tempNationalityBeer.isEmpty else {
            return nil
        }
        
        let tempCapBeer = tokens[4]
        guard !tempCapBeer.isEmpty else {
            return nil
        }
        
        let tempExpDateBeer = tokens[5]
        guard !tempExpDateBeer.isEmpty else {
            return nil
        }
        
        let tempRateBeer = tokens[6]
        guard !tempRateBeer.isEmpty else {
            return nil
        }
        
        let tempIdBeer = tokens[7]
        guard !tempIdBeer.isEmpty else {
            return nil
        }
        
        let tempIbuBeer = tokens[8]
        guard !tempIbuBeer.isEmpty else {
            return nil
        }
        
        let tempVolBeer = tokens[9]
        guard !tempVolBeer.isEmpty else {
            return nil
        }
        
        let tempPicture = tokens[10]
        
        let tempDuplicate = 1
        
        /*
        guard
            !tempPicture.isEmpty,
            let bits = splitIntoNameAndExtension(total: tempPicture),//maxus
            bits.count == 2,//¿?
            let pathPicture = Bundle.main.url(forResource: bits[0], withExtension: bits[1],subdirectory: "beerApp-fotos"),//subdirectorychange
            FileManager.default.fileExists(atPath: pathPicture.path),
            let tempPictureImage = UIImage(contentsOfFile: pathPicture.path)
        else {print("#Problem with photo --> \(tokens[0])")
            return nil}
        
        */
        

        
        var tempMarkImage : UIImage?
        if

            //let bits = splitIntoNameAndExtension(total: tempMark),//maxus
            let bits = splitIntoNameAndExtension(total: tempPicture),//maxus
            bits.count == 2,//¿?
           
            //goes for pic
            let pathToMark = Bundle.main.url(forResource: bits[0],withExtension: bits[1], subdirectory: "beerApp-fotos")
             
        {   tempMarkImage = UIImage(contentsOfFile: pathToMark.path)
            print("Assigned specific photo")}else    {
           // print("#Problem with picture --> \(trimed.lowercased())")
            if
                let pathToMark = Bundle.main.url(forResource:"def",withExtension: "jpg")
                
            {tempMarkImage = UIImage(contentsOfFile: pathToMark.path)}else{
                print("                                             #PROBLEMA  ")
                return nil}
            //return nil }

        }
        
        
        
        self.nameBeer = tempBeerName
        self.typeBeer = tempTypeBeer
        self.producerBeer = tempProducerBeer
        self.nationalityBeer = tempNationalityBeer
        self.capBeer = tempCapBeer
        self.expDateBeer = tempExpDateBeer
        self.rateBeer = tempRateBeer
        self.IDBeer = tempIdBeer
        self.IBUBeer = tempIbuBeer
        self.volBeer = tempVolBeer
        self.pictureBeer = tempMarkImage
        self.duplicate = String (tempDuplicate)
        
    }
    
    
    
    
    
    
    
    
    public func encode(with coder: NSCoder) {
        coder.encode(nameBeer, forKey: "BeerName")
        coder.encode(typeBeer, forKey: "typeBeer")
        coder.encode(producerBeer, forKey: "producerBeer")
        coder.encode(nationalityBeer, forKey: "nationalityBeer")
        coder.encode(capBeer, forKey: "capBeer")
        coder.encode(expDateBeer, forKey: "expDateBeer")
        coder.encode(rateBeer, forKey: "rateBeer")
        coder.encode(IDBeer, forKey: "IDBeer")
        coder.encode(IBUBeer, forKey: "IBUBeer")
        coder.encode(volBeer, forKey: "volBeer")
        coder.encode(pictureBeer, forKey: "pictureBeer")
        coder.encode(duplicate, forKey: "duplicate")
        
    }
 
    
    
    public required init?(coder aDecoder: NSCoder) {
        
        
        self.nameBeer = aDecoder.decodeObject(forKey: "BeerName") as! String
        self.typeBeer =  aDecoder.decodeObject(forKey: "typeBeer") as! String
        self.producerBeer = aDecoder.decodeObject(forKey: "producerBeer") as! String
        self.nationalityBeer = aDecoder.decodeObject(forKey: "nationalityBeer") as! String
        self.capBeer = aDecoder.decodeObject(forKey: "capBeer") as! String
        self.expDateBeer = aDecoder.decodeObject(forKey: "expDateBeer") as! String
        self.rateBeer = aDecoder.decodeObject(forKey: "rateBeer") as! String
        self.IDBeer = aDecoder.decodeObject(forKey: "IDBeer") as! String
        self.IBUBeer = aDecoder.decodeObject(forKey: "IBUBeer") as! String
        self.volBeer = aDecoder.decodeObject(forKey: "volBeer") as! String
        self.pictureBeer = aDecoder.decodeObject(forKey: "pictureBeer") as! UIImage?
        self.duplicate = aDecoder.decodeObject(forKey: "duplicate") as! String
        
    }
    
    
   
    /*
     public override var descrition: String{}
     
     */
    
    
    
    
}//End Beer Class
