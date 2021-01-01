//
//  MyCustomCell.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 1/1/21.
//

import UIKit
class MyCustomCell: UITableViewCell {
@IBOutlet weak var lblFirstName: UILabel!
@IBOutlet weak var lblLastName: UILabel!
override func awakeFromNib() {
super.awakeFromNib()
// Initialization code
}
override func setSelected(_ selected: Bool, animated: Bool) {
super.setSelected(selected, animated: animated)
// Configure the view for the selected state
}
}
