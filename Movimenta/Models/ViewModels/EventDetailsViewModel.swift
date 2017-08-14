//
//  EventDetailsViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 8/8/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

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
    return 0
  }
  
  func headerViewTitle(for section: Section) -> String? {
    switch section {
    case .dates:
      return "Date & Time"
    case .venue:
      return "Venue"
    case .participants:
      return "Participants"
    }
  }
}
