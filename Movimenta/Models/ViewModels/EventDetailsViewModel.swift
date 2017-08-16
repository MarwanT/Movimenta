//
//  EventDetailsViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 8/8/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

typealias CalendarEventInfo = (title: String, note: String?, url: URL?, location: String?, startDate: Date, endDate: Date)

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
      return 0
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
      return nil
    case .participants:
      return nil
    }
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
