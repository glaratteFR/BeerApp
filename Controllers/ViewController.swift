//
//  ViewController.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 26/12/20.
//

import UIKit


class ViewController: UITableViewController {

    var model = Model()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        print(model.producers[0].beersCollect?.count)
            
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let producerNumber = section
        let producer = model.producers[producerNumber]
        return producer.beersCollect?.count ?? 0
    }
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let producerNum = indexPath.section
    let producer = model.producers[producerNum]
    let b = producer.beersCollect?[indexPath.row]
    
    let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
    cell.mainLabel.text = b?.nameBeer
    
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexpath: Int) -> CGFloat {
            return 100
    }

}

