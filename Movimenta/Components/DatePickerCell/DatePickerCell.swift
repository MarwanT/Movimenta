//
//  DatePickerCell.swift
//  Movimenta
//
//  Created by Marwan  on 10/14/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class DatePickerCell: UITableViewCell {
  @IBOutlet weak var datePicker: UIDatePicker!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
