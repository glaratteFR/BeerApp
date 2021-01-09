//
//  ProducerViewController.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 28/12/20.
//

import Foundation
import UIKit

class ProducerViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    
    
    
   
    @IBOutlet weak var nameOfProducer: UITextField!
    @IBOutlet weak var imageOfProducer: UIImageView!
    @IBOutlet weak var numberOfBeers: UILabel!
    
    @IBOutlet weak var done: UIButton!
    //Producer to show
    var aProducer:Producer?
    
    
    let imgPicker = UIImagePickerController()
    var aModel: Model?
    var aAction: String?
    var name: String?
    var producerImage: UIImage!
    var number: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameOfProducer.backgroundColor = UIColor.lightGray//cambiar color
        nameOfProducer.textColor = UIColor.blue
        
        //Set up credentials of or  porducer
        nameOfProducer.text = aProducer?.nameProducer
        imageOfProducer.image = UIImage(data: (aProducer?.logoProducer)!)
        let num = aProducer?.beersCollect?.count ?? 0
        numberOfBeers.text = "\(num) Beers"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        self.imageOfProducer.addGestureRecognizer(tapGesture)
       
    }
    
    @IBAction func acceptAcceptAndReturn(_ sender: Any){
        var allCorrect : Bool = true
        print("CLIKED ACCEPT AND RETURN")
       

        if !checkType(self.nameOfProducer.text!, "word")  {
            
            self.nameOfProducer.textColor = .red
            allCorrect = false
        }
        self.name = self.nameOfProducer.text
        self.number = self.numberOfBeers.text
        self.producerImage = self.imageOfProducer.image
        
        aProducer?.nameProducer = self.name!
        aProducer?.logoProducer = self.producerImage.jpegData(compressionQuality: 1)
        
        if(allCorrect){
            print(self.aAction)
            if self.aAction == "addProducer"
            {
                print("ADD PRODUCER !!!!!")
                aProducer = Producer(nameProducer: self.name!, logoProducer: self.producerImage)
                aModel!.producersNamed[aProducer!.nameProducer] = aProducer
                aModel!.producers.removeAll()
                print("azeerrttttttttttttttt")
                print(aModel?.producersNamed.forEach{
                    print($0.value.nameProducer)
                })
                aModel!.producers = aModel!.producersNamed.map { (name, producer) in
                    return producer
                }
                performSegue(withIdentifier: "unwindSegueFromProducerView", sender: self)//posible error
            }else{
            
            print("UNWIND")
            print(allCorrect)
            
            performSegue(withIdentifier: "unwindSegueFromProducerView", sender: self)//posible error
                }
        }
        
        
    }

    
    @objc func tapGestureAction(gesture: UITapGestureRecognizer){
        print("             hello")
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
        aProducer?.logoProducer = newPic.jpegData(compressionQuality: 1)
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
            //expected number
            print("This is taken care of UI")
            return true
        }
    }
}
