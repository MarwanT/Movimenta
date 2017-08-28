//
//  Filter.swift
//  Movimenta
//
//  Created by Marwan  on 8/22/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

struct Filter {
  var dateRange: DateRange? = nil
  var categories: [Event.Category]? = nil
  var withinTime: Int? = nil
  var speakers: [Participant]? = nil
  var sponsers: [Participant]? = nil
  var companies: [Participant]? = nil
  var artists: [Participant]? = nil
  var organizers: [Participant]? = nil
  var withinDistance: Double? = nil
  var showBookmarked: Bool? = nil
}

extension Filter {
  var flatCategories: [Event.Category]? {
    guard let categories = categories else {
      return nil
    }
    var allCategories: [Event.Category] = []
    for category in categories {
      allCategories.append(category)
      if let subCategories = category.subCategories, subCategories.count > 0 {
        allCategories.append(contentsOf: subCategories)
      }
    }
    return allCategories
  }
  
  func contains(category: Event.Category) -> Bool {
    guard let flatCategories = flatCategories else {
      return false
    }
    return flatCategories.contains(category)
  }
}
