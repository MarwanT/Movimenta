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
  
  init() {
    let firstDate = FiltersManager.shared.firstEventDate
    let lastDate = FiltersManager.shared.lastEventDate
    let dates = firstDate.includedDates(till: lastDate)
    for date in dates {
      scheduleDates.append(ScheduleDate(date: date))
    }
  }
}

//MARK: - Schedule Date
extension ScheduleViewModel {
  struct ScheduleDate {
    var date: Date?
    
    private var isToday: Bool {
      return date?.same(date: Date()) ?? false
    }
    
    var string: String {
      return isToday ? Strings.today() : date?.formattedDate(format: "dd'.'MM") ?? ""
    }
  }
}
