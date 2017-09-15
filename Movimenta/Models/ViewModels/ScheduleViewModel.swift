//
//  ScheduleViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 9/14/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

final class ScheduleViewModel {
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
