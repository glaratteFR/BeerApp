//
//  ViewController.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 26/12/20.
//

import UIKit


class ViewController: UITableViewController {

    
    @IBOutlet weak var addBeerButt: UIButton!
    @IBOutlet weak var delBeerButt: UIButton!
    
    var model = Model()
    var editingStyle:UITableViewCell.EditingStyle?
    public var indexBeer = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("6666666666666")
        print("-----------------------------")
        print(model.producersNamed)
        print(model.producersNamed.forEach{$0.value.beersCollect?.forEach{print("                        BEERS IN producersNAmed --> \($0.nameBeer)")}})
       
        print(model.producersNamed.first?.value.beersCollect?.count)
  
        print(model.producers.count)

   
        model.producers = model.producersNamed.map { (name, producer) in
            return producer
        }
        print(model.producers[0].beersCollect?.count)
       print(model.producers[0].beersCollect?[0].nameBeer)
        print(model.producers[0].beersCollect?[1].nameBeer)
        print(model.producers[0].beersCollect?[2].nameBeer)
        
        
 
        print("-----------------------------")
        print(model.producersNamed.forEach{print($0)})
        model.producers[0].beersCollect?.forEach{print("                        BEERS IN PRODUCERS --> \($0.nameBeer)")}
        
        
        

       
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.appEnterBackGround(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)//When app goes background/ends saves data
        
        
        self.editingStyle = UITableViewCell.EditingStyle.none//Look up style
        print("%Editing style  None")
        
        
        tableView.reloadData()
        
        
            
    }//end view did load
    
    @objc func appEnterBackGround(notification: NSNotification){
           print("%App passed to background")
            //update map
            model.producers.forEach{ model.producersNamed.updateValue($0, forKey: $0.nameProducer)}
            
        
           if !model.writeProducersInfosToDocuments(model.NAME_OF_PRODUCERS_FILE_IN_DOCUMENTS, folder: model.NAME_OF_FOLDER_IN_DOCUMENTS){
               notifyUser(self, alertTitle: "IO Error", alertMessage: "Error When Writting Producers", runOnOK: {_ in})
               
           }else{
               print("%Producers Saved Correctly")
               
           }
            
       }
    
    @IBAction func returnfromDetail(segue:UIStoryboardSegue)->Void{//Method for returning from Segues
           //model.producers.forEach{ b in b.beersCollect?.sort(by: {($0.nameBeer) < ($1.nameBeer)})}
            model.producers.forEach{ b in b.beersCollect?.sort(by: {($0.nameBeer) < ($1.nameBeer)})}
        model.producers = duplicateBeers(model.producers, self)
        model.producers = duplicateProducers(model.producers)
        tableView.reloadData()
       }
       
       
       //Functions for buttons
       @IBAction func addBeerAct(_ sender: Any){
           print("             #Vamos a añadir una cerveza")
        //model.producersNamed["Cervezas Segovia S.L"]!.beersCollect?.forEach{print("                        BEERS IN NAMED --> \($0.nameBeer)")}
        model.producersNamed.forEach{print("                        BEERS IN NAMED --> \($0.value.beersCollect!.forEach{print("                        BEERS IN NAMED --> \($0.nameBeer)")})")}
        
           if self.editingStyle == UITableViewCell.EditingStyle.none{
               print("             #Estilo de edit activado")
               print("%Number producers --> \(model.producers.count)")
                   self.editingStyle = .insert
                   addBeerButt.setTitle("Done", for: .normal)//¿?¿ Posible error
                   delBeerButt.isEnabled = false
                   tableView.setEditing(true, animated: true)
                   
           }else if self.editingStyle == .insert{
                   
                   self.editingStyle = UITableViewCell.EditingStyle.none

                   delBeerButt.isEnabled = true
                   addBeerButt.setTitle("Add Beer", for: .normal)//¿?¿ Posible error
                   tableView.setEditing(false, animated: true)
                   
               }
           
       }
       
       @IBAction func delBeerAct(_ sender: Any){
           
           if self.editingStyle == UITableViewCell.EditingStyle.none{
               
               
                   self.editingStyle = .delete
                   delBeerButt.setTitle("Done", for: .normal)//¿?¿ Posible error
                   addBeerButt.isEnabled = false
                   tableView.setEditing(true, animated: true)
                   
           }else if self.editingStyle == .delete{
                   
                   self.editingStyle = UITableViewCell.EditingStyle.none
                   addBeerButt.isEnabled = true
                   delBeerButt.setTitle("Remove Beer", for: .normal)//¿?¿ Posible error
                   tableView.setEditing(false, animated: true)
                   
               }
           
       }
    
    //Return for a given moment the sate of table (editing, none...)
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        //return self.editingStyle ?? .none
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
            
            //add to porducer list
            producer.beersCollect?.insert(b, at: row + 1)
            producer.beersCollect?.sort(by: {($0.nameBeer) < ($1.nameBeer)})
            
            //add to general list
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
       // let producerName = model.producers[producerNum].nameProducer
        //let producer = model.producersNamed[producerName]
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let producer = model.producers[section]
        let headerView = Bundle.main.loadNibNamed("TableViewHeader", owner: self, options: nil)?.first as! TableViewHeader
        headerView.ProducerLabel.text = producer.nameProducer
   // customHeaderView.producerImage.image = producer.logoProducer

    
        let tapRec = UITapGestureRecognizer(target: self,action: #selector(ViewController.jumpToProducerView(_:)))
        tapRec.numberOfTapsRequired = 1

            headerView.addGestureRecognizer(tapRec)//??
        
        return headerView
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
    

     func tableView(_ tableView: UITableView, heightForRowAt indexpath: Int) -> CGFloat {
            return 100
    }
    func tableView(_ tableView: UITableView, _ indexPath: IndexPath){
        print("ESTOY EN table view segue")
           let producer = model.producers[indexPath.section]
           let beer =  producer.beersCollect?[indexPath.row]
           performSegue(withIdentifier: "segueToBeer", sender: beer)
           
       }
    
    var selectedBeer: Beer?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let producer = model.producers[indexPath.section]
        let producerNum = indexPath.section
        
       // let producerName = model.producers[producerNum].nameProducer
       // let producer = model.producersNamed[producerName]
        
        
        let beerLine =  producer.beersCollect?[indexPath.row]
        
        
        selectedBeer = beerLine
        performSegue(withIdentifier: "segueToBeer", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        print("ESTOY EN PREPARE")
        switch segue.identifier! {
        case "segueToProducer":
            let destController = segue.destination as! ProducerViewController
            destController.aProducer = sender as? Producer
        
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


func duplicateBeers(_ producers:[Producer], _ viewController:UIViewController) -> [Producer]
    {

    var uniqueValues = Set<String>()
     var resultDict = [String: Producer]()
     var allBears:[Beer] = []

     
     producers.forEach {(value) in
         
         allBears+=value.beersCollect!
         
     }
      allBears = allBears.sorted(by: { $0.nameBeer < $1.nameBeer})
     var oldNameBeer = allBears[0].nameBeer
     print("aaaaaaaaaaaaaaaaaa")
     allBears.forEach{ print($0.nameBeer)}
     print(allBears.count)
     
     for (index, bear) in allBears.enumerated() {
         if !(index==allBears.count-1){
             
             
             var nameBeerCurrent = String(bear.nameBeer)

             var nameBeerNext = allBears[index+1].nameBeer
             print(allBears[index+1].nameBeer)
             nameBeerCurrent = allBears[index].nameBeer
             print(nameBeerNext==nameBeerCurrent)
             if (nameBeerNext.elementsEqual(nameBeerCurrent))
             {
                 print("okkkkkk")
                 if (allBears[index].capBeer == allBears[index+1].capBeer && allBears[index].expDateBeer == allBears[index+1].expDateBeer && allBears[index].nationalityBeer == allBears[index+1].nationalityBeer && allBears[index].rateBeer == allBears[index+1].rateBeer){
                     print("the same beer exist !!!!")
                    var nameProducer = allBears[index].producerBeer
                    var nameBearDupli = allBears[index].nameBeer
                    var duplica = false
                    for (indexProducer,element) in producers.enumerated(){
                        if element.nameProducer == nameProducer {
                            for (indexBear,beer) in element.beersCollect!.enumerated(){
                                if (allBears[indexBear].nameBeer==nameBearDupli){
                                
                                    producers[indexProducer].beersCollect![indexBear].duplicate += 1
                        
                
                                    }
                                    producers[indexProducer].beersCollect![indexBear].nameBeer = beer.nameBeer + "_" + String(producers[indexProducer].beersCollect![indexBear].duplicate)
                                var bear:[Beer]
                                bear = allBears.filter{$0.nameBeer == producers[indexProducer].beersCollect![indexBear].nameBeer}
                                    
                                if (bear.count == 2)
                                {
                                        print(bear)
                                        producers[indexProducer].beersCollect?[indexBear].duplicate += 1;                                        producers[indexProducer].beersCollect![indexBear].nameBeer = beer.nameBeer + "_" + String(producers[indexProducer].beersCollect![indexBear].duplicate)
                                }
                                if (producers[indexProducer].beersCollect?[indexBear].duplicate == 3)
                                {
                                    print("REMOVEEEEEE")
                                    producers[indexProducer].beersCollect?.remove(at: indexBear)
                                    print("REMOVEEEEEE")
                                    notifyUser(viewController, alertTitle: "Repetiotion Alert", alertMessage: "Cant have more of three copiees of the sqme beer", runOnOK: {_ in})
                                }
                                producers[indexProducer].beersCollect = producers[indexProducer].beersCollect!.sorted(by: { $0.nameBeer < $1.nameBeer})
                                
                                /*
                                 producers = producers.sorted(by: { $0.nameProducer < $1.nameProducer})
                                 
                                 */

                                var commit = "ffff"
                                duplica = true
                                    break
                                }
                            }
                        if (duplica == true){
                            duplica = false
                            break
                        }
                            
                        }
                     
                    }
                    }

                     
                 }
        
             }
        
        
        return producers
}



func duplicateProducers(_ producers:[Producer]) -> [Producer]
{

var uniqueValues = Set<String>()
 var resultDict = [String: Producer]()

 

   var producers = producers.sorted(by: { $0.nameProducer < $1.nameProducer})
 var indexProducer = 2
 var oldNameProducer = producers[0].nameProducer
 
 for (index, producer) in producers.enumerated() {
     if !(index==producers.count-1){
         
         
        var nameProducerCurrent = String(producer.nameProducer)

         var nameProducerNext = producers[index+1].nameProducer
    
        nameProducerCurrent = producers[index].nameProducer
     
         if (nameProducerNext.elementsEqual(nameProducerCurrent))
             {
            producers[index].nameProducer = nameProducerCurrent + "_" + String(indexProducer)
             }
        
        if (oldNameProducer == producers[index].nameProducer)
        {
            indexProducer = indexProducer+1
            oldNameProducer = producers[index].nameProducer
            
        }else{
            indexProducer = 2
        }
         }
    
    
 }
    return producers
}

