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
  
  // MARK: Register
  func register(for events: [Event]) {
    DispatchQueue.global().async {
      events.forEach { (event) in
        self.register(for: event)
      }
    }
  }
  
  func register(for event: Event) {
    DispatchQueue.global().async {
      guard let dateRanges = event.dates else {
        return
      }
      
      let dates = dateRanges.upcomingStartingDates(addMinutes: -(BookmarkNotificationManager.notifyBeforeMinutes))
      self.register(with: EventNotificationData(from: event), on: dates)
    }
  }
  
  fileprivate func register(with data: EventNotificationData, on dates: [Date]) {
    for (index, date) in dates.enumerated() {
      register(with: data, on: date, for: "\(data.id).\(index)")
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
  
  // MARK: Unregister
  func unRegister(event: Event) {
    DispatchQueue.global().async {
      guard let id = event.id else {
        return
      }
      self.unRegister(for: [id])
    }
  }
  
  private func unRegister(for ids: [String]) {
    if #available(iOS 10.0, *) {
      let center = UNUserNotificationCenter.current()
      ids.forEach { (eventId) in
        center.getPendingNotificationRequests { (requests) in
          let notifications = requests.filter({ (notification) -> Bool in
            notification.identifier.isSubdomain(of: eventId)
          })
          let notificationsIds = notifications.map({ $0.identifier })
          center.removePendingNotificationRequests(withIdentifiers: notificationsIds)
        }
      }
      center.removeAllDeliveredNotifications()
    } else {
      guard let scheduledLocalNotifications = UIApplication.shared.scheduledLocalNotifications else {
        return
      }
      ids.forEach { (eventId) in
        let notifications = scheduledLocalNotifications.filter({ (notification) -> Bool in
          guard let id = notification.userInfo?["id"] as? String else {
            return false
          }
          return id.isSubdomain(of: eventId)
        })
        notifications.forEach({ (notification) in
          UIApplication.shared.cancelLocalNotification(notification)
        })
      }
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

//MARK: - Date Range Array
extension Array where Element == DateRange {
  func upcomingStartingDates(addMinutes: Int = 0) -> [Date] {
    var dates = [Date]()
    forEach { (dateRange) in
      guard let dateRangeDates = dateRange.upcomingStartingDates(addMinutes: addMinutes) else {
        return
      }
      dates.append(contentsOf: dateRangeDates)
    }
    return dates
  }
}

//MARK: - String
extension String {
  func isSubdomain(of id: String) -> Bool {
    let pattern = "\(id)\\.\\w+"
    do {
      let regex = try NSRegularExpression(pattern: pattern, options: [])
      let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: (self as NSString).length))
      return matches.count > 0
    } catch {
      return false
    }
  }
}
