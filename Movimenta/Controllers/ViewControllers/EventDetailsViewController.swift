//
//  EventDetailsViewController.swift
//  Movimenta
//
//  Created by Marwan  on 8/8/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
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
