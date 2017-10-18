//
//  ParticipantDetailsHeaderView.swift
//  Movimenta
//
//  Created by Marwan  on 9/11/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

protocol ParticipantDetailsHeaderViewDelegate: class {
  func participantDetailsHeaderDidChangeSize(_ headerView: ParticipantDetailsHeaderView, size: CGSize)
}

class ParticipantDetailsHeaderView: UIView {
  typealias DetailsData = (image: URL?, name: String?, roles: String?, description: String?)
  
  @IBOutlet weak var detailsStackView: UIStackView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var labelsContainerView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var rolesLabel: UILabel!
  @IBOutlet weak var descriptionLabel: ExpandableLabel!
  @IBOutlet weak var descriptionLoader: UIActivityIndicatorView!

  fileprivate var isInitialized: Bool = false
  
  fileprivate var storedData: DetailsData? = nil
  
  weak var delegate: ParticipantDetailsHeaderViewDelegate?
  
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
    descriptionLoader.color = theme.color2
  }
  
  private func initialize() {
    descriptionLabel.expandableLabelDelegate = self
    _ = loadView(with: storedData)
    isInitialized = true
  }
  
  func loadView(with data: DetailsData?) {
    if isInitialized {
      imageView.sd_setImage(with: data?.image, placeholderImage: #imageLiteral(resourceName: "imagePlaceholderLarge"))
      nameLabel.text = data?.name?.capitalized
      rolesLabel.text = data?.roles?.uppercased()
      loadDescriptionLabel(with: data?.description)
      labelsContainerView.manipulateLabelsSubviewsTopMarginsIfNeeded(exceptions: [descriptionLabel])
      storedData = nil
      layoutIfNeeded()
    } else {
      storedData = data
    }
  }
  
  private func loadDescriptionLabel(with text: String?) {
    descriptionLabel.text = nil
    
    descriptionLoader(activate: true)
    text?.htmlString(completion: { htmlString in
      self.descriptionLoader(activate: false)
      guard let htmlString = htmlString else {
        return
      }
      if self.descriptionLabel != nil {
        self.descriptionLabel.text = htmlString
        self.labelsContainerView.manipulateLabelsSubviewsTopMarginsIfNeeded()
        self.delegate?.participantDetailsHeaderDidChangeSize(self, size: self.preferredSize())
      }
    })
  }
}

//MARK: - Helpers
extension ParticipantDetailsHeaderView {
  fileprivate func descriptionLoader(activate: Bool) {
    if activate {
      descriptionLoader.startAnimating()
      descriptionLoader.isHidden = false
    } else {
      descriptionLoader.stopAnimating()
      descriptionLoader.isHidden = true
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
extension ParticipantDetailsHeaderView: ExpandableLabelDelegate {
  func expandableLabelDidChangeState(_ expandableLabel: ExpandableLabel, state: ExpandableLabel.State) {
    delegate?.participantDetailsHeaderDidChangeSize(self, size: preferredSize())
  }
}
