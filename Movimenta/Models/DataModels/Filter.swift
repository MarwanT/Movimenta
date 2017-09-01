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
  
  mutating func add(participant: Participant) {
    switch participant.type {
    case .Artist:
      guard artists != nil else {
        artists = [participant]
        return
      }
      artists?.appendUnique(participant: participant)
    case .Company:
      guard companies != nil else {
        companies = [participant]
        return
      }
      companies?.appendUnique(participant: participant)
    case .Organizer:
      guard organizers != nil else {
        organizers = [participant]
        return
      }
      organizers?.appendUnique(participant: participant)
    case .Speaker:
      guard speakers != nil else {
        speakers = [participant]
        return
      }
      speakers?.appendUnique(participant: participant)
    case .Sponsor:
      guard sponsers != nil else {
        sponsers = [participant]
        return
      }
      sponsers?.appendUnique(participant: participant)
    case .Default:
      break
    }
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
