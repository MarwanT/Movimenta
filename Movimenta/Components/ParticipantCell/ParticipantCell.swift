//
//  ParticipantCell.swift
//  Movimenta
//
//  Created by Marwan  on 8/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import SDWebImage
import UIKit

class ParticipantCell: UITableViewCell {
  static let identifier: String = ParticipantCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
  @IBOutlet weak var participantImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var roleLabel: UILabel!
  
  @IBOutlet weak var nameLabelHorizontalSpacingToImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var roleLabelVerticalSpacingToNameLabel: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    applyTheme()
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    selectedBackgroundView = UIImageView(image: theme.color6.image())
    nameLabel.font = theme.font5
    nameLabel.textColor = theme.color2
    roleLabel.font = theme.font6
    roleLabel.textColor = theme.darkTextColor
    nameLabelHorizontalSpacingToImageViewConstraint.constant = CGFloat(theme.space2)
    roleLabelVerticalSpacingToNameLabel.constant = 0
    participantImageView.backgroundColor = theme.color6
    contentView.layoutMargins = UIEdgeInsets(
      top: CGFloat(theme.space2), left: CGFloat(theme.space7),
      bottom: CGFloat(theme.space2), right: CGFloat(theme.space7))
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    separatorInset = UIEdgeInsets(
      top: 0, left: nameLabel.frame.origin.x, bottom: 0, right: 0)
  }
  
  func set(imageURL: URL?, name: String?, role: String?) {
    participantImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "imagePlaceholderSmall"))
    nameLabel.text = name
    roleLabel.text = role
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    participantImageView.backgroundColor = ThemeManager.shared.current.color6
  }
}
