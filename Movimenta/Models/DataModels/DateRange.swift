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
  func startsWithin(minutes: Int) -> Bool {
    let now = Date()
    guard let withinDate = now.add(minutes: minutes) else {
      return false
    }
    
    guard let singleDateRange = dateRange(on: withinDate),
      let from = singleDateRange.from else {
        return false
    }
    
    return (from >= now && from <= withinDate)
  }
  
  func intercept(with date: Date) -> Bool {
    return intercept(with: DateRange(from: date.flatDate, to: date.flatDate))
  }
  
  func intercept(with other: DateRange) -> Bool {
    guard let from = from?.flatDate, let to = to?.flatDate, let otherFrom = other.from?.flatDate, let otherTo = other.to?.flatDate else {
      return false
    }
    return (from <= otherFrom && to >= otherFrom)
      || (from <= otherTo && to >= otherTo)
      || (from >= otherFrom && to <= otherTo)
  }
  
  func dateRange(on date: Date) -> DateRange? {
    guard intercept(with: date) else {
      return nil
    }
    
    guard let from = from, let to = to else {
      return nil
    }
    
    let fromDate = date.cloneDate(withTimeOf: from)
    let toDate = date.cloneDate(withTimeOf: to)
    return DateRange(from: fromDate, to: toDate)
  }
}

extension DateRange {
  var displayedShortDate: String? {
    var text: String? = nil
    guard let from = from else {
      return text
    }
    
    let format = "dd'.'MM"
    if let to = to {
      if from.same(date: to) {
        text = from.formattedDate(format: format)
      } else {
        text = "\(from.formattedDate(format: format)) - \(to.formattedDate(format: format))"
      }
    } else {
      text = from.formattedDate(format: format)
    }
    
    return text?.capitalized
  }
  
  var displayedShortTime: String? {
    var text: String? = nil
    guard let from = from else {
      return text
    }
    
    if let to = to {
      if from.same(time: to) {
        text = "\(from.formattedTime())"
      } else {
        text = "\(from.formattedTime()) - \(to.formattedTime())"
      }
    } else {
      text = from.formattedTime()
    }
    
    return text?.capitalizeFirst
  }
  
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
        text = "\(Strings.from()) \(from.formattedTime()) \(Strings.to_time()) \(to.formattedTime())"
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

//MARK: - DateRange Array extensions
extension Array where Element == DateRange {
  func sortedAscending() -> [DateRange] {
    let sortedRanges = sorted { (range1, range2) -> Bool in
      guard let fromDate1 = range1.from, let fromDate2 = range2.from else {
        return false
      }
      
      switch fromDate1.compare(fromDate2) {
      case .orderedAscending, .orderedSame:
        return true
      case .orderedDescending:
        return false
      }
    }
    return sortedRanges
  }
  
  func sortedDescending() -> [DateRange] {
    let sortedRanges = sorted { (range1, range2) -> Bool in
      guard let toDate1 = range1.to, let toDate2 = range2.to else {
        return false
      }
      
      switch toDate1.compare(toDate2) {
      case .orderedDescending, .orderedSame:
        return true
      case .orderedAscending:
        return false
      }
    }
    return sortedRanges
  }
}
