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
  let facebookAppDisplayName: String
  let facebookAppId: String
  let googleAnalyticsIdentifier: String
  let apiBaseURL: String
  
  static let shared = AppKeys()
  
  private init(keys: MovimentaKeys) {
    self.environmentString = keys.movimentaEnvironment
    self.facebookAppDisplayName = keys.movimentaFacebookAppDisplayName
    self.facebookAppId = keys.movimentaFacebookAppId
    self.googleAnalyticsIdentifier = keys.movimentaGoogleAnalyticsIdentifier
    self.apiBaseURL = keys.movimentaAPIBaseURL
  }
  
  private init() {
    self.init(keys: MovimentaKeys())
  }
}
