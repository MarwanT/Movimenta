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
  
  fileprivate func register(with data: EventNotificationData, on date: Date, for notificationId: String) {
    if #available(iOS 10.0, *) {
      let center = UNUserNotificationCenter.current()
      let content = UNMutableNotificationContent()
      content.title = Strings.movimenta()
      content.body = data.title
      content.sound = UNNotificationSound.default()
      
      let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: date)
      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
      
      let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
      center.add(request)
    } else {
      let localNotification = UILocalNotification()
      localNotification.fireDate = date
      localNotification.timeZone = NSTimeZone.default
      localNotification.alertBody = data.title
      localNotification.userInfo = ["id" : notificationId]
      UIApplication.shared.scheduleLocalNotification(localNotification)
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
