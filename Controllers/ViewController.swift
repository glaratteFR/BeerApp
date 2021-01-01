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
        
            
    }
    
    //
    func numSect(in tableView: UITableView) -> Int{
        print("%Number of sections --> \(model.producers.count)")
        return model.producers.count
    }
    //TableViewCell
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
        if let pic = b?.pictureBeer{
            cell.mainPhoto.image = pic
            print("Hay imagen");print(pic)
                
            }
            if let name = b?.nameBeer{
                cell.mainLabel.text = name
                
            }
        return cell
    }
    
    
    /*
    //Give form of headers
        override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let producer = model.producers[section]
            //let plainHeaderView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
            let plainHeaderView = Bundle.main.loadNibNamed("TableSectionHeader", owner: self, options: nil)?.first as! TableSectionHeader
            plainHeaderView.tag = section
            let customHeaderView = plainHeaderView //??
            print("///////////")
            print(producer.nameProducer)
          
                plainHeaderView.producerNameLabel.text = producer.nameProducer
           // customHeaderView.producerImage.image = producer.logoProducer

            
            let tapRec = UITapGestureRecognizer(target: self,action: #selector(ViewController.jumpToProducerView(_:)))
            tapRec.numberOfTapsRequired = 1

            customHeaderView.addGestureRecognizer(tapRec)//??
            
            return customHeaderView
        }
    */
    
    @objc func jumpToProducerView(_ sender:UIGestureRecognizer){//revisar video para entender
        
        if sender.state == .ended{
            guard
                let n = sender.view?.tag
                else {
                return
            }
            performSegue(withIdentifier: "segueToProducer", sender: model.producers[n])
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        switch segue.identifier! {
        case "segueToProducer":
            let destController = segue.destination as! ProducerViewController
            destController.aProducer = sender as? Producer
        
        case "segueToBeer":
            let destController = segue.destination as! BeerViewController
            destController.aModel = model
            destController.aBeer = sender as? Beer
        default:
            break
        }
        
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexpath: Int) -> CGFloat {
            return 100
    }
    func tableView(_ tableView: UITableView, _ indexPath: IndexPath){
           let producer = model.producers[indexPath.section]
           let beer =  producer.beersCollect?[indexPath.row]
           performSegue(withIdentifier: "segueToBeer", sender: beer)
           
       }
       
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 44.0
       }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 48.0
       }
    override func tableView(_ tableView: UITableView,  heightForFooterInSection section: Int) -> CGFloat {
           return CGFloat.leastNormalMagnitude
       }
}

