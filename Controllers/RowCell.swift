//
//  RowCell.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 29/12/20.
//

import Foundation
import UIKit

class RowCell: UITableViewCell {
    
    @IBOutlet weak var beerPic: UIImageView!
    @IBOutlet weak var beerLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
