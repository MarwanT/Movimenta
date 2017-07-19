//
//  Analytics.swift
//  Movimenta
//
//  Created by Marwan  on 7/19/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

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
  
  func send(event: Event) {
    // Send events through different Analytics chanels
    
    // Handle Analytics chanels with no built in OptOut option.
    if self.enabled {
      // Send events through different Analytics chanels
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
}
