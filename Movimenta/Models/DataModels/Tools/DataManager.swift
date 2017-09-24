//
//  DataManager.swift
//  Movimenta
//
//  Created by Marwan  on 7/21/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import CoreLocation
import Foundation

class DataManager {
  var movimentaEvent: MovimentaEvent? = nil {
    didSet {
      // Send notification that data has been updated
      NotificationCenter.default.post(name: AppNotification.didLoadData, object: nil)
    }
  }
  var events: [Event] {
    return movimentaEvent?.events?.map({ (key, value) -> Event in
      return value
    }).sortedAscending() ?? []
  }
  var categories: [String : Event.Category] {
    return movimentaEvent?.categories ?? [:]
  }
  var organizers: [String : Participant] {
    return movimentaEvent?.organizers ?? [:]
  }
  var artists: [String : Participant] {
    return movimentaEvent?.artists ?? [:]
  }
  var companies: [String : Participant] {
    return movimentaEvent?.companies ?? [:]
  }
  var speakers: [String : Participant] {
    return movimentaEvent?.speakers ?? [:]
  }
  var sponsers: [String : Participant] {
    return movimentaEvent?.sponsors ?? [:]
  }
  var restaurants: [Restaurant] {
    return movimentaEvent?.restaurants ?? []
  }
  var hotels: [Hotel] {
    return movimentaEvent?.hotels ?? []
  }
  fileprivate(set) var bookmarkedEvents = [Event]()
  
  var userLocation: CLLocation? {
    return EventsMapViewController.currentLocation
  }
  
  static let shared = DataManager()
  private init() {}
  
  func reloadData() {
    loadLocalData()
    loadDataFromServer()
  }
  
  private func loadLocalData() {
    guard let eventsData = Persistence.shared.read(),
      let movimentaEvents = Parser.parseMovimentaEvents(from: eventsData),
      let mainEvent = movimentaEvents.first else {
        return
    }
    movimentaEvent = mainEvent
    refreshAppDataForLoadedData()
  }
  
  private func loadDataFromServer() {
    _ = MovimentaEventAPI.fetchMovimentaEventsDetails { (success, data, events, error) in
      guard success, let data = data, let mainEvent = events?.first else {
        return
      }
      
      Persistence.shared.save(data: data)
      self.movimentaEvent = mainEvent
      self.refreshAppDataForLoadedData()
    }
  }
  
  
  private func refreshAppDataForLoadedData() {
    loadBookmarkedEvents()
    refreshFiltersManager()
  }
  
  private func loadBookmarkedEvents() {
    bookmarkedEvents = bookmarkedEventsArray()
  }
  
  private func refreshFiltersManager() {
    FiltersManager.shared.intialize(with: events)
  }
  
  func venue(id: String?) -> Venue? {
    guard let id = id else {
      return nil
    }
    return movimentaEvent?.venues?[id]
  }
}

//MARK: - APIs
extension DataManager {
  func events(with participant: Participant) -> [Event] {
    var filter = Filter()
    filter.add(participant: participant)
    return FiltersManager.shared.filteredEvents(for: filter)
  }
}

//MARK: - Bookmark related
extension DataManager {
  fileprivate func bookmarkedEventsArray() -> [Event] {
    var events = [Event]()
    
    guard let movimentaEvents = movimentaEvent?.events else {
      return events
    }
    
    let eventsIds = Persistence.shared.bookmarkedEventsIds()
    eventsIds.forEach({
      if let event = movimentaEvents[$0] {
        events.append(event)
      }
    })
    return events
  }
  
  func bookmark(event: Event) -> Bool{
    guard let eventId = event.id else {
      return false
    }
    Persistence.shared.bookmark(eventWith: eventId)
    bookmarkedEvents.append(event)
    NotificationCenter.default.post(name: AppNotification.didUpadteBookmarkedEvents, object: [event])
    return true
  }
  
  private func unBookmarkSilently(event: Event) -> Bool {
    guard let eventId = event.id, let index = bookmarkedEvents.index(where: { $0.id == eventId }) else {
      return false
    }
    bookmarkedEvents.remove(at: index)
    Persistence.shared.unBookmark(eventWith: eventId)
    return true
  }
  
  func unBookmark(event: Event) -> Bool {
    let success = unBookmarkSilently(event: event)
    if success {
      NotificationCenter.default.post(name: AppNotification.didUpadteBookmarkedEvents, object: [event])
    }
    return success
  }
  
  func unBookmark(events: [Event]) {
    for event in events {
      _ = unBookmarkSilently(event: event)
    }
    NotificationCenter.default.post(name: AppNotification.didUpadteBookmarkedEvents, object: events)
  }
  
  func toggleBookmarkStatus(event: Event) {
    if event.isBookmarked {
      _ = unBookmark(event: event)
    } else {
      _ = bookmark(event: event)
    }
  }
  
  func bookmarked(eventId: String) -> Bool {
    return bookmarkedEvents.contains(where: { $0.id == eventId })
  }
}
