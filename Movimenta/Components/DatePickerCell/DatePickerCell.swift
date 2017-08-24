//
//  DatePickerCell.swift
//  Movimenta
//
//  Created by Marwan  on 8/24/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

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
  
}
