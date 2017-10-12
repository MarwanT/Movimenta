//
//  InformationCell.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

protocol InformationCellDelegate: class {
  func informationCellDidTapViewButton(_ cell: InformationCell)
}

class InformationCell: UITableViewCell {
  static let identifier: String = InformationCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var displayImageView: UIImageView!
  @IBOutlet weak var websiteLabel: UILabel!
  
  weak var delegate: InformationCellDelegate?

  var configuration = Configuration()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.layoutMargins = configuration.layoutMargins
    initialize()
    applyTheme()
  }
  
  private func initialize() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapWebsiteLabel(_:)))
    websiteLabel.addGestureRecognizer(tapGesture)
    websiteLabel.isUserInteractionEnabled = true
  }
  
  func didTapWebsiteLabel(_ sender: Any) {
    delegate?.informationCellDidTapViewButton(self)
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
      displayImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "imagePlaceholderLarge"))
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

