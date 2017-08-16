//
//  DateTimeCell.swift
//  Movimenta
//
//  Created by Marwan  on 8/16/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class DateTimeCell: UITableViewCell {
  static let identifier: String = DateTimeCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
  @IBOutlet weak var label: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
