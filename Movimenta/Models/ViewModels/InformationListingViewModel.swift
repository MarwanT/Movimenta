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

  fileprivate var data: [InformationModelCommonProperties] = []
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

//MARK: Table view helpers
extension InformationListingViewModel {
  func numberOfSections() -> Int {
    return 1
  }

  func numberOfRowForSection(section: Int) -> Int {
    return data.count
  }

  func itemAtIndexPath(indexPath: IndexPath) -> InformationModelCommonProperties? {
    let index = indexPath.item
    guard data.count > index else {
      return nil
    }
    let item = data[index]
    return item
  }
}
