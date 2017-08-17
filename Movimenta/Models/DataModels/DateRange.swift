//
//  DateRange.swift
//  Movimenta
//
//  Created by Marwan  on 7/24/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DateRange {
  var from: Date?
  var to: Date?
}

extension DateRange {
  var displayedLabel: String {
    let text = [displayedDate, displayedTime].flatMap { $0 }.joined(separator: "\n")
    return text
  }
  
  private var displayedDate: String? {
    var text: String? = nil
    guard let from = from else {
      return text
    }
    
    var format = "EEEE' 'MMMM' 'd"
    
    if let to = to {
      if from.same(date: to) {
        text = from.formattedDate(format: format)
      } else {
        format = "EEEE' 'MMM' 'd"
        text = "\(from.formattedDate(format: format)) - \(to.formattedDate(format: format))"
      }
    } else {
      text = from.formattedDate(format: format)
    }
    
    return text?.capitalized
  }
  
  private var displayedTime: String? {
    var text: String? = nil
    guard let from = from else {
      return text
    }
    
    if let to = to {
      if from.same(time: to) {
        text = "\(Strings.at_time()) \(from.formattedTime())"
      } else {
        text = "\(Strings.from_time()) \(from.formattedTime()) \(Strings.to_time()) \(to.formattedTime())"
      }
    } else {
      text = from.formattedTime()
    }
    
    return text?.capitalizeFirst
  }
}

extension DateRange: Parsable {
  static func object(from json: JSON) -> DateRange? {
    let dateFromString = json["from"].stringValue
    let dateToString = json["to"].stringValue
    
    guard let fromDate = Date.from(dateFromString), let toDate = Date.from(dateToString) else {
      return nil
    }
    return DateRange(from: fromDate, to: toDate)
  }
}
