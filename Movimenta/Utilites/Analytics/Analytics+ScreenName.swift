//
//  Analytics+ScreenName.swift
//  Movimenta
//
//  Created by Marwan  on 7/19/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension Analytics {
  struct ScreenName {
    let name: String
    fileprivate init(name: String) {
      self.name = name
    }
  }
  
  struct ScreenNames {
    private init() {}
    static let Default = ScreenName(name: "[DEFAULT]")
  }
}
