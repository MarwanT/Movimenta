//
//  VenueCell.swift
//  Movimenta
//
//  Created by Marwan  on 8/16/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class VenueCell: UITableViewCell {
  static let identifier: String = VenueCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
  @IBOutlet weak var iconView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var locationLabelTopTitleLabelBottomConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    applyTheme()
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    selectedBackgroundView = UIImageView(image: theme.color6.image())
    titleLabel.font = theme.font5
    titleLabel.textColor = theme.color2
    locationLabel.font = theme.font6
    locationLabel.textColor = theme.darkTextColor
    locationLabelTopTitleLabelBottomConstraint.constant = CGFloat(theme.space2)
    contentView.layoutMargins = UIEdgeInsets(
      top: CGFloat(theme.space2), left: CGFloat(theme.space7),
      bottom: CGFloat(theme.space2), right: CGFloat(theme.space7))
    iconView.tintColor = theme.color2
    layoutIfNeeded()
  }
  
  func set(title: String?, location: String?) {
    titleLabel.text = title?.uppercased()
    locationLabel.text = location
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
