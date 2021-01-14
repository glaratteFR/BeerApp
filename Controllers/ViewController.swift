//
//  ViewController.swift
//  BeerApp
//
//  Created by Grégoire LARATTE on 26/12/20.
//

import UIKit


class ViewController: UITableViewController {
    //zzzzzzzzzzzzzzzzz
    @IBOutlet weak var addProdButt: UIButton!
    
    @IBOutlet weak var addBeerButt: UIButton!
    @IBOutlet weak var delBeerButt: UIButton!
    
    var model = Model()
    var editingStyle:UITableViewCell.EditingStyle?
    public var indexBeer = 2
    override func viewDidLoad() {
        super.viewDidLoad()
   
        model.producers = model.producersNamed.map { (name, producer) in
            return producer
        }
        model.producers.sort{$0.nameProducer < $1.nameProducer}
        
        model.producers.forEach{ b in b.beersCollect?.sort(by: {($0.nameBeer) < ($1.nameBeer)})}
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.appEnterBackGround(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        
        self.editingStyle = UITableViewCell.EditingStyle.none
        tableView.reloadData()
        
        
            
    }//end view did load
    
    @objc func appEnterBackGround(notification: NSNotification){
            //update map
            model.producers.forEach{ model.producersNamed.updateValue($0, forKey: $0.nameProducer)}
            
        
           if !model.writeProducersInfosToDocuments(model.NAME_OF_PRODUCERS_FILE_IN_DOCUMENTS, folder: model.NAME_OF_FOLDER_IN_DOCUMENTS){
               notifyUser(self, alertTitle: "IO Error", alertMessage: "Error When Writting Producers", runOnOK: {_ in})
               
           }else{
               print("Producer is saved Correctly")
               
           }
            
       }
    
    @IBAction func returnfromDetail(segue:UIStoryboardSegue)->Void{
        if model.alert == true{
            self.dismiss(animated: false, completion: nil)
            notifyUser(self, alertTitle: "Repetition Alert", alertMessage: "This producter already exist", runOnOK: {_ in})
            
        }
        
        model.producers.forEach{ b in b.beersCollect?.sort(by: {($0.nameBeer) < ($1.nameBeer)})}
        model.producers = duplicationOfBeers(model.producers, self)
        model.producers.sort{$0.nameProducer < $1.nameProducer}
        
       
        tableView.reloadData()
       }
       
       @IBAction func addBeerAct(_ sender: Any){
        
           if self.editingStyle == UITableViewCell.EditingStyle.none{
                   self.editingStyle = .insert
                   addBeerButt.setTitle("Done", for: .normal)
                   delBeerButt.isEnabled = false
                   tableView.setEditing(true, animated: true)
                   
           }else if self.editingStyle == .insert{
                   
                   self.editingStyle = UITableViewCell.EditingStyle.none

                   delBeerButt.isEnabled = true
                   addBeerButt.setTitle("Add Beer", for: .normal)
                   tableView.setEditing(false, animated: true)
                   
               }
           
       }
       
    @IBAction func addProdAct(_ sender: Any) {
        performSegue(withIdentifier: "segueToProducer", sender: "addProducer")
        
    }
    
    
       @IBAction func delBeerAct(_ sender: Any){

        tableView.headerView(forSection: model.producers.count - 1)
        tableView.reloadData()
        
        
           if self.editingStyle == UITableViewCell.EditingStyle.none{
               
               
                   self.editingStyle = .delete
                   delBeerButt.setTitle("Done", for: .normal)
                   addBeerButt.isEnabled = false
                   tableView.setEditing(true, animated: true)
                   
           }else if self.editingStyle == .delete{
                   
                   self.editingStyle = UITableViewCell.EditingStyle.none
                   addBeerButt.isEnabled = true
                   delBeerButt.setTitle("Remove Beer", for: .normal)
                   tableView.setEditing(false, animated: true)
                   
               }
           
       }
    
    //Return for a given moment the sate of table (editing, none...)
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return self.editingStyle!
        

    }
    
    
    //The producer affected by deletion or addition
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        let section = indexPath.section
        let row = indexPath.row
        let producer = model.producers[section]
        
