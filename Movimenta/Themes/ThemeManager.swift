//
//  ThemeManager.swift
//  Movimenta
//
//  Created by Marwan  on 7/27/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

class ThemeManager {
  static let shared = ThemeManager()
  
  var current: Theme {
    didSet{
      // TODO: Send notification for updating the layout throughout the app
    }
  }
  
  private init() {
    current = MovimentaTheme()
  }
}
