//
//  EventDetailsViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 8/8/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

typealias CalendarEventInfo = (title: String, note: String?, url: URL?, location: String?, startDate: Date, endDate: Date)
typealias EventVenueInfo = (title: String?, location: String?)

final class EventDetailsViewModel {
  fileprivate(set) var event: Event!
  
  func initialize(with event: Event) {
    self.event = event
  }
  
  var image: URL? {
    return event.image
  }
  
  var title: String {
    return event.title ?? ""
  }
  
  var categoriesLabel: String {
    var text = ""
    event.categories.forEach { (category) in
      text += "\n" + category.displayStrings().joined(separator: "\n")
    }
    return text.trimed()
  }
  
  var participantsLabel: String {
    return event.displayedPrticipantsLabel
  }
  
  var description: String {
    return event.content ?? ""
  }
}

//MARK: Table View Methods
extension EventDetailsViewModel {
  typealias Section = EventDetailsViewController.Section

  var numberOfSections: Int {
    return Section.numberOfSections
  }
  
  func numberOfRows(in section: Section) -> Int {
    switch section {
    case .dates:
      return event.dates?.count ?? 0
    case .venue:
      return event.venue != nil ? 1 : 0
    case .participants:
      return 0
    }
  }
  
  func values(for indexPath: IndexPath) -> Any? {
    guard let section = Section(rawValue: indexPath.section) else {
      return nil
    }
    
    switch section {
    case .dates:
      return event.dates?[indexPath.row]
    case .venue:
      let title = event.venue?.title
      let location = event.venue?.address ?? event.venue?.mapAddress
      return (title, location)
    case .participants:
      return nil
    }
  }
  
  func calendarEventDetails(for indexPath: IndexPath) -> CalendarEventInfo? {
    guard let section = Section(rawValue: indexPath.section), section == .dates else {
      return nil
    }
    guard let title = event.title?.capitalized, let date = event.dates?[indexPath.row], let startDate = date.from, let endDate = (date.to ?? date.from) else {
      return nil
    }
    return (title, event.content, event.link, event.address, startDate, endDate)
  }
  
  func venue(for indexPath: IndexPath) -> Venue? {
    // Currently the data model only has one venue and not an array
    // So the index Path is not used here
    return event.venue
  }
  
  func headerViewTitle(for section: Section) -> String? {
    switch section {
    case .dates:
      return Strings.date_and_time()
    case .venue:
      return Strings.venue()
    case .participants:
      return Strings.participants()
    }
  }
}
