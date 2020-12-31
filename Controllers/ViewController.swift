//
//  ViewController.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 26/12/20.
//

import UIKit


class ViewController: UIViewController {

    
    
    
    
    @IBOutlet weak var addBeerButt: UIButton!
    @IBOutlet weak var delBeerButt: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var model = Model()
    var editingStyle:UITableViewCell.EditingStyle?//?¿
    
    
    let TABLE_SECTION_HEADER = "TableSectionHeader"
    let ROW_CELL = "RowCell"
    let SEGUE_TO_PRODUCER = "segueToProducer"
    let SEGUE_TO_BEER = "segueToBeer"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.appEnterBackGround(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)//When app goes background/ends saves data
        
        self.editingStyle = UITableViewCell.EditingStyle.none//Look up style
        print("%Editing style  None")
        /*
         Posibilidad debug
         */
        
        let nib = UINib(nibName: TABLE_SECTION_HEADER, bundle: nil)//?¿
   
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: TABLE_SECTION_HEADER)

    }//end viewDidLoad()


    @objc func appEnterBackGround(notification: NSNotification){
        print("%App passed to background")
        if !model.writeProducersInfosToDocuments(model.NAME_OF_PRODUCERS_FILE_IN_DOCUMENTS, folder: model.NAME_OF_FOLDER_IN_DOCUMENTS){
            notifyUser(self, alertTitle: "IO Error", alertMessage: "Error When Writting Producers", runOnOK: {_ in})
            
        }else{
            print("%Producers Saved Correctly")
            
        }
         
    }
    
    @IBAction func returnfromDetail(segue:UIStoryboardSegue)->Void{//Method for returning from Segues
        model.producers.forEach{ b in b.beersCollect?.sort(by: {($0.nameBeer) < ($1.nameBeer)})}
        tableView.reloadData()
    }
    
    
    //Functions for buttons
    @IBAction func addBeerAct(_ sender: Any){
        print("             #Vamos a añadir una cerveza")
        if self.editingStyle == UITableViewCell.EditingStyle.none{
            print("             #Estilo de edit activado")
            print("%Number of beers --> \(model.allBeers.count)")
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
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        //return self.editingStyle ?? .none
        return self.editingStyle!
        

    }
    
    //The producer affected by deletion or addition
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
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
        case .delete:
            producer.beersCollect?.remove(at: row)
            tableView.deleteRows(at: [indexPath], with:.fade)
            tableView.reloadData()
        @unknown default:
            break
        }
        
    }

}//end view controller class



extension ViewController : UITableViewDataSource{
    
    //section for ech producer
    func numSect(in tableView: UITableView) -> Int{
        print("%Number of sections --> \(model.producers.count)")
        return model.producers.count
    }
    //number of beers for producer
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let producerNumber = section
        let producer = model.producers[producerNumber]
        return producer.beersCollect?.count ?? 0
    }
    
    //Cell for eachRow
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       print("METODO TABLEVIEW DATA-SOURCE")
        let producerNum = indexPath.section
        let producer = model.producers[producerNum]
        
        let b = producer.beersCollect?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ROW_CELL) as! RowCell
        cell.beerLabel.text = "HOOOOOLA"
        
        //MAL CORREGIR
        if let pic = b?.pictureBeer{
            cell.beerPic.image = pic
            
        }
        if let name = b?.nameBeer{
            //cell.beerLabel.text = name
            cell.beerLabel.text = "HOOOOOLA"
            print("%Label --> \(cell.beerLabel.text)")
        }
        return cell
        
    }
    //Give form of headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let producer = model.producers[section]
        let plainHeaderView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: TABLE_SECTION_HEADER)
        plainHeaderView?.tag = section
        let customHeaderView = plainHeaderView as! TableSectionHeader//??
        
        customHeaderView.producerNameLabel.text = producer.nameProducer//¿??
        customHeaderView.producerImage.image = producer.logoProducer//??
        customHeaderView.producerNameLabel.text = "EEEEOOOOo"
        
        let tapRec = UITapGestureRecognizer(target: self,action: #selector(ViewController.jumpToProducerView(_:)))
        tapRec.numberOfTapsRequired = 1

        customHeaderView.addGestureRecognizer(tapRec)//??
        
        return customHeaderView
    }
    
    @objc func jumpToProducerView(_ sender:UIGestureRecognizer){//revisar video para entender
        
        if sender.state == .ended{
            guard
                let n = sender.view?.tag
                else {
                return
            }
            performSegue(withIdentifier: SEGUE_TO_PRODUCER, sender: model.producers[n])
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        switch segue.identifier! {
        case SEGUE_TO_PRODUCER:
            let destController = segue.destination as! ProducerViewController
            destController.aProducer = sender as? Producer
        
        case SEGUE_TO_BEER:
            let destController = segue.destination as! BeerViewController
            destController.aModel = model
            destController.aBeer = sender as? Beer
        default:
            break
        }
        
    }
    
}//end of extension Viewcontroller


extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, _ indexPath: IndexPath){
        let producer = model.producers[indexPath.section]
        let beer =  producer.beersCollect?[indexPath.row]
        performSegue(withIdentifier: SEGUE_TO_BEER, sender: beer)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48.0
    }
    func tableView(_ tableView: UITableView,  heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}