        switch self.editingStyle! {
        case .none:
            break
        case .insert:
            let b = Beer()
            b.producerBeer = producer.nameProducer
            
            producer.beersCollect?.insert(b, at: row + 1)
            producer.beersCollect?.sort(by: {($0.nameBeer) < ($1.nameBeer)})
            
            tableView.insertRows(at: [indexPath], with: .fade)
            tableView.reloadSections(IndexSet(integer: section), with: .fade)
            tableView.reloadData()
        case .delete:
            producer.beersCollect?.remove(at: row)
            tableView.deleteRows(at: [indexPath], with:.fade)
            tableView.reloadData()
        @unknown default:
            break
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int{
       return model.producers.count
      
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
        if let pic = b?.pictureBeer{
            cell.mainPhoto.image = UIImage(data: pic)
                
            }
            if let name = b?.nameBeer{
                cell.mainLabel.text = name
                
            }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let producer = model.producers[section]

        let headerView = Bundle.main.loadNibNamed("TableViewHeader", owner: self, options: nil)?.first as! TableViewHeader
        headerView.ProducerLabel.text = producer.nameProducer
        headerView.tag = section
    
        let tapRec = UITapGestureRecognizer(target: self,action: #selector(ViewController.jumpToProducerView(_:)))
        tapRec.numberOfTapsRequired = 1

            headerView.addGestureRecognizer(tapRec)
        
        return headerView
    }
    @objc func jumpToProducerView(_ sender:UIGestureRecognizer){
        
        
        if sender.state == .ended{
            guard
                let n = sender.view?.tag
                else {
                return
            }
            performSegue(withIdentifier: "segueToProducer", sender: model.producers[n])
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
    
    var selectedBeer: Beer?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let producer = model.producers[indexPath.section]
        _ = indexPath.section
        
        let beerLine =  producer.beersCollect?[indexPath.row]
        
        
        selectedBeer = beerLine
        performSegue(withIdentifier: "segueToBeer", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        switch segue.identifier! {
        case "segueToProducer":
            _ = segue.destination as! ProducerViewController
            
            if sender as? String == "addProducer"
            {
                let destController = segue.destination as! ProducerViewController
                destController.aModel = model
                destController.aAction = (sender as? String)!
                
            }
            else
            {
                let destController = segue.destination as! ProducerViewController
                destController.aProducer = sender as? Producer
                
            }
            
        
        case "segueToBeer":
            let destController = segue.destination as! BeerViewController
            destController.aModel = model
            destController.aBeer = selectedBeer
        default:
            break
        }
  
    }
    
       
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 44.0
       }

    override func tableView(_ tableView: UITableView,  heightForFooterInSection section: Int) -> CGFloat {
           return CGFloat.leastNormalMagnitude
       }
}





func duplicationOfBeers(_ producers:[Producer], _ viewController:UIViewController) -> [Producer]
    {

    _ = Set<String>()
    _ = [String: Producer]()
     var allBears:[Beer] = []
    
     producers.forEach {(value) in
        if value.beersCollect != nil{
            allBears+=value.beersCollect!
            
        }
         
         
     }
      allBears = allBears.sorted(by: { $0.nameBeer < $1.nameBeer})
    
     
     for (index, bear) in allBears.enumerated() {
         if !(index==allBears.count-1){
             
             
             var nameBeerCurrent = String(bear.nameBeer)

            let nameBeerNext = allBears[index+1].nameBeer
             nameBeerCurrent = allBears[index].nameBeer
             if (nameBeerNext.elementsEqual(nameBeerCurrent))
             {
    
                
                let indexProducerDupli = producers.enumerated().filter({($0.element.beersCollect?.contains(allBears[index]))!}).map({$0.offset})[0]
                
                let indexBeerDupli = producers[indexProducerDupli].beersCollect?.enumerated().filter({($0.element.IDBeer == allBears[index].IDBeer)}).map({$0.offset})[0]
                
                
            
                var tempInteger = Int((producers[indexProducerDupli].beersCollect?[indexBeerDupli!].duplicate)!)
                tempInteger! += 1
                
                producers[indexProducerDupli].beersCollect?[indexBeerDupli!].duplicate  = String(tempInteger!)
                    
                producers[indexProducerDupli].beersCollect![indexBeerDupli!].nameBeer = producers[indexProducerDupli].beersCollect![indexBeerDupli!].nameBeer + "_" + producers[indexProducerDupli].beersCollect![indexBeerDupli!].duplicate
                        
                    
                if (allBears.enumerated().filter({$0.element.nameBeer == producers[indexProducerDupli].beersCollect![indexBeerDupli!].nameBeer }).map({$0.offset}).count == 2)
                    {
                    var tempInteger = Int ((producers[indexProducerDupli].beersCollect?[indexBeerDupli!].duplicate)! )
                    tempInteger! += 1
                    producers[indexProducerDupli].beersCollect?[indexBeerDupli!].duplicate = String(tempInteger!)
                    
                    producers[indexProducerDupli].beersCollect?[indexBeerDupli!].nameBeer = allBears[index].nameBeer + "_" + producers[indexProducerDupli].beersCollect![indexBeerDupli!].duplicate
                        
                    }
                    
                if (producers[indexProducerDupli].beersCollect?[indexBeerDupli!].duplicate == "3")
                        {
    
                        producers[indexProducerDupli].beersCollect?.remove(at: indexBeerDupli!)
                    viewController.dismiss(animated: false, completion: nil)
                    notifyUser(viewController, alertTitle: "Repetition Alert", alertMessage: "Can't have 3 similar beers", runOnOK: {_ in})
                        
                    }
    

                    producers[indexProducerDupli].beersCollect = producers[indexProducerDupli].beersCollect!.sorted(by: { $0.nameBeer < $1.nameBeer})
                    
                        
                    
                 }
   
                     

                }
             }

                
    let producersSort = producers.sorted(by: { $0.nameProducer < $1.nameProducer})
    return producersSort
}
