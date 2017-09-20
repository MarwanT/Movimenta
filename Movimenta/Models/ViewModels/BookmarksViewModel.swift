//
//  BookmarksViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 9/18/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

final class BookmarksViewModel {
  fileprivate(set) var events = [Event]()
  fileprivate(set) var indexPathOfSelectedEvents = [IndexPath]()
  
  var viewControllerTitle: String {
    return Strings.bookmarks()
  }
  
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
  
  func loadEvents() {
    refreshEvents()
  }
  
  private func refreshEvents() {
    events.removeAll()
    events.append(contentsOf: DataManager.shared.bookmarkedEvents)
  }
  
  func event(for indexPath: IndexPath) -> Event {
    return events[indexPath.row]
  }
}

// Edit Mode Methods
extension BookmarksViewModel {
  var areAllEventsSelected: Bool {
    return indexPathOfSelectedEvents.count == events.count
  }
  
  var selectedEvents: [Event] {
    return indexPathOfSelectedEvents.map({ events[$0.row] })
  }
  
  func isSelected(indexPath: IndexPath) -> Bool {
    return indexPathOfSelectedEvents.contains(indexPath)
  }
  
  func selectEvent(at indexPath: IndexPath) {
    indexPathOfSelectedEvents.append(indexPath)
  }
  
  func unselectEvent(at indexPath: IndexPath) {
    guard let index = indexPathOfSelectedEvents.index(of: indexPath) else {
      return
    }
    indexPathOfSelectedEvents.remove(at: index)
  }
  
  func selectAll() {
    var indexes = [IndexPath]()
    for index in 0..<events.count {
      indexes.append(IndexPath(row: index, section: 0))
    }
    indexPathOfSelectedEvents = indexes
  }
  
  func unSelectAll() {
    indexPathOfSelectedEvents.removeAll()
  }
  
  func unBookmarkSelectedEvents() -> [IndexPath] {
    DataManager.shared.unBookmark(events: selectedEvents)
    loadEvents()
    let indexPaths = indexPathOfSelectedEvents
    indexPathOfSelectedEvents.removeAll()
    return indexPaths
  }
}
