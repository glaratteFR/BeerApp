//
//  BeerViewController.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 27/12/20.
//


import UIKit

class BeerViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    
  
    
    
    @IBOutlet weak var producerSelector: UIPickerView!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var typeText: UITextField!
    @IBOutlet weak var producerText: UITextField!
    @IBOutlet weak var nationalityText: UITextField!
    @IBOutlet weak var capText: UITextField!
    @IBOutlet weak var expDText: UITextField!
    @IBOutlet weak var rateText: UITextField!
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var ibuText: UITextField!
    @IBOutlet weak var volDText: UITextField!

    @IBOutlet weak var beerImageFrame: UIImageView!
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        
        
    }
    var aModel: Model? //Acceso a los datos
    var aBeer : Beer?
    
    var name: String?
    var type: String?
    var producer: String?
    var nationality: String?
    var cap: String?
    var expD: String?
    var rate: String?
    var id: String?
    var ibu: String?
    var volD: String?

    var beerImage: UIImage!
    
    
    var listMakersNames:[String]?
    let imgPicker = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listMakersNames = aModel?.producers.map{$0.nameProducer}//populate list with names
        self.name = aBeer?.nameBeer
        self.type = aBeer?.typeBeer
        self.producer = aBeer?.producerBeer
        self.nationality = aBeer?.nationalityBeer
        self.cap = aBeer?.capBeer
        self.expD = aBeer?.expDateBeer
        self.rate = aBeer?.rateBeer
        self.id = aBeer?.IDBeer
        self.ibu = aBeer?.IBUBeer
        self.volD = aBeer?.volBeer
        self.beerImage = aBeer?.pictureBeer
        
 
    }
    override func viewWillAppear(_ animated: Bool) {
        //Allows data to be modified
        print("ESTOY EN BEER")
        print(self.name)
        nameText.text = self.name
       // typeText.text = self.type
        producerText.text = self.producer
        nationalityText.text = self.nationality
        capText.text = self.cap
        expDText.text = self.expD
        rateText.text = self.rate
        idText.text = self.id
        ibuText.text = self.ibu
        volDText.text = self.volD
        beerImageFrame.image = self.beerImage
/*
        let producerNumber = listMakersNames?.firstIndex(of: self.name!)//¿??
        producerSelector.selectRow(producerNumber!, inComponent: 0, animated: true)
    */
    }
    
    @IBAction func acceptAcceptAndReturn(_ sender: Any){
        print("CLIKED ACCEPT AND RETURN")
        self.name = self.nameText.text
//        self.type = self.typeText.text
        
        self.producer = self.producerText.text
        self.nationality = self.nationalityText.text
        self.cap = self.capText.text
        self.expD = self.expDText.text
        self.rate = self.rateText.text
        self.id = self.idText.text
        self.ibu = self.ibuText.text
        self.volD = self.volDText.text
        //image
        
        //get producer name from picker
        self.producer = aModel?.producers[producerSelector.selectedRow(inComponent: 0)].nameProducer
        
        aBeer?.nameBeer = self.name!
        aBeer?.typeBeer = self.type!
        aBeer?.producerBeer = self.producer!
        aBeer?.nationalityBeer = self.nationality!
        aBeer?.capBeer = self.cap!
        aBeer?.expDateBeer = self.expD!
        aBeer?.rateBeer = self.rate!
        aBeer?.IDBeer = self.id!
        aBeer?.IBUBeer = self.ibu!
        aBeer?.volBeer = self.volD!
        
        
        //¿?¿
        //aBeer?.picture
        
        if self.producer != aBeer?.producerBeer{
            
            //remove from original producer
            
            let ogProducer = aModel?.producersNamed[(aBeer?.producerBeer)!]
            let indexBeerList = ogProducer?.beersCollect?.firstIndex(of: aBeer!)
            ogProducer?.beersCollect?.remove(at: indexBeerList!)
            
            
            //add to the new producer list
            aBeer?.producerBeer = self.name!
            aModel?.producersNamed[self.producer!]?.beersCollect?.append(aBeer!)
            
        }
        print("UNWIND")
        performSegue(withIdentifier: "unwindSegueFromBeerView", sender: self)//posible error
        
        
    }
    //camera if posible
    @IBAction func tapGestureAction(gesture: UITapGestureRecognizer){
        
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
    


}//end beerViewController

extension BeerViewController : UIPickerViewDataSource{
    
    // number of rows = the number of producers
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        guard
            let numberRows = aModel?.producers.count
            else {
            return 0
        }
        return numberRows
    }
    //??
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func imagePickerController(_ picker: UIPickerView, _ row: Int, _ component: Int) -> String?{
        return listMakersNames?[row] ?? "Unknown Producer"
    }
}


//¿?¿'
extension BeerViewController : UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, _ row: Int, _ component: Int)  {
        self.producer = listMakersNames?[row]
    }

}


extension BeerViewController : UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newPic = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.beerImage = newPic
        self.beerImageFrame.image = newPic
        self.beerImageFrame.setNeedsDisplay()
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}



