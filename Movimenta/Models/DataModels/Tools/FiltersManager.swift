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
  
  var withinTimeValues: (values: [Int], unit: String) {
    return ([0, 10, 20, 30, 40, 50, 60], Strings.mins())
  }
  
  var withinDistanceValues: (values: [Double], unit: String) {
    return ([0, 1, 2, 3, 4, 5, 6], Strings.km())
  }
}

//MARK: Filter Methods
extension FiltersManager {
}

//==============================================================================

//MARK: - Filtering
extension Array where Element == Event {
  private func filteredBookmarked(_ show: Bool?) -> [Event] {
    guard let show = show, show == false else {
      return self
    }
    return filter { $0.isBookmarked == false }
  }
  
  private func filteredSpeakers(_ speakers: [Participant]?) -> [Event] {
    guard let speakers = speakers, speakers.count > 0 else {
      return self
    }
    return filter({ $0.speakers.contains(where: { (participant) -> Bool in
        speakers.contains(where: { (speaker) -> Bool in
          participant == speaker
        }) })
    })
  }
  
  private func filteredSponsers(_ sponsers: [Participant]?) -> [Event] {
    guard let sponsers = sponsers, sponsers.count > 0 else {
      return self
    }
    return filter({ $0.sponsors.contains(where: { (participant) -> Bool in
      sponsers.contains(where: { (sponsor) -> Bool in
        participant == sponsor
      })
    })
    })
  }
}
