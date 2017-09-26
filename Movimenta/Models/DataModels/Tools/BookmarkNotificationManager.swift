//
//  BookmarkNotificationManager.swift
//  Movimenta
//
//  Created by Marwan  on 9/25/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import UserNotifications

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
  
  func initialize() {
    requestAuthorization()
  }
  
  private func requestAuthorization() {
    if #available(iOS 10.0, *) {
      let options: UNAuthorizationOptions = [.alert, .sound]
      let center = UNUserNotificationCenter.current()
      center.delegate = self
      center.requestAuthorization(options: options) { (granted, error) in
        print("Local Notifications AUthorization: \(granted)")
      }
    } else {
      let settings = UIUserNotificationSettings(types: [.sound, .alert], categories: nil)
      UIApplication.shared.registerUserNotificationSettings(settings)
    }
  }
}

//MARK: User Notification Center Delegate
@available(iOS 10.0, *)
extension BookmarkNotificationManager: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}
