//
//  Date+Utils.swift
//  Movimenta
//
//  Created by Marwan  on 7/24/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension Date {
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
    let calendar = Calendar.current
    let comps: Set<Calendar.Component> = [.day, .month, .year]
    
    let date1Components = calendar.dateComponents(comps, from: self)
    let date2Components = calendar.dateComponents(comps, from: date)
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

}
