//
//  InformationCell.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class InformationCell: UITableViewCell {
  static let identifier: String = InformationCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var displayImageView: UIImageView!
  @IBOutlet weak var websiteLabel: UILabel!

  var configuration = Configuration()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.layoutMargins = configuration.layoutMargins
    applyTheme()
  }

  private func applyTheme() {
    let theme = ThemeManager.shared.current
    titleLabel.font = theme.font4
    websiteLabel.font = theme.font12

    titleLabel.textColor = theme.darkTextColor
    websiteLabel.textColor = theme.color2
  }

  public func set(imageURL: String?, title: String?) {
    if let imageURL = imageURL, let url = URL(string: imageURL) {
      displayImageView.sd_setImage(with: url)
    }
    titleLabel.text = title
    websiteLabel.text = Strings.view_website()
  }
}

//MARK: Configuration
extension InformationCell {
  struct Configuration {
    var layoutMargins = UIEdgeInsets(
      top: CGFloat(ThemeManager.shared.current.space4),
      left: CGFloat(ThemeManager.shared.current.space7),
      bottom: CGFloat(ThemeManager.shared.current.space4),
      right: CGFloat(ThemeManager.shared.current.space7))
  }
}

