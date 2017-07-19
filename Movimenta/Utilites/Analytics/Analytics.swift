//
//  Analytics.swift
//  Movimenta
//
//  Created by Marwan  on 7/19/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Firebase
import Foundation

internal final class Analytics {
  var enabled: Bool {
    return GeneralSettings.sharedInstance.shouldSendUsageData
  }
  
  static let shared: Analytics = Analytics()
  
  private init() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.sendUsageDataValueChanged(_:)) ,
      name: GeneralSettings.Notifications.sendUsageDataValueChanged,
      object: nil)
  }
  
  /// Do general Analytics chanels initialization
  func initialize() {
    initializeGoogleAnalytics()
    initializeFirebase()
    // TODO: Set the application version field
  }
  
  deinit{
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc
  fileprivate func sendUsageDataValueChanged(_ notification: NSNotification) {
    // Call analytics engine to change tracking flag if available
    GAI.sharedInstance().optOut = !self.enabled
  }
  
  /// Send events through different Analytics chanels
  func send(event: Event) {
    sendGoogle(event: event)
    
    // Handle Analytics chanels with no built in OptOut option.
    if self.enabled {
    }
  }
  
  /// Send screen name through different Analytics chanels
  func send(screenName: ScreenName) {
    sendGoogle(screenName: screenName)
  }
  
  func set(field: Field, value: String) {
    // Set fields in different Analytics chanels
  }
}

// MARK: - Google Analytics
extension Analytics {
  private var trackingIdentifier: String {
    return Environment.current.googleAnalyticsIdentifier
  }
  
  private var dispatchInterval: TimeInterval {
    return 20
  }
  
  fileprivate func initializeGoogleAnalytics() {
    GAI.sharedInstance().tracker(withTrackingId: self.trackingIdentifier)
    GAI.sharedInstance().trackUncaughtExceptions = true
    GAI.sharedInstance().dispatchInterval = self.dispatchInterval
    GAI.sharedInstance().optOut = !self.enabled
    
    switch Environment.current.type {
    case .staging:
      GAI.sharedInstance().logger.logLevel = GAILogLevel.verbose
    default:
      GAI.sharedInstance().logger.logLevel = GAILogLevel.none
    }
  }
  
  fileprivate func sendGoogle(screenName: ScreenName) {
    guard GAI.sharedInstance().defaultTracker != nil else {
      return
    }
    
    GAI.sharedInstance().defaultTracker.set(kGAIScreenName, value: screenName.name)
    let gADictionary: NSMutableDictionary = GAIDictionaryBuilder.createScreenView().build()
    
    GAI.sharedInstance().defaultTracker.send(gADictionary as [NSObject : AnyObject])
  }
  
  fileprivate func sendGoogle(event: Event) {
    guard GAI.sharedInstance().defaultTracker != nil else {
      return
    }
    
    let gACategory: String = event.category.name
    let gAAction: String = event.action.name
    var gALabel: String = event.name
    let gAInfo = event.info
    let gADictionaryBuilder: GAIDictionaryBuilder = GAIDictionaryBuilder.createEvent(withCategory: gACategory, action: gAAction, label: gALabel, value: NSNumber(value: event.value))
    
    if gAInfo.keys.count > 0 {
      gALabel += " ''' filters: " + gAInfo.description
    }
    
    let gADictionary: NSMutableDictionary = gADictionaryBuilder.build()
    GAI.sharedInstance().defaultTracker.send(gADictionary as [NSObject : AnyObject])
  }
}

//MARK: - Firebase
extension Analytics {
  func initializeFirebase() {
    var firebaseOptions = FirebaseOptions(
      googleAppID: "1:399492442493:ios:e982452d9e6635e4",
      gcmSenderID: "399492442493")
    firebaseOptions.apiKey = "AIzaSyBd0M8t4arRunYbPYIYbdK3xoTLHibJbf8"
    firebaseOptions.bundleID = "com.keeward.Movimenta"
    firebaseOptions.clientID = "399492442493-flp0hkg86l184p2c4tth8glno4gi7h6o.apps.googleusercontent.com"
    firebaseOptions.databaseURL = "https://movimenta-1ca91.firebaseio.com"
    firebaseOptions.projectID = "movimenta-1ca91"
    firebaseOptions.storageBucket = "movimenta-1ca91.appspot.com"
    FirebaseApp.configure(options: firebaseOptions)
  }
}
