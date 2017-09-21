//
//  VenueViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 9/21/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

final class VenueViewModel {
  fileprivate(set) var venue: Venue!
  fileprivate(set) var events: [Event]!
  
  func initialize(with venue: Venue) {
    self.venue = venue
    self.events = DataManager.shared.events(in: venue)
  }
}

extension VenueViewModel {
  var numberOfRows: Int {
    return events.count
  }
  
  func values(for indexPath: IndexPath) -> (imageURL: URL?, date: String?, venueName: String?, eventName: String?, categories: String?, time: String?, isBookmarked: Bool?)? {
    let event = events[indexPath.row]
    let preferredDateRange = event.preferredDateRange()
    return (imageURL: event.image,
            date: preferredDateRange?.displayedShortDate,
            venueName: event.venue?.name?.uppercased(),
            eventName: event.title?.capitalized,
            categories: event.displayedCategoryLabel,
            time: preferredDateRange?.displayedShortTime,
            isBookmarked: event.isBookmarked)
  }
}
