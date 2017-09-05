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
  
  private func filteredOrganizers(_ organizers: [Participant]?) -> [Event] {
    guard let organizers = organizers, organizers.count > 0 else {
      return self
    }
    return filter({ $0.organizers.contains(where: { (participant) -> Bool in
      organizers.contains(where: { (organizer) -> Bool in
        participant == organizer
      })
    })
    })
  }
  
  private func filteredCompanies(_ companies: [Participant]?) -> [Event] {
    guard let companies = companies, companies.count > 0 else {
      return self
    }
    return filter({ $0.companies.contains(where: { (participant) -> Bool in
      companies.contains(where: { (company) -> Bool in
        participant == company
      })
    })
    })
  }
  
  private func filteredArtists(_ artists: [Participant]?) -> [Event] {
    guard let artists = artists, artists.count > 0 else {
      return self
    }
    return filter({ $0.artists.contains(where: { (participant) -> Bool in
      artists.contains(where: { (artist) -> Bool in
        participant == artist
      })
    })
    })
  }
  
  private func filteredStartWithin(minutes: Int?) -> [Event] {
    guard let minutes = minutes else {
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
    return self.filteredBookmarked(filter.showBookmarked)
      .filteredArtists(filter.artists)
      .filteredSpeakers(filter.speakers)
      .filteredSponsers(filter.sponsers)
      .filteredCompanies(filter.companies)
      .filteredOrganizers(filter.organizers)
      .filteredStartWithin(minutes: filter.withinTime)
      .filteredWithin(distance: filter.withinDistance)
  }
}
