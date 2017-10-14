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
    initialize()
  }
  
  private func initialize() {
    datePicker.datePickerMode = .date
    datePicker.addTarget(self, action: #selector(dateSelectionChange(_:)), for: .valueChanged)
    set(date: Date())
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: APIs
  func set(date: Date, animated: Bool = false) {
    datePicker.setDate(date, animated: animated)
  }
  
  // MARK: Actions
  func dateSelectionChange(_ datePicker: UIDatePicker) {
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
