//
//  ExpandableHeaderCell.swift
//  Movimenta
//
//  Created by Marwan  on 8/28/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class ExpandableHeaderCell: UITableViewCell {
  static let identifier: String = ExpandableHeaderCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var arrowImageView: UIImageView!
  
  var configuration = Configuration()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
    applyTheme()
  }
  
  private func setup() {
    arrowImageView.image = #imageLiteral(resourceName: "arrowDown")
    selectionStyle = .none
    contentView.layoutMargins = configuration.layoutMargins
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    label.font = theme.font9
    label.textColor = theme.darkTextColor
    arrowImageView.tintColor = theme.color5
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    refreshForSelection()
  }
  
  private func refreshForSelection() {
    let theme = ThemeManager.shared.current
    
    if self.isSelected {
      label.font = theme.font8
      hideSeparator()
      UIView.animate(withDuration: theme.animationDuration) {
        self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      }
    } else {
      label.font = theme.font9
      showSeparator()
      UIView.animate(withDuration: theme.animationDuration) {
        self.arrowImageView.transform = CGAffineTransform.identity
      }
    }
  }
  
  override func showSeparator() {
    separatorInset = configuration.defaultSeparatorInset
  }
}

extension ExpandableHeaderCell {
  struct Configuration {
    var layoutMargins = UIEdgeInsets(
      top: CGFloat(ThemeManager.shared.current.space8),
      left: CGFloat(ThemeManager.shared.current.space7),
      bottom: CGFloat(ThemeManager.shared.current.space8),
      right: CGFloat(ThemeManager.shared.current.space7))
    fileprivate var defaultSeparatorInset = UIEdgeInsets(
      top: 0, left: CGFloat(ThemeManager.shared.current.space7), bottom: 0, right: 0)
  }
}
