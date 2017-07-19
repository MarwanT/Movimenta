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
  
  deinit{
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc
  fileprivate func sendUsageDataValueChanged(_ notification: NSNotification) {
    // Call analytics engine to change tracking flag if available
  }
}
