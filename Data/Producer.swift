//
//  Producer.swift
//  BeerApp
//
//  Created by Grégoire LARATTE on 27/12/20.
//

import Foundation
import UIKit

public class Producer : NSObject, NSCoding, NSSecureCoding, Codable{

    public static var supportsSecureCoding: Bool = true
    
    
    var nameProducer : String
    var duplicate : String
    var logoProducer : Data?
    var beersCollect : [Beer]?
    
    public enum Keys: String,CodingKey {
        case nameProducer
        case duplicate
        case logoProducer
        case beersCollect
    }
    
    init(nameProducer:String, logoProducer:UIImage? = nil) {
        self.nameProducer = nameProducer
        self.logoProducer = logoProducer?.pngData()
        self.duplicate = "1"
        self.beersCollect = [Beer]()
    }
    
    public override init() {
        self.nameProducer="none"
        self.duplicate = "1"
        self.logoProducer = nil
        self.beersCollect = [Beer]()
    }

    

    init?(record:String, delimiter del:String) {

        let tokens = record.components(separatedBy: del)
        let dfm = FileManager.default
        self.beersCollect = [Beer]()
        let  tempNameProducer = tokens[2]
        guard
            tokens.count == 11,
            
            !tempNameProducer.isEmpty
        else {
            return nil }


        let namePicProducerSpaced = tokens[2]
        let trimed = namePicProducerSpaced.replacingOccurrences(of: "\\s*",
                                                with: "$1",
                                                options: [.regularExpression])
        var tempMarkImage : UIImage?
        if

            let pathToMark = Bundle.main.url(forResource: trimed.lowercased(),withExtension: "jpg", subdirectory: "beerApp-fotos"),
            dfm.fileExists(atPath: pathToMark.path)
             
        {   tempMarkImage = UIImage(contentsOfFile: pathToMark.path)
            
        }else
        
        {
            if
                let pathToMark = Bundle.main.url(forResource:"defaultPic",withExtension: "jpg"),
                dfm.fileExists(atPath: pathToMark.path)
                
            {tempMarkImage = UIImage(contentsOfFile: pathToMark.path)
                
            }else{
                return nil}

        }
        self.nameProducer = tempNameProducer
        self.logoProducer = tempMarkImage?.pngData()
        self.duplicate = "1"

    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.beersCollect = try container.decodeIfPresent([Beer].self, forKey: .beersCollect)
        self.duplicate = try container.decodeIfPresent(String.self, forKey: .duplicate)!
        self.logoProducer = try container.decodeIfPresent(Data.self, forKey: .logoProducer)
        self.nameProducer = try container.decodeIfPresent(String.self, forKey: .nameProducer)!
    }
    
    
    public func encode(with coder: NSCoder) {
        coder.encode(nameProducer, forKey: "nameProducer")
        coder.encode(logoProducer, forKey: "logoProducer")
        coder.encode(beersCollect, forKey: "beersCollect")
        coder.encode(duplicate, forKey: "duplicate")
    }
    
    public required init?(coder decoder: NSCoder) {
        self.nameProducer = decoder.decodeObject(forKey: "nameProducer") as! String
        self.logoProducer = decoder.decodeObject(forKey: "logoProducer") as! Data?
        self.beersCollect = decoder.decodeObject(forKey: "beersCollect") as! [Beer]?
        self.duplicate = decoder.decodeObject(forKey: "duplicate") as! String
    }
    
    
}
