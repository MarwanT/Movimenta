//
//  ScheduleViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 9/14/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

final class ScheduleViewModel {
  fileprivate(set) var scheduleDates = [ScheduleDate]()
  fileprivate(set) var indexOfSelectedDate: Int = 0
  
  init() {
    // Set Scheduale dates
    let firstDate = FiltersManager.shared.firstEventDate
    let lastDate = FiltersManager.shared.lastEventDate
    let dates = firstDate.includedDates(till: lastDate)
    for date in dates {
      scheduleDates.append(ScheduleDate(date: date))
    }
    // Set Selected Index
    if let index = scheduleDates.index(where: { $0.isToday }) {
      indexOfSelectedDate = index
    }
  }
}

//MARK: Collection View Methods
extension ScheduleViewModel {
  var numberOfItems: Int {
    return scheduleDates.count
  }
  
  func infoForCell(at indexPath: IndexPath) -> (label: String, isSelected: Bool) {
    let scheduleDate = scheduleDates[indexPath.item]
    return (scheduleDate.string, indexPath == selectedItemIndexPath)
  }
  
  fileprivate(set) var selectedItemIndexPath: IndexPath {
    get {
      return IndexPath(item: indexOfSelectedDate, section: 0)
    }
    set {
      indexOfSelectedDate = newValue.item
    }
  }
}

//MARK: - Schedule Date
extension ScheduleViewModel {
  struct ScheduleDate {
    var date: Date?
    
    fileprivate var isToday: Bool {
      return date?.same(date: Date()) ?? false
    }
    
    var string: String {
      return isToday ? Strings.today() : date?.formattedDate(format: "dd'.'MM") ?? ""
    }
  }
}
