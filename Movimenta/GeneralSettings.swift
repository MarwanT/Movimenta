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
    // Add user defaults keys
  }
  
  private let defaults = UserDefaults.standard
  
  public static let sharedInstance: GeneralSettings = GeneralSettings()
  
  private init() {
    let defaultValues: [String : Any] = [:]
    defaults.register(defaults: defaultValues)
  }
}
