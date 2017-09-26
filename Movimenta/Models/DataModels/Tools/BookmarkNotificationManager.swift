//
//  BookmarkNotificationManager.swift
//  Movimenta
//
//  Created by Marwan  on 9/25/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

struct EventNotificationData {
  var id: String
  var title: String
  var content: String
  
  init(from event: Event) {
    self.id = event.id ?? ""
    self.title = event.title ?? ""
    self.content = event.content ?? ""
  }
}

class BookmarkNotificationManager: NSObject {
  static var notifyBeforeMinutes: Int = 30
  
  static var shared = BookmarkNotificationManager()
  private override init () {}
}

