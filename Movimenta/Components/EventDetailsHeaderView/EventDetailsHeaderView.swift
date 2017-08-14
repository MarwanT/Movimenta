//
//  EventDetailsHeaderView.swift
//  Movimenta
//
//  Created by Marwan  on 8/14/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import SDWebImage
import UIKit

class EventDetailsHeaderView: UIView {
  typealias DetailsData = (image: URL?, title: String?, categories: String?, participants: String?, description: String?)
  
  @IBOutlet weak var detailsStackView: UIStackView!
  @IBOutlet weak var labelsContainerView: UIView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  @IBOutlet weak var participantsLabel: UILabel!
  @IBOutlet weak var descriptionLabel: ExpandableLabel!
  
  fileprivate var isSetup: Bool = false
  
  fileprivate var storedData: DetailsData? = nil
  
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
    descriptionLabel.expandableLabelDelegate = self
    _ = loadView(with: storedData)
    isSetup = true
  }
  
  func loadView(with data: DetailsData?) -> CGSize {
    if isSetup {
      imageView.sd_setImage(with: data?.image) { (image, error, cache, url) in
        self.manipulateImageViewVisibility(success: image != nil)
      }
      titleLabel.text = data?.title?.capitalized
      categoriesLabel.text = data?.categories?.uppercased()
      participantsLabel.text = data?.participants
      descriptionLabel.text = data?.description
      manipulateLabelsTopMarginsIfNeeded()
      storedData = nil
    } else {
      storedData = data
    }
    
    layoutIfNeeded()
    
    return preferredSize()
  }
}

//MARK: - Helpers
extension EventDetailsHeaderView {
  fileprivate func manipulateImageViewVisibility(success: Bool) {
    if success {
      if imageView.superview == nil {
        detailsStackView.insertArrangedSubview(imageView, at: 0)
      }
    } else {
      detailsStackView.removeArrangedSubview(imageView)
      imageView.removeFromSuperview()
    }
  }
  
  // If labels are empty remove the top margin
  fileprivate func manipulateLabelsTopMarginsIfNeeded() {
    var didUpdateLayout = false
    let labelsArray: [UILabel] = [titleLabel, categoriesLabel, participantsLabel, descriptionLabel]
    for label in labelsArray {
      if label.text == nil || (label.text?.isEmpty ?? true) {
        guard let topConstraint = labelsContainerView.constraints.topConstraints(item: label).first else {
          continue
        }
        topConstraint.constant = 0
        didUpdateLayout = true
      }
    }
    
    if didUpdateLayout {
      labelsContainerView.layoutIfNeeded()
    }
  }
  
  func preferredSize() -> CGSize {
    let size = detailsStackView.systemLayoutSizeFitting(
      CGSize(width: self.bounds.width, height: 0),
      withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityFittingSizeLevel)
    return size
  }
}

//MARK: - Expandable label delegate
extension EventDetailsHeaderView: ExpandableLabelDelegate {
  func expandableLabelDidChangeState(_ expandableLabel: ExpandableLabel, state: ExpandableLabel.State) {
  }
}
