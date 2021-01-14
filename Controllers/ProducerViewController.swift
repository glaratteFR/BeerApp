//
//  ProducerViewController.swift
//  BeerApp
//
//  Created by Grégoire LARATTE on 28/12/20.
//

import Foundation
import UIKit

class ProducerViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    
    
    
   
    @IBOutlet weak var nameOfProducer: UITextField!
    @IBOutlet weak var imageOfProducer: UIImageView!
    @IBOutlet weak var numberOfBeers: UILabel!
    
    @IBOutlet weak var done: UIButton!
    
    var aProducer:Producer?
    
    
    let imgPicker = UIImagePickerController()
    var aModel: Model?
    var aAction: String?
    var name: String?
    var producerImage: UIImage!
    var number: String?
    var alert: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameOfProducer.backgroundColor = UIColor.lightGray
        nameOfProducer.textColor = UIColor.blue
        
        nameOfProducer.text = aProducer?.nameProducer
        if aProducer?.logoProducer == nil{
            imageOfProducer.image = nil
            
        }else
        {
            imageOfProducer.image = UIImage(data: (aProducer?.logoProducer!)!)
            
        }
        let num = aProducer?.beersCollect?.count ?? 0
        numberOfBeers.text = "\(num) Beers"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        self.imageOfProducer.addGestureRecognizer(tapGesture)
       
    }
    
    @IBAction func acceptAcceptAndReturn(_ sender: Any){
        var allCorrect : Bool = true

        if !checkType(self.nameOfProducer.text!, "word")  {
            
            self.nameOfProducer.textColor = .red
            allCorrect = false
        }
        self.name = self.nameOfProducer.text
        self.number = self.numberOfBeers.text
        self.producerImage = self.imageOfProducer.image
        self.alert = false
        aProducer?.nameProducer = self.name!
        if (self.producerImage == nil)
        {
            aProducer?.logoProducer = nil
            
        }
        else
        {
            aProducer?.logoProducer = self.producerImage.pngData()
            
        }
        
        
        if(allCorrect){

            if self.aAction == "addProducer"
            {
                aProducer = Producer(nameProducer: self.name!, logoProducer: self.producerImage)
                if (aModel!.producersNamed[aProducer!.nameProducer] == nil) {
                    aModel!.producersNamed[aProducer!.nameProducer] = aProducer
                    aModel!.producers.removeAll()
                    aModel!.producers = aModel!.producersNamed.map { (name, producer) in
                        return producer
                    }                }
                else
                {
                    aModel!.alert = true
                
                }
                performSegue(withIdentifier: "unwindSegueFromProducerView", sender: self)
            }else{
            performSegue(withIdentifier: "unwindSegueFromProducerView", sender: self)
                }
        }
        
        
    }

    
    @objc func tapGestureAction(gesture: UITapGestureRecognizer){
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
        notifyUser(self, alertTitle: "The camera is unavailable", alertMessage: "The camera cant be run in the simulator", runOnOK: {_ in})
            return
        }
        imgPicker.allowsEditing = false
        imgPicker.sourceType = UIImagePickerController.SourceType.camera
        imgPicker.cameraCaptureMode = .photo
        imgPicker.delegate = self
        present(imgPicker, animated: true, completion: nil)
        
        
    }
}
extension ProducerViewController : UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newPic = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        aProducer?.logoProducer = newPic.pngData()
        self.imageOfProducer.image = newPic
        self.imageOfProducer.setNeedsDisplay()
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkType(_ introduced: String, _ expected: String) -> Bool {
        
        if introduced.isEmpty {
            
            
                notifyUser(self, alertTitle: "Field is emty", alertMessage: "Sorry cant leave the field empty", runOnOK: {_ in})
                    return false
                
        }
        if expected == "word"{
            let phone = introduced.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            if !phone.isEmpty  {
                notifyUser(self, alertTitle: "Type of Input Incorrect", alertMessage: "\(introduced): Wasn't cant take numbers. Please correct it to save", runOnOK: {_ in})
                    return false
                }
                return true
            
           
            
        }else{
            return true
        }
    }
}
