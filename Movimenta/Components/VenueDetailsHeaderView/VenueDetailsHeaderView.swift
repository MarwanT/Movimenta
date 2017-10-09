//
//  VenueDetailsHeaderView.swift
//  Movimenta
//
//  Created by Marwan  on 9/21/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

protocol VenueDetailsHeaderViewDelegate: class {
  var venueDetailsHeaderParentViewController: UIViewController { get }
  func venueDetailsHeaderDidTapMapImage(_ view: VenueDetailsHeaderView)
}

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
  
  fileprivate var galleryViewController: GalleryViewController?
  
  fileprivate var animationDuration = ThemeManager.shared.current.animationDuration
  
  weak var delegate: VenueDetailsHeaderViewDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initialize()
    applyTheme()
  }
  
  private func initialize() {
    segmentedControl.clipsToBounds = true
    segmentedControl.setTitle(Section.gallery.name, forSegmentAt: Section.gallery.rawValue)
    segmentedControl.setTitle(Section.map.name, forSegmentAt: Section.map.rawValue)
    segmentedControl.addTarget(self, action: #selector(segmentedControlDidChangeValue(_:)), for: .valueChanged)
    
    let mapTap = UITapGestureRecognizer(target: self, action: #selector(didTapMapImageView(_:)))
    mapImageView.addGestureRecognizer(mapTap)
    mapImageView.isUserInteractionEnabled = true
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
    applyMargins()
  }
  
  func loadView(with data: DetailsData?) {
    loadGalleryImages(with: data?.venueImages)
    mapImageView.sd_setImage(with: data?.mapImageURL, placeholderImage: #imageLiteral(resourceName: "imagePlaceholderLarge"))
    nameLabel.text = data?.name
    addressLabel.text = data?.address
    labelsContainerView.manipulateLabelsSubviewsTopMarginsIfNeeded()
    contentView.layoutIfNeeded()
  }
  
  func loadGalleryImages(with urls: [URL]?) {
    if galleryViewController == nil {
      galleryViewController = GalleryViewController.instance()
      galleryViewController?.galleryDelegate = self
      _ = delegate?.venueDetailsHeaderParentViewController.add(
        asChildViewController: galleryViewController!, toView: sliderView)
      galleryViewController!.view.snp.makeConstraints({ (maker) in
        maker.edges.equalTo(sliderView)
      })
    }
    
    guard let galleryViewController = galleryViewController else {
      return
    }
    
    galleryViewController.initialize(with: urls ?? [], placeholderImage: #imageLiteral(resourceName: "imagePlaceholderLarge"))
  }
  
  private func applyMargins() {
    let theme = ThemeManager.shared.current
    segmentedControlTopConstraint.constant = CGFloat(theme.space3)
    nameLabelTopConstraint.constant = CGFloat(theme.space4)
    addressLabelTopConstraint.constant = CGFloat(theme.space2)
    contentView.layoutIfNeeded()
  }
  
  func preferredSize() -> CGSize {
    let size = contentView.systemLayoutSizeFitting(
      CGSize(width: self.bounds.width, height: 0),
      withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityFittingSizeLevel)
    return size
  }
}

//MARK: Actions
extension VenueDetailsHeaderView {
  func didTapMapImageView(_ sender: UIImageView) {
    delegate?.venueDetailsHeaderDidTapMapImage(self)
  }
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
  
  func segmentedControlDidChangeValue(_ sender: UISegmentedControl) {
    refreshSegmentedContentView()
  }
  
  private func refreshSegmentedContentView() {
    guard let section = Section(rawValue: segmentedControl.selectedSegmentIndex) else {
      return
    }
    switch section {
    case .gallery:
      displayGallery()
    case .map:
      displayMapImageView()
    }
  }
  
  private func displayGallery() {
    mapImageViewTrailingConstraint.isActive = false
    sliderViewLeadingConstraint.isActive = true
    UIView.animate(withDuration: animationDuration) { 
      self.segmentedContentView.layoutIfNeeded()
    }
    
    //MARK: [Analytics] Event
    let analyticsEvent = Analytics.Event(
      category: .venue, action: .viewVenueImageGallery, name: nameLabel.text ?? "")
    Analytics.shared.send(event: analyticsEvent)
  }
  
  private func displayMapImageView() {
    sliderViewLeadingConstraint.isActive = false
    mapImageViewTrailingConstraint.isActive = true
    UIView.animate(withDuration: animationDuration) {
      self.segmentedContentView.layoutIfNeeded()
    }
    
    //MARK: [Analytics] Event
    let analyticsEvent = Analytics.Event(
      category: .venue, action: .viewVenueMapLocation, name: nameLabel.text ?? "")
    Analytics.shared.send(event: analyticsEvent)
  }
}

//MARK: Gallery View Controller Delegate
extension VenueDetailsHeaderView: GalleryViewControllerDelegate {
  func gallery(_ controller: GalleryViewController, didTap image: UIImage?, with url: URL?, at index: Int?) {
  }
}

//MARK: Instence
extension VenueDetailsHeaderView {
  class func instanceFromNib() -> VenueDetailsHeaderView {
    return UINib(nibName: VenueDetailsHeaderView.defaultNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! VenueDetailsHeaderView
  }
}
