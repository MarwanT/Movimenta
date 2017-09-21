//
//  VenueViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 9/21/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

final class VenueViewModel {
  fileprivate(set) var venue: Venue!
  
  func initialize(with venue: Venue) {
    self.venue = venue
  }
}
