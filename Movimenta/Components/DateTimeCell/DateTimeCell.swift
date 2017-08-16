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
    applyTheme()
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    label.font = theme.font6
    label.textColor = theme.darkTextColor
    contentView.layoutMargins = UIEdgeInsets(
      top: 0, left: CGFloat(theme.space7),
      bottom: 0, right: CGFloat(theme.space7))
  }
  
  func set(dateTime: DateRange) {
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
