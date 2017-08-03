//
//  DataManager.swift
//  Movimenta
//
//  Created by Marwan  on 7/21/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

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
    }) ?? []
  }
  fileprivate(set) var bookmarkedEvents = [Event]()
  
  static let shared = DataManager()
  private init() {
    bookmarkedEvents = bookmarkedEventsArray()
  }
  
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
  }
  
  private func loadDataFromServer() {
    _ = MovimentaEventAPI.fetchMovimentaEventsDetails { (success, data, events, error) in
      guard success, let data = data, let mainEvent = events?.first else {
        return
      }
      
      Persistence.shared.save(data: data)
      self.movimentaEvent = mainEvent
    }
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
    return true
  }
  
  func unBookmark(event: Event) -> Bool {
    guard let eventId = event.id, let index = bookmarkedEvents.index(where: { $0.id == eventId }) else {
      return false
    }
    bookmarkedEvents.remove(at: index)
    Persistence.shared.unBookmark(eventWith: eventId)
    return true
  }
  
  func bookmarked(eventId: String) -> Bool {
    return bookmarkedEvents.contains(where: { $0.id == eventId })
  }
}
