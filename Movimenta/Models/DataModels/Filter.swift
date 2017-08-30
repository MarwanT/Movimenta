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
  fileprivate(set) var flatCategories: [Event.Category]? = nil
  var withinTime: Int? = nil
  var speakers: [Participant]? = nil
  var sponsers: [Participant]? = nil
  var companies: [Participant]? = nil
  var artists: [Participant]? = nil
  var organizers: [Participant]? = nil
  var withinDistance: Double? = nil
  var showBookmarked: Bool? = nil
  
  /// Set and Get flattened categories
  var categories: [Event.Category]? {
    get {
      return flatCategories
    }
    set {
      flatCategories = newValue?.flatCategories
    }
  }
  
  mutating func add(category: Event.Category) {
    var categoriesArray: [Event.Category] = categories ?? []
    if !categoriesArray.contains(category) {
      categoriesArray.append(category)
    }
    categories = categoriesArray
  }
  
  mutating func remove(category: Event.Category) {
    if let index = categories?.index(of: category) {
      categories?.remove(at: index)
    }
  }
}

extension Filter {
  private func flattedCategories() -> [Event.Category]? {
    guard let flatCategories = flatCategories else {
      return nil
    }
    return flatCategories.flatCategories
  }
  
  func contains(category: Event.Category) -> Bool {
    guard let flatCategories = flatCategories else {
      return false
    }
    return flatCategories.contains(category)
  }
}
