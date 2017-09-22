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
  
  @IBOutlet weak var segmentedControlTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var nameLabelTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var addressLabelTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var sliderViewLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var mapImageViewTrailingConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initialize()
    applyTheme()
  }
  
  private func initialize() {
    segmentedControl.clipsToBounds = true
    segmentedControl.setTitle(Section.gallery.name, forSegmentAt: Section.gallery.rawValue)
    segmentedControl.setTitle(Section.map.name, forSegmentAt: Section.map.rawValue)
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
  
  func loadView(with data: DetailsData?) {
    // TODO: Set the Gallery Images
    mapImageView.sd_setImage(with: data?.mapImageURL)
    nameLabel.text = data?.name
    addressLabel.text = data?.address
    labelsContainerView.manipulateLabelsSubviewsTopMarginsIfNeeded()
    layoutIfNeeded()
}

//MARK: Segmented Control Related
extension VenueDetailsHeaderView {
  enum Section: Int {
    case gallery = 0
    case map
    
    var name: String {
      switch self {
      case .gallery:
        return Strings.view_gallery()
      case .map:
        return Strings.view_map()
      }
    }
  }
}

//MARK: Instence
extension VenueDetailsHeaderView {
  class func instanceFromNib() -> VenueDetailsHeaderView {
    return UINib(nibName: VenueDetailsHeaderView.defaultNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! VenueDetailsHeaderView
  }
}
