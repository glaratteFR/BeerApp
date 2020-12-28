//
//  BeerViewController.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 27/12/20.
//


import UIKit

class BeerViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var makerSelector: UIPickerView!
    
    /*
    @IBOutlet weak var makerSelector: UIPickerView!
    @IBOutlet weak var makerSelector: UIPickerView!
    */
    
    var aModel: Model? //Acceso a los datos
    var aBeer : Beer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

