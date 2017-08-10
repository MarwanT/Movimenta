//
//  EventDetailsViewController.swift
//  Movimenta
//
//  Created by Marwan  on 8/8/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import SDWebImage
import UIKit

class EventDetailsViewController: UIViewController {
  @IBOutlet weak var detailsStackView: UIStackView!
  @IBOutlet weak var labelsContainerView: UIView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  @IBOutlet weak var participantsLabel: UILabel!
  @IBOutlet weak var descriptionLabel: ExpandableLabel!
  
  var viewModel = EventDetailsViewModel()
  
  static func instance() -> EventDetailsViewController {
    return Storyboard.Event.instantiate(EventDetailsViewController.self)
  }
  
  func initialize(with event: Event) {
    viewModel.initialize(with: event)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    applyTheme()
    loadData()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    manipulateLabelsTopMarginsIfNeeded()
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
  
  private func loadData() {
    imageView.sd_setImage(with: viewModel.image) { (image, error, cache, url) in
      self.manipulateImageViewVisibility(success: image != nil)
    }
    titleLabel.text = viewModel.title.capitalized
    categoriesLabel.text = viewModel.categoriesLabel.uppercased()
    participantsLabel.text = viewModel.participantsLabel
    descriptionLabel.text = viewModel.description
  }
}

//MARK: - Helpers
extension EventDetailsViewController {
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
}
