//
//  DatePickerCell.swift
//  Movimenta
//
//  Created by Marwan  on 10/14/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

protocol DatePickerCellDelegate: class  {
  func datePickerCell(_ cell: DatePickerCell, didSelect date: Date)
}

class DatePickerCell: UITableViewCell {
  @IBOutlet weak var datePicker: UIDatePicker!
  
  var configuration = Configuration()
  
  var delegate: DatePickerCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initialize()
    applyTheme()
  }
  
  private func initialize() {
    selectionStyle = .none
    datePicker.datePickerMode = .date
    datePicker.addTarget(self, action: #selector(dateSelectionChange(_:)), for: .valueChanged)
    set(date: Date())
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    datePicker.setValue(theme.darkTextColor, forKey: #keyPath(UILabel.textColor))
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: APIs
  func set(date: Date, animated: Bool = false) {
    datePicker.setDate(date, animated: animated)
  }
  
  func set(minimumDate: Date?) {
    datePicker.minimumDate = minimumDate
  }
  
  func set(maximumDate: Date?) {
    datePicker.maximumDate = maximumDate
  }
  
  // MARK: Actions
  func dateSelectionChange(_ datePicker: UIDatePicker) {
    delegate?.datePickerCell(self, didSelect: datePicker.date)
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
