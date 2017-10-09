//
//  VenueViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 9/21/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import CoreLocation
import Foundation

final class VenueViewModel {
  fileprivate(set) var venue: Venue!
  fileprivate(set) var events: [Event]!
  fileprivate(set) var images: [UIImage?]!
  
  var viewControllerTitle: String {
    return Strings.venue().capitalized
  }
  
  func initialize(with venue: Venue) {
    self.venue = venue
    self.events = DataManager.shared.events(in: venue)
  }
  
  func event(for indexPath: IndexPath) -> Event {
    return events[indexPath.row]
  }
  
  func sharingContent() -> [Any]? {
    guard let url = venue.link else {
      return nil
    }
    return [name ?? "", url]
  }
}

//MARK: Venue Details Data
extension VenueViewModel {
  var venueImages: [URL]? {
    return venue.gallery
  }
  
  var mapImageURL: URL? {
    return coordinates?.mapImageURL
  }
  
  var name: String? {
    return venue.title
  }
  
  var address: String? {
    return venue.address ?? venue.mapAddress
  }
  
  var directions: (origin: CLLocationCoordinate2D?, destination: CLLocationCoordinate2D)? {
    guard let destination = coordinates else {
      return nil
    }
    let origin = EventsMapViewController.currentLocation?.coordinate
    return (origin: origin, destination: destination)
  }
  
  var coordinates: CLLocationCoordinate2D? {
    //TODO: Return the venue coordinates
    return events.first?.coordinates
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
