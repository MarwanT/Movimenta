//
//  AppNotification.swift
//  Movimenta
//
//  Created by Marwan  on 7/25/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

struct AppNotification {
  static let didLoadData: Notification.Name = Notification.Name(rawValue: "AppNotification.Name.didLoadData")
  static let didUpadteBookmarkedEvents: Notification.Name = Notification.Name(rawValue: "AppNotification.Name.didUpadteBookmarkedEvents")
  static let didSetEventIDFromNotification: Notification.Name = Notification.Name(rawValue: "AppNotification.Name.didSetEventIDFromNotification")
}
