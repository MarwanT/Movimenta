//
//  DateCell.swift
//  Movimenta
//
//  Created by Marwan  on 8/24/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {
  static let identifier: String = DateCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  class func instanceFromNib() -> DateCell {
    return UINib(nibName: identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DateCell
  }
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  var configuration = Configuration() {
    didSet {
      refreshLabel()
      refreshSpaces()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
    applyTheme()
    refreshSpaces()
    refreshLabel()
  }
  
  private func setup() {
    set(date: Date())
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    label.font = theme.font9
    label.textColor = theme.darkTextColor
    dateLabel.font = theme.font9
    dateLabel.textColor = theme.darkTextColor
    selectionStyle = .none
    clipsToBounds = true
  }
  
  fileprivate func refreshSpaces() {
    contentView.layoutMargins = configuration.layoutMargins
  }
  
  fileprivate func refreshLabel() {
    label.text = configuration.labelText
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    refreshViewForSelection()
  }
  
  func refreshViewForSelection() {
    let theme = ThemeManager.shared.current
    dateLabel.textColor = isSelected ? theme.color2 : theme.darkTextColor
  }
  
  // MARK: APIs
  func set(date: Date, animated: Bool = false) {
    dateLabel.text = date.formattedDate(format: "d' 'MMM' 'yyyy")
  }
}

//MARK: Configuration declaration
extension DateCell {
  struct Configuration {
    var layoutMargins = UIEdgeInsets(
      top: CGFloat(ThemeManager.shared.current.space8),
      left: CGFloat(ThemeManager.shared.current.space7),
      bottom: CGFloat(ThemeManager.shared.current.space8),
      right: CGFloat(ThemeManager.shared.current.space7))
    var labelText = "Date"
  }
}
