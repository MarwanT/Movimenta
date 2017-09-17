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
    switch(mode) {
    case .hotels:
      data = DataManager.shared.hotels
    case .restaurants:
      data = DataManager.shared.restaurants
    }
  }

  var data: [InformationModelCommonProperties] = []
  var mode: InformationListingViewModel.Mode = .hotels

  func vcTitle() -> String {
    switch(mode) {
    case .hotels:
      return Strings.hotels()
    case .restaurants:
      return Strings.restaurants()
    }
  }
}
