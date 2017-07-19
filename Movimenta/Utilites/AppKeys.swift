//
//  AppKeys.swift
//  Movimenta
//
//  Created by Marwan  on 7/19/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import Keys

internal struct AppKeys {
  let environmentString: String
  let googleAnalyticsIdentifier: String
  
  static let shared = AppKeys()
  
  private init(keys: MovimentaKeys) {
    self.environmentString = keys.movimentaEnvironment
    self.googleAnalyticsIdentifier = keys.movimentaGoogleAnalyticsIdentifier
  }
  
  private init() {
    self.init(keys: MovimentaKeys())
  }
}
