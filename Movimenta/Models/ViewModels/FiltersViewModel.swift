//
//  FiltersViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 8/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

final class FiltersViewModel {
  fileprivate var filter: Filter! = nil
  
  func initialize(with filter: Filter) {
    self.filter = filter
  }
}

extension FiltersViewModel {
  typealias Section = FiltersViewController.Section
  typealias DateRow = FiltersViewController.DateRow
  
  var numberOfSections: Int {
    return Section.numberOfSections
  }
  
  func numberOfRows(in section: Section) -> Int {
    switch section {
    case .dates:
      return DateRow.numberOfRows
    default:
      return 0
    }
  }
  
  func titleForHeader(in section: Section) -> String? {
    return section.title
  }
}
