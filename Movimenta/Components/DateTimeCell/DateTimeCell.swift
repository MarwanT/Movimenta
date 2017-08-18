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
  @IBOutlet weak var addToCalendarLabel: UILabel!
  @IBOutlet weak var addToCalendarTopToDateLabelBottomConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    applyTheme()
    setup()
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    selectedBackgroundView = UIImageView(image: theme.color6.image())
    label.font = theme.font6
    label.textColor = theme.darkTextColor
    addToCalendarLabel.font = theme.font12
    addToCalendarLabel.textColor = theme.color2
    contentView.layoutMargins = UIEdgeInsets(
      top: CGFloat(theme.space2), left: CGFloat(theme.space7),
      bottom: CGFloat(theme.space2), right: CGFloat(theme.space7))
    addToCalendarTopToDateLabelBottomConstraint.constant = CGFloat(theme.space3)
    layoutIfNeeded()
  }
  
  private func setup() {
    addToCalendarLabel.text = Strings.add_to_calendar().uppercased()
  }
  
  func set(dateTime: DateRange) {
    label.text = dateTime.displayedLabel
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
