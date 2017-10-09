//
//  Analytics.swift
//  Movimenta
//
//  Created by Marwan  on 7/19/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import FacebookCore
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
      sendFacebook(event: event)
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
    let filePath: String?
    if Environment.current.type == .staging {
      filePath = Bundle.main.path(forResource: "GoogleService-Info-dev", ofType: "plist")
    } else {
      filePath = Bundle.main.path(forResource: "GoogleService-Info-prod", ofType: "plist")
    }
    
    guard let path = filePath,
      let firebaseOptions = FirebaseOptions(contentsOfFile: path) else {
      return
    }
    
    FirebaseApp.configure(options: firebaseOptions)
  }
}

// MARK: - Facebook Analytics
extension Analytics {
  fileprivate func sendFacebook(event: Event) {
    let fACategory: String = event.category.name
    let fAAction: String = event.action.name
    let fALabel: String = event.name
    let fAInfo = event.info
    
    let eventName = fACategory + (fAAction.characters.count > 0 ? "-" + fAAction : "")
    
    var dictionary: AppEvent.ParametersDictionary = [:]
    if fALabel.characters.count > 0 {
      dictionary[AppEventParameterName.custom("Label")] = fALabel
    }
    
    if fAInfo.keys.count > 0 {
      for (key, value) in fAInfo {
        dictionary[AppEventParameterName.custom(key)] = value
      }
    }
    
    let fAEvent = AppEvent(name: eventName, parameters: dictionary, valueToSum: nil)
    AppEventsLogger.log(fAEvent)
  }
}
