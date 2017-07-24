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
  
}
