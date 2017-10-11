//
//  ParticipantViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 9/11/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

final class ParticipantViewModel {
  fileprivate(set) var participant: Participant!
  fileprivate(set) var events: [Event]!
  
  func initialize(with participant: Participant) {
    self.participant = participant
    self.events = DataManager.shared.events(with: participant)
  }
  
  var viewControllerTitle: String? {
    return participant.type.singleName
  }
  
  var image: URL? {
    return participant.image
  }
  
  var name: String? {
    return participant.titleValue
  }
  
  var roles: String? {
    return participant.profession
  }
  
  var description: String? {
    return participant.content
  }
  
  var type: Participant.ParticipantType {
    return participant.type
  }
  
  func sharingContent() -> [Any]? {
    guard let url = participant.link else {
      return nil
    }
    return [participant.titleValue, url]
  }
  
  func event(for indexPath: IndexPath) -> Event {
    return events[indexPath.row]
  }
}

//MARK: Table View Methods
extension ParticipantViewModel {
  var numberOfRows: Int {
    return events.count
  }
  
  func values(for indexPath: IndexPath) -> (imageURL: URL?, date: String?, venueName: String?, eventName: String?, categories: String?, time: String?, isBookmarked: Bool?)? {
    let event = events[indexPath.row]
    let preferredDateRange = event.preferredDateRange()
    return (imageURL: event.image,
            date: preferredDateRange?.displayedShortDate,
            venueName: event.venue?.title?.uppercased(),
            eventName: event.title?.capitalized,
            categories: event.displayedCategoryLabel,
            time: preferredDateRange?.displayedShortTime,
            isBookmarked: event.isBookmarked)
  }
  
  func toggleEventBookmarkStatus(at indexPath: IndexPath) {
    let event = events[indexPath.row]
    DataManager.shared.toggleBookmarkStatus(event: event)
  }
  
  func updateBookmarkStatus(of event: Event) -> IndexPath? {
    guard let index = events.index(of: event) else {
      return nil
    }
    return IndexPath(row: index, section: 0)
  }
  
  func updateBookmarkStatus(of events: [Event]) -> [IndexPath] {
    var indexPaths = [IndexPath]()
    events.forEach { (event) in
      if let indexPath =  updateBookmarkStatus(of: event) {
        indexPaths.append(indexPath)
      }
    }
    return indexPaths
  }
}
