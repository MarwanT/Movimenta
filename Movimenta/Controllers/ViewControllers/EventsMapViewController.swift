//
//  EventsMapViewController.swift
//  Movimenta
//
//  Created by Marwan  on 8/2/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class EventsMapViewController: UIViewController {
  var viewModel = EventsMapViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = Strings.event_map()
  }
}

//MARK: Instance
extension EventsMapViewController {
  static func instance() -> EventsMapViewController {
    return Storyboard.Event.instantiate(EventsMapViewController.self)
  }
}
