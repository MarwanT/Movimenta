//
//  ParticipantDetailsHeaderView.swift
//  Movimenta
//
//  Created by Marwan  on 9/11/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class ParticipantDetailsHeaderView: UIView {
  typealias DetailsData = (image: URL?, name: String?, roles: String?, description: String?)
  
  @IBOutlet weak var detailsStackView: UIStackView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var labelsContainerView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var rolesLabel: UILabel!
  @IBOutlet weak var descriptionLabel: ExpandableLabel!

  
  class func instanceFromNib() -> ParticipantDetailsHeaderView {
    return UINib(nibName: ParticipantDetailsHeaderView.defaultNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ParticipantDetailsHeaderView
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initialize()
    applyTheme()
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    labelsContainerView.layoutMargins = UIEdgeInsets(top: CGFloat(theme.space7), left: CGFloat(theme.space7), bottom: CGFloat(theme.space7), right: CGFloat(theme.space7))
    nameLabel.font = theme.font1
    nameLabel.textColor = theme.darkTextColor
    rolesLabel.font = theme.font12
    rolesLabel.textColor = theme.darkTextColor
    descriptionLabel.font = theme.font6
    descriptionLabel.textColor = theme.darkTextColor
    descriptionLabel.configuration.setMinimumNumberOfLines(4)
    imageView.backgroundColor = theme.color6
    imageView.clipsToBounds = true
  }
  
  private func initialize() {
  }
}
