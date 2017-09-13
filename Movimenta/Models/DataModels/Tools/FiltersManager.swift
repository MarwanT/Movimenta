//
//  FiltersManager.swift
//  Movimenta
//
//  Created by Marwan  on 8/21/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

class FiltersManager {
  var events: [Event]? = nil
  
  static let shared = FiltersManager()
  private init() {}
  
  func intialize(with events: [Event]) {
    self.events = events
  }
  
}

//MARK: Basic Values
extension FiltersManager {
  var firstEventDate: Date {
    return events?.first?.dates?.first?.from ?? Date()
  }
  
  var lastEventDate: Date {
    return events?.sortedDescending().first?.dates?.first?.to ?? Date()
  }
  
  var categories: [Event.Category] {
    var mainCategories: [Event.Category] = []
    events?.forEach({ (event) in
      event.categories.forEach({ (category) in
        if let index = mainCategories.index(of: category) {
          let subcat = Event.Category.subCategories(of: mainCategories[index], and: category)
          mainCategories[index].subCategories = subcat
        } else {
          mainCategories.append(category)
        }
      })
      
    })
    return mainCategories
  }
  
  var speakers: [Participant] {
    return Array(DataManager.shared.speakers.values)
  }
  
  var sponsers: [Participant] {
    return Array(DataManager.shared.sponsers.values)
  }
  
  var organizers: [Participant] {
    return Array(DataManager.shared.organizers.values)
  }
  
  var companies: [Participant] {
    return Array(DataManager.shared.companies.values)
  }
  
  var artists: [Participant] {
    return Array(DataManager.shared.artists.values)
  }
  
  var participants: [Participant] {
    return speakers + sponsers + organizers + companies + artists
  }
  
  var withinTimeValues: (values: [Int], unit: String) {
    return ([0, 10, 20, 30, 40, 50, 60], Strings.mins())
  }
  
  var withinDistanceValues: (values: [Double], unit: String) {
    return ([0, 1, 2, 3, 4, 5, 6], Strings.km())
  }
}

//MARK: Filter Methods
extension FiltersManager {
  func filteredEvents(for filter: Filter) -> [Event] {
    return events?.filtered(given: filter) ?? [Event]()
  }
}


//==============================================================================

//MARK: - Filtering
extension Array where Element == Event {
  private func filteredBy(dateRange: DateRange?) -> [Event] {
    guard let dateRange = dateRange else {
      return self
    }
    return filter({
      $0.happens(in: dateRange)
    })
  }
  
  private func filteredBookmarked(_ show: Bool?) -> [Event] {
    guard let show = show, show == false else {
      return self
    }
    return filter { $0.isBookmarked == false }
  }
  
  private func filteredParticipants(_ participants: [Participant]?) -> [Event] {
    guard let participants = participants, participants.count > 0 else {
      return self
    }
    
    return filter({
      let eventParticipants = $0.participants
      return eventParticipants.contains(where: { (eventParticipant) -> Bool in
        participants.contains(where: { (filterParticipant) -> Bool in
          eventParticipant == filterParticipant
        })
      })
    })
  }
  
  private func filtered(flatCategories: [Event.Category]?) -> [Event] {
    guard let flatCategories = flatCategories, flatCategories.count > 0 else {
      return self
    }
    return filter({
      let eventFlatCategories = $0.categories.flatCategories
      return eventFlatCategories.contains(where: { (eventCategory) -> Bool in
        return flatCategories.contains(eventCategory)
      })
    })
  }
  
  private func filteredStartWithin(minutes: Int?) -> [Event] {
    guard let minutes = minutes, minutes != 0 else {
      return self
    }
    return filter({ $0.startsWithin(minutes: minutes) })
  }
  
  /// Distance is in kilometers
  private func filteredWithin(distance: Double?) -> [Event] {
    guard let distance = distance,
      let userCoordinates = DataManager.shared.userLocation?.coordinate else {
      return self
    }
    return filter({ (event) -> Bool in
      event.within(kilometers: distance, to: userCoordinates)
    })
  }
  
  fileprivate func filtered(given filter: Filter) -> [Event] {
    return self.filteredBy(dateRange: filter.dateRange)
      .filteredBookmarked(filter.showBookmarked)
      .filteredParticipants(filter.participants)
      .filteredStartWithin(minutes: filter.withinTime)
      .filteredWithin(distance: filter.withinDistance)
      .filtered(flatCategories: filter.categories)
  }
}
