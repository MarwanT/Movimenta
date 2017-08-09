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
  }
}
