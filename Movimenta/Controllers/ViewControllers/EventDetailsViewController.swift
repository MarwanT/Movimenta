//
//  EventDetailsViewController.swift
//  Movimenta
//
//  Created by Marwan  on 8/8/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
  @IBOutlet weak var detailsStackView: UIStackView!
  @IBOutlet weak var labelsContainerView: UIView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  @IBOutlet weak var participantsLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
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
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    labelsContainerView.layoutMargins = UIEdgeInsets(top: CGFloat(theme.space7), left: CGFloat(theme.space7), bottom: CGFloat(theme.space7), right: CGFloat(theme.space7))
    titleLabel.font = theme.font1
    titleLabel.textColor = theme.darkTextColor
    categoriesLabel.font = theme.font12
    categoriesLabel.textColor = theme.darkTextColor
    participantsLabel.font = theme.font13
    participantsLabel.textColor = theme.color2
    descriptionLabel.font = theme.font6
    descriptionLabel.textColor = theme.darkTextColor
  }
  
  private func loadData() {
    // TODO: Set image
    titleLabel.text = viewModel.title.capitalized
    categoriesLabel.text = viewModel.categoriesLabel.uppercased()
    participantsLabel.text = viewModel.participantsLabel
    descriptionLabel.text = viewModel.description
  }
}
