//
//  DatePickerCell.swift
//  Movimenta
//
//  Created by Marwan  on 8/24/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

protocol DatePickerCellDelegate: class {
  func datePickerCellDidUpdatePickerVisibility(_ cell: DatePickerCell, isVisible: Bool)
  func datePickerCellDidSelectDate(_ cell: DatePickerCell, date: Date)
}

class DatePickerCell: UITableViewCell {
  static let identifier: String = DatePickerCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  class func instanceFromNib() -> DatePickerCell {
    return UINib(nibName: identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DatePickerCell
  }
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var separator: UIView!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  @IBOutlet weak var dateLabelTrailingToSuperviewMarginConstraint: NSLayoutConstraint!
  @IBOutlet weak var separatorTopToDateLabelBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var datePickerTopConstraintToSeparatorBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var datePickerTrailingToSuperviewMarginConstraint: NSLayoutConstraint!
  @IBOutlet weak var superviewBottomToSeparatorTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var superviewBottomToDatePickerBottomConstraint: NSLayoutConstraint!
  
  var configuration = Configuration() {
    didSet {
      refreshLabel()
      refreshSpaces()
    }
  }
  
  weak var delegate: DatePickerCellDelegate? = nil
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
    applyTheme()
    refreshSpaces()
    refreshLabel()
  }
  
  private func setup() {
    datePicker.datePickerMode = .date
    datePicker.addTarget(self, action: #selector(dateSelectionChange(_:)), for: UIControlEvents.valueChanged)
    set(date: Date())
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    label.font = theme.font9
    label.textColor = theme.darkTextColor
    dateLabel.font = theme.font9
    dateLabel.textColor = theme.darkTextColor
    separator.backgroundColor = theme.separatorColor
    datePicker.setValue(theme.darkTextColor, forKey: #keyPath(UILabel.textColor))
    selectionStyle = .none
    clipsToBounds = true
  }
  
  fileprivate func refreshSpaces() {
    contentView.layoutMargins = configuration.layoutMargins
    separatorTopToDateLabelBottomConstraint.constant = configuration.layoutMargins.bottom
    datePickerTopConstraintToSeparatorBottomConstraint.constant = configuration.layoutMargins.bottom
    datePickerTrailingToSuperviewMarginConstraint.constant = configuration.subviewsTrailingMargin
    dateLabelTrailingToSuperviewMarginConstraint.constant = configuration.subviewsTrailingMargin
    layoutIfNeeded()
  }
  
  fileprivate func refreshLabel() {
    label.text = configuration.labelText
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    refreshViewForSelection()
  }
  
  func refreshViewForSelection() {
    refreshDatePickerVisibility()
    
    let theme = ThemeManager.shared.current
    dateLabel.textColor = isSelected ? theme.color2 : theme.darkTextColor
  }
  
  func refreshDatePickerVisibility() {
    var layoutDidChange = false
    if isSelected {
      if superviewBottomToSeparatorTopConstraint.isActive {
        superviewBottomToSeparatorTopConstraint.isActive = false
        layoutDidChange = true
      }
      if !superviewBottomToDatePickerBottomConstraint.isActive {
        superviewBottomToDatePickerBottomConstraint.isActive = true
        layoutDidChange = true
      }
    } else {
      if superviewBottomToDatePickerBottomConstraint.isActive {
        superviewBottomToDatePickerBottomConstraint.isActive = false
        layoutDidChange = true
      }
      if !superviewBottomToSeparatorTopConstraint.isActive {
        superviewBottomToSeparatorTopConstraint.isActive = true
        layoutDidChange = true
      }
    }
    
    if layoutDidChange {
      UIView.animate(withDuration: 0.3) {
        self.layoutIfNeeded()
      }
      delegate?.datePickerCellDidUpdatePickerVisibility(self, isVisible: isSelected)
    }
  }
  
  // MARK: APIs
  func set(date: Date, animated: Bool = false) {
    dateLabel.text = date.formattedDate(format: "d' 'MMM' 'yyyy")
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
    dateLabel.text = datePicker.date.formattedDate(format: "d' 'MMM' 'yyyy")
    delegate?.datePickerCellDidSelectDate(self, date: datePicker.date)
  }
}

//MARK: Configuration declaration
extension DatePickerCell {
  struct Configuration {
    var layoutMargins = UIEdgeInsets(
      top: CGFloat(ThemeManager.shared.current.space8),
      left: CGFloat(ThemeManager.shared.current.space7),
      bottom: CGFloat(ThemeManager.shared.current.space8),
      right: 0)
    var subviewsTrailingMargin = CGFloat(ThemeManager.shared.current.space7)
    var labelText = "Date"
  }
}
