//
//  Environment.swift
//  Movimenta
//
//  Created by Marwan  on 7/19/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

struct Environment {
  enum EnvironmentType: String {
    case staging = "staging"
    case production = "production"
  }
  
  static let current = Environment()
  
  let type: EnvironmentType
  let googleAnalyticsIdentifier: String
  let facebook: (id: String, displayName: String)
  let apiBaseURL: URL
  
  private init() {
    type = EnvironmentType(rawValue: AppKeys.shared.environmentString) ?? .staging
    googleAnalyticsIdentifier = AppKeys.shared.googleAnalyticsIdentifier
    facebook = (AppKeys.shared.facebookAppId, AppKeys.shared.facebookAppDisplayName)
    apiBaseURL = URL(string: AppKeys.shared.apiBaseURL)!
  }
}
