//
//  Date+Utils.swift
//  Movimenta
//
//  Created by Marwan  on 7/24/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension Date {
  var flatDate: Date? {
    let calendar = Calendar.current
    let comps: Set<Calendar.Component> = [.day, .month, .year]
    let dateComponents = calendar.dateComponents(comps, from: self)
    return calendar.date(from: dateComponents)
  }
  
  static func formatter(_ format: String = "yyyy-MM-dd HH:mm:ss") -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.locale = Locale.application
    
    return formatter
  }
  
  static func from(_ string: String, formatter: DateFormatter? = nil) -> Date? {
    let dateFormatter = formatter != nil ? formatter! : Date.formatter()
    
    guard let date = dateFormatter.date(from: string) else {
      return nil
    }
    return date
  }
  
  func formattedDate(format: String = "MMM' 'dd' 'yyyy") -> String {
    let dateFormatter = Date.formatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
  
  func formattedTime(format: String = "h:mm' 'a") -> String {
    let dateFormatter = Date.formatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
  
  func same(date: Date) -> Bool {
    guard let date1 = self.flatDate, let date2 = date.flatDate else {
      return false
    }
    
    let result = date1.compare(date2)
    switch result {
    case .orderedSame:
      return true
    case .orderedAscending, .orderedDescending:
      return false
    }
  }
  
  func same(time: Date) -> Bool {
    let calendar = Calendar.current
    let comps: Set<Calendar.Component> = [.hour, .minute]
    
    let date1Components = calendar.dateComponents(comps, from: self)
    let date2Components = calendar.dateComponents(comps, from: time)
    let _date1 = calendar.date(from: date1Components)
    let _date2 = calendar.date(from: date2Components)
    
    guard let date1 = _date1, let date2 = _date2 else {
      return false
    }
    
    let result = date1.compare(date2)
    switch result {
    case .orderedSame:
      return true
    case .orderedAscending, .orderedDescending:
      return false
    }
  }

  func add(minutes: Int) -> Date? {
    return Calendar.current.date(byAdding: .minute, value: minutes, to: self)
  }
  
  func cloneDate(withTimeOf otherDate: Date) -> Date? {
    let calendar = Calendar.current
    let timeCalendarComponents: Set<Calendar.Component> = [.hour, .minute]
    let timeComponents = calendar.dateComponents(timeCalendarComponents, from: otherDate)
    
    let dateCalendarComponents: Set<Calendar.Component> = [.day, .month, .year]
    var dateComponents: DateComponents = calendar.dateComponents(dateCalendarComponents, from: self)
    
    // Add the time values
    dateComponents.hour = timeComponents.hour
    dateComponents.minute = timeComponents.minute
    return calendar.date(from: dateComponents)
  }
}
