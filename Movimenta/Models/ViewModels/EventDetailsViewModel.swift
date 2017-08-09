//
//  EventDetailsViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 8/8/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

final class EventDetailsViewModel {
  fileprivate(set) var event: Event!
  
  func initialize(with event: Event) {
    self.event = event
  }
}
