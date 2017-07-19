//
//  GeneralSettings.swift
//  Movimenta
//
//  Created by Marwan  on 7/19/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

public class GeneralSettings {
  public struct Keys {
    public static let SendUsageData = "SendUsageData"
  }
  
  private let defaults = UserDefaults.standard
  
  public static let sharedInstance: GeneralSettings = GeneralSettings()
  
  private init() {
    let defaultValues: [String : Any] = [
      Keys.SendUsageData : true
    ]
    defaults.register(defaults: defaultValues)
    
    shouldSendUsageData = defaults.bool(forKey: Keys.SendUsageData)
  }
  
  public var shouldSendUsageData: Bool {
    didSet {
      defaults.set(self.shouldSendUsageData, forKey: Keys.SendUsageData)
    }
  }
}
