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
  
  static var zero: Filter {
    return Filter()
  }
  
  var isZero: Bool {
    return dateRange == nil
    && (categories == nil || (categories?.count ?? 0) == 0)
    && (artists == nil || (artists?.count ?? 0) == 0)
    && (companies == nil || (companies?.count ?? 0) == 0)
    && (organizers == nil || (organizers?.count ?? 0) == 0)
    && (speakers == nil || (speakers?.count ?? 0) == 0)
    && (sponsers == nil || (sponsers?.count ?? 0) == 0)
    && withinTime == nil || withinTime == 0
    && withinDistance == nil || withinDistance == 0
    && showBookmarked == nil
  }
  
  /// Set and Get flattened categories
  var categories: [Event.Category]? {
    get {
      return flatCategories
    }
    set {
      flatCategories = newValue?.flatCategories
    }
  }
  
  var participants: [Participant] {
    let artists: [Participant] = self.artists ?? []
    let companies: [Participant] = self.companies ?? []
    let organizers: [Participant] = self.organizers ?? []
    let speakers: [Participant] = self.speakers ?? []
    let sponsers: [Participant] = self.sponsers ?? []
    return artists + companies + organizers + speakers + sponsers
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
  
  mutating func remove(participant: Participant) {
    switch participant.type {
    case .Artist:
      artists?.remove(participant: participant)
    case .Company:
      companies?.remove(participant: participant)
    case .Organizer:
      organizers?.remove(participant: participant)
    case .Speaker:
      speakers?.remove(participant: participant)
    case .Sponsor:
      sponsers?.remove(participant: participant)
    case .Default:
      break
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
