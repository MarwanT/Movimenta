//
//  PartnerCell.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class PartnerCell: UITableViewCell {
  static let identifier: String = PartnerCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)

  @IBOutlet weak var partnerImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!

  var configuration = Configuration()

  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.layoutMargins = configuration.layoutMargins
    applyTheme()
  }

  private func applyTheme() {
    let theme = ThemeManager.shared.current
    titleLabel.font = theme.font4
    descriptionLabel.font = theme.font6

    titleLabel.textColor = theme.darkTextColor
    descriptionLabel.textColor = theme.darkTextColor
  }

  public func setup(title: String?, description: String?, imageURL: String?) {
    titleLabel.text = title
    descriptionLabel.text = description

    if let imageURL = imageURL, let url = URL(string: imageURL) {
      partnerImageView.sd_setImage(with: url)
    }
  }
}

//MARK: Configuration
extension PartnerCell {
  struct Configuration {
    var layoutMargins = UIEdgeInsets(
      top: CGFloat(ThemeManager.shared.current.space4),
      left: CGFloat(ThemeManager.shared.current.space7),
      bottom: CGFloat(ThemeManager.shared.current.space4),
      right: CGFloat(ThemeManager.shared.current.space7))
  }
}
