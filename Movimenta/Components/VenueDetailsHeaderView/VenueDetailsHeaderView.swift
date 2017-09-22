//
//  VenueDetailsHeaderView.swift
//  Movimenta
//
//  Created by Marwan  on 9/21/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class VenueDetailsHeaderView: UIView {
  typealias DetailsData = (venueImages: [URL]?, mapImageURL: URL?, name: String?, address: String?)
  
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var segmentedContentView: UIView!
  @IBOutlet weak var sliderView: UIView!
  @IBOutlet weak var mapImageView: UIImageView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var labelsContainerView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    applyTheme()
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    contentView.layoutMargins = UIEdgeInsets(
      top: CGFloat(theme.space7), left: CGFloat(theme.space7),
      bottom: CGFloat(theme.space7), right: CGFloat(theme.space7))
    nameLabel.font = theme.font1
    nameLabel.textColor = theme.darkTextColor
    addressLabel.font = theme.font6
    addressLabel.textColor = theme.darkTextColor
    mapImageView.backgroundColor = theme.color6
    segmentedControl.tintColor = theme.color2
  }
}
