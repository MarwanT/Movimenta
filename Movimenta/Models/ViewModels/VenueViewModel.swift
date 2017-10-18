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
    self.images = venue.gallery?.map{ _ -> UIImage? in
      return nil
    } ?? []
    self.events = DataManager.shared.events(in: venue)
  }
  
  func event(for indexPath: IndexPath) -> Event {
    return events[indexPath.row]
  }
  
  func sharingContent() -> [Any]? {
    guard let url = venue.link else {
      return nil
    }
    let title = [name, "MOVIMENTA"].flatMap({ $0 }).joined(separator: " | ")
    return [title, url]
  }
  
  func galleryImage(at index: Int, completion: @escaping (UIImage?) -> Void) {
    guard let images = images else {
      completion(#imageLiteral(resourceName: "imagePlaceholderLarge"))
      return
    }
    
    if let image = images[index] {
      completion(image)
    } else {
      guard let imageURL = self.venueImages?[index] else {
        completion(#imageLiteral(resourceName: "imagePlaceholderLarge"))
        return
      }
      _ = apiRequest(target: .absolute(imageURL), completion: {
        (data, statusCode, response, error) in
        guard let data = data, let image = UIImage(data: data) else {
          completion(#imageLiteral(resourceName: "imagePlaceholderLarge"))
          return
        }
        self.setGallery(image: image, at: index)
        completion(image)
      })
      return
    }
  }
  
  func setGallery(image: UIImage, at index: Int) {
    images.replaceSubrange(index...index, with: [image])
  }
}

//MARK: Venue Details Data
extension VenueViewModel {
  var venueImages: [URL]? {
    return venue.gallery
  }
  
  var numberOfVenueImages: Int {
    return venueImages?.count ?? 0
  }
  
  var mapImageURL: URL? {
    return coordinates?.mapImageURL
  }
  
  var name: String? {
    return venue.title
  }
  
  var address: String? {
    return venue.fullAddress
  }
  
  var directions: (origin: CLLocationCoordinate2D?, destination: CLLocationCoordinate2D)? {
    guard let destination = coordinates else {
      return nil
    }
    let origin = EventsMapViewController.currentLocation?.coordinate
    return (origin: origin, destination: destination)
  }
  
  var coordinates: CLLocationCoordinate2D? {
    if let position = venue?.coordinates, !position.isZero {
      return position
    } else if let position = events.first?.coordinates, !position.isZero {
      return position
    } else {
      return nil
    }
  }
}

extension VenueViewModel {
  var numberOfRows: Int {
    return events.count
  }
  
  func values(for indexPath: IndexPath) -> (imageURL: URL?, date: String?, venueName: String?, eventName: String?, categories: String?, time: String?, isBookmarked: Bool?)? {
    let event = events[indexPath.row]
    let preferredDateRange = event.preferredDateRange()
    return (imageURL: event.imageThumb,
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
