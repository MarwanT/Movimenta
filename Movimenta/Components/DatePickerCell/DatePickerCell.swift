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
  
  var configuration = Configuration()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

//MARK: Configuration declaration
extension DatePickerCell {
  struct Configuration {
    var layoutMargins = UIEdgeInsets(
      top: CGFloat(ThemeManager.shared.current.space8),
      left: CGFloat(ThemeManager.shared.current.space7),
      bottom: CGFloat(ThemeManager.shared.current.space8),
      right: CGFloat(ThemeManager.shared.current.space7))
    var mode: UIDatePickerMode = .date
  }
}
