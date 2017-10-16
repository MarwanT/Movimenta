//
//  EventDetailsViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 8/8/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

typealias CalendarEventInfo = (title: String, note: String?, url: URL?, location: String?, startDate: Date, endDate: Date, recurrenceFinishDate: Date?)
typealias EventVenueInfo = (title: String?, location: String?)
typealias EventParticipantInfo = (imageURL: URL?, name: String?, role: String?)

final class EventDetailsViewModel {
  fileprivate(set) var event: Event!
  
  func initialize(with event: Event) {
    self.event = event
  }
  
  var viewControllerTitle: String {
    return Strings.event_details()
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
  
  var isBookmarked: Bool {
    return event.isBookmarked
  }
  
  func sharingContent() -> [Any]? {
    guard let title = event.title, let url = event.link else {
      return nil
    }
    return [title, url]
  }
  
  func toggleBookmark() {
    if isBookmarked {
      unBookmarkEvent()
    } else {
      bookmarkEvent()
    }
  }
  
  func bookmarkEvent() {
    _ = DataManager.shared.bookmark(event: event)
  }
  
  func unBookmarkEvent() {
    _ = DataManager.shared.unBookmark(event: event)
  }
  
  func updateBookmarkStatusIfNeeded(of event: Event) -> Bool {
    if self.event == event {
      self.event = event
      return true
    }
    return false
  }
  
  func updateBookmarkStatusIfNeeded(of events: [Event]) -> Bool {
    for event in events {
      if updateBookmarkStatusIfNeeded(of: event) {
        return true
      }
    }
    return false
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
      return event.participants.count
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
      let location = event.venue?.fullAddress
      return (title, location)
    case .participants:
      let participnt = participant(for: indexPath)
      return (participnt.image, participnt.titleValue.capitalized, participnt.profession?.capitalized)
    }
  }
  
  func calendarEventDetails(for indexPath: IndexPath) -> CalendarEventInfo? {
    guard let section = Section(rawValue: indexPath.section), section == .dates else {
      return nil
    }
    guard let title = event.title?.capitalized,
      let date = event.dates?[indexPath.row],
      let startDate = date.from,
      let lastDate = date.to,
      let endDate = startDate.cloneDate(withTimeOf: lastDate) else {
      return nil
    }
    
    var recurrenceLastDate: Date? = nil
    if !startDate.same(date: lastDate) {
      recurrenceLastDate = lastDate
    }
    
    return (title, event.content, event.link, event.address, startDate, endDate, recurrenceLastDate)
  }
  
  func venue(for indexPath: IndexPath) -> Venue? {
    // Currently the data model only has one venue and not an array
    // So the index Path is not used here
    return event.venue
  }
  
  func participant(for indexPath: IndexPath) -> Participant {
    return event.participants[indexPath.row]
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
