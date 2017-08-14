//
//  EventDetailsHeaderView.swift
//  Movimenta
//
//  Created by Marwan  on 8/14/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class EventDetailsHeaderView: UIView {
  @IBOutlet weak var detailsStackView: UIStackView!
  @IBOutlet weak var labelsContainerView: UIView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  @IBOutlet weak var participantsLabel: UILabel!
  @IBOutlet weak var descriptionLabel: ExpandableLabel!
  
  fileprivate var isSetup: Bool = false
  
  class func instanceFromNib() -> EventDetailsHeaderView {
    return UINib(nibName: EventDetailsHeaderView.defaultNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventDetailsHeaderView
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    applyTheme()
    setup()
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    labelsContainerView.layoutMargins = UIEdgeInsets(top: CGFloat(theme.space7), left: CGFloat(theme.space7), bottom: CGFloat(theme.space7), right: CGFloat(theme.space7))
    titleLabel.font = theme.font1
    titleLabel.textColor = theme.darkTextColor
    categoriesLabel.font = theme.font12
    categoriesLabel.textColor = theme.darkTextColor
    participantsLabel.font = theme.font12
    participantsLabel.textColor = theme.color2
    descriptionLabel.font = theme.font6
    descriptionLabel.textColor = theme.darkTextColor
    descriptionLabel.configuration.setMinimumNumberOfLines(4)
    imageView.backgroundColor = theme.color6
  }
  
  private func setup() {
    isSetup = true
  }
}
