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
  
  func dateInfo(for dateRow: DateRow) -> (date: Date, minimumDate: Date, maximumDate: Date) {
    var date: Date
    var minimumDate: Date
    var maximumDate: Date
    switch dateRow {
    case .from:
      date = filter.dateRange?.from ?? FiltersManager.shared.firstEventDate
      minimumDate = FiltersManager.shared.firstEventDate
      maximumDate = FiltersManager.shared.lastEventDate
    case .to:
      date = filter.dateRange?.to ?? FiltersManager.shared.lastEventDate
      minimumDate = filter.dateRange?.from ?? FiltersManager.shared.firstEventDate
      maximumDate = FiltersManager.shared.lastEventDate
    }
    return (date, minimumDate, maximumDate)
  }
}

extension FiltersViewModel {
  func setFrom(date: Date?) {
    var dateRange = filter.dateRange ?? DateRange()
    dateRange.from = date
    if let date = date, let toDate = filter.dateRange?.to, toDate < date {
      dateRange.to = date
    }
    filter.dateRange = dateRange
  }
  
  func setTo(date: Date?) {
    var dateRange = filter.dateRange ?? DateRange()
    dateRange.to = date
    filter.dateRange = dateRange
  }
}
