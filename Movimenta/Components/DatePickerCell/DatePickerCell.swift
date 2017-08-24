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
}

class DatePickerCell: UITableViewCell {
  static let identifier: String = DatePickerCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
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
  
  var configuration = Configuration()
  
  weak var delegate: DatePickerCellDelegate? = nil
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
    applyTheme()
    refreshSpaces()
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
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    refreshDatePickerVisibility()
  }
  
  func refreshDatePickerVisibility() {
    superviewBottomToSeparatorTopConstraint.isActive = !isSelected
    superviewBottomToDatePickerBottomConstraint.isActive = isSelected
    UIView.animate(withDuration: 0.3) {
      self.layoutIfNeeded()
    }
    delegate?.datePickerCellDidUpdatePickerVisibility(self, isVisible: isSelected)
  }
  
  // MARK: APIs
  func set(date: Date, animated: Bool = false) {
    datePicker.setDate(date, animated: animated)
    dateSelectionChange(datePicker)
  }
  
  // MARK: Actions
  func dateSelectionChange(_ datePicker: UIDatePicker) {
    dateLabel.text = datePicker.date.formattedDate(format: "d' 'MMM' 'yyyy")
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
  }
}
