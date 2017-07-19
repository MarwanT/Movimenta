//
//  Analytics+Event.swift
//  Movimenta
//
//  Created by Marwan  on 7/19/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension Analytics {
  struct Event {
    let category: Category
    let action: Action
    let name: String
    let value: Double
    let info: [String : String]
    
    init(category: Category, action: Action, name: String = "", value: Double = 0.0, info: [String : String] = [:]) {
      self.category = category
      self.action = action
      self.name = name
      self.value = value
      self.info = info
    }
  }
}
