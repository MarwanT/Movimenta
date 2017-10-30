//
//  Persistence.swift
//  Movimenta
//
//  Created by Marwan  on 7/25/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

struct Persistence {
  struct Keys {
    static let bookmarkedEvents: String = "Persistence.Keys.bookmarkedEvents"
    static let notificationEventID: String = "Persistence.Keys.notificationEventID"
  }
  
  let documentsDirectory: URL
  let eventsArchive: URL
  
  static let shared = Persistence()
  private init() {
    documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    eventsArchive = documentsDirectory.appendingPathComponent("movimenta-biennal-events")
    
    // At first run, preloaded data will be saved in the archive directory
    if !FileManager.default.fileExists(atPath: eventsArchive.relativePath),
      let defaultData = readDefaultData() {
      save(data: defaultData)
    }
  }
  
  func read() -> Data? {
    return try? Data(contentsOf: eventsArchive)
  }
  
  func save(data: Data) {
    try? data.write(to: eventsArchive)
  }
  
  private func readDefaultData() -> Data? {
    let filename: String = "events"
    let bundle = Bundle.main
    let path = "\(bundle.resourcePath!)/\(filename).json"
    return (try? Data(contentsOf: URL(fileURLWithPath: path)))
  }
}

//MARK: - Bookmarked events
extension Persistence {
  func bookmarkedEventsIds() -> [String] {
    return UserDefaults.standard.array(forKey: Keys.bookmarkedEvents) as? [String] ?? []
  }
  
  func bookmark(eventWith id: String) {
    var eventsIds = bookmarkedEventsIds()
    if !eventsIds.contains(id) {
      eventsIds.append(id)
      UserDefaults.standard.set(eventsIds, forKey: Keys.bookmarkedEvents)
    }
  }
  
  func unBookmark(eventWith id: String) {
    var eventsIds = bookmarkedEventsIds()
    if let index = eventsIds.index(of: id) {
      eventsIds.remove(at: index)
      UserDefaults.standard.set(eventsIds, forKey: Keys.bookmarkedEvents)
    }
  }
}

//MARK: - Notification event
extension Persistence {
  func notificationEventID() -> String? {
    return UserDefaults.standard.string(forKey: Keys.notificationEventID)
  }
  
  func setNotificationEventID(_ id: String) {
    UserDefaults.standard.set(id, forKey: Keys.notificationEventID)
  }
  
  func removeNotificationEventID() {
    UserDefaults.standard.removeObject(forKey: Keys.notificationEventID)
  }
}
