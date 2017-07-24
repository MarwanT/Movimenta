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
