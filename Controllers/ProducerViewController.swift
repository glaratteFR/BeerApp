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
    
    //Producer to show
    var aProducer:Producer?
    
    let imgPicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameOfProducer.backgroundColor = UIColor.lightGray//cambiar color
        nameOfProducer.textColor = UIColor.blue
        
        //Set up credentials of or  porducer
        nameOfProducer.text = aProducer?.nameProducer
        imageOfProducer.image = aProducer?.logoProducer
        let num = aProducer?.beersCollect?.count ?? 0
        numberOfBeers.text = "\(num) Beers"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        self.imageOfProducer.addGestureRecognizer(tapGesture)
       
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
        aProducer?.logoProducer = newPic
        self.imageOfProducer.image = newPic
        self.imageOfProducer.setNeedsDisplay()
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
