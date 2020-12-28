//
//  ProducerViewController.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 28/12/20.
//

import Foundation
import UIKit

class ProducerViewController: UIViewController {
    
    @IBOutlet weak var nameOfProducer: UILabel!
    @IBOutlet weak var imageOfProducer: UIImageView!
    @IBOutlet weak var numberOfBeers: UILabel!
    
    //Producer to show
    var aProducer:Producer?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameOfProducer.backgroundColor = UIColor.lightGray//cambiar color
        nameOfProducer.textColor = UIColor.blue
        
        //Set up credentials of or  porducer
        nameOfProducer.text = aProducer?.nameProducer
        imageOfProducer.image = aProducer?.logoProducer
        let num = aProducer?.beersCollect?.count ?? 0
        numberOfBeers.text = "\(num) Beers"
       
    }


}

