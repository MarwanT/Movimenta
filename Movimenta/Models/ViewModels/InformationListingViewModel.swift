//
//  InformationListingViewModel.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

class InformationListingViewModel {
  enum Mode {
    case restaurants
    case hotels
  }

  func initialize(with mode: Mode) {
    self.mode = mode
  }

  var mode: Mode!
}
