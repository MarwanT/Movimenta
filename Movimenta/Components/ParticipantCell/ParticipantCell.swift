//
//  ParticipantCell.swift
//  Movimenta
//
//  Created by Marwan  on 8/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

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
    roleLabelVerticalSpacingToNameLabel.constant = CGFloat(theme.space8)
    participantImageView.backgroundColor = theme.color6
    contentView.layoutMargins = UIEdgeInsets(
      top: CGFloat(theme.space2), left: CGFloat(theme.space7),
      bottom: CGFloat(theme.space2), right: CGFloat(theme.space7))
    layoutIfNeeded()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
