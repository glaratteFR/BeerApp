//
//  Producer.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 27/12/20.
//

import Foundation
import UIKit

public class Producer : NSObject, NSCoding, NSSecureCoding{

    public static var supportsSecureCoding: Bool = true
    
    
    var nameProducer : String
    var logoProducer : UIImage?
    var beersCollect : [Beer]?
    
    init(nameProducer:String, logoProducer:UIImage? = nil) {
        self.nameProducer = nameProducer
        self.logoProducer = logoProducer
    }
    

    

    init?(record:String, delimiter del:String) {

        let tokens = record.components(separatedBy: del)
        let dfm = FileManager.default

        guard
            tokens.count == 2,
            let  tempNameProducer = tokens.first,
            !tempNameProducer.isEmpty
        else { return nil }

        let tempMark = tokens[1]//¿?¿?

        guard

            let bits = splitIntoNameAndExtension(total: tempMark),//maxus
            
            let pathToMark = Bundle.main.url(forResource: bits[0],withExtension: bits[1], subdirectory: "beerApp-fotos"),
            dfm.fileExists(atPath: pathToMark.path),
            let tempMarkImage = UIImage(contentsOfFile: pathToMark.path)
        else    { return nil }

        

        self.nameProducer = tempNameProducer
        self.logoProducer = tempMarkImage
    

    }
    
    
    
    
    public func encode(with coder: NSCoder) {
        coder.encode(nameProducer, forKey: "nameProducer")
        coder.encode(logoProducer, forKey: "logoProducer")
        coder.encode(beersCollect, forKey: "beersCollect")
    }
    
    public required init?(coder decoder: NSCoder) {
        self.nameProducer = decoder.decodeObject(forKey: "nameProducer") as! String
        self.logoProducer = decoder.decodeObject(forKey: "logoProducer") as! UIImage?
        self.beersCollect = decoder.decodeObject(forKey: "beersCollect") as! [Beer]?
    }
    
    
}
