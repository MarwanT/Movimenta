//
//  Analytics+Action.swift
//  Movimenta
//
//  Created by Marwan  on 7/19/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension Analytics {
  enum Action {
    case Default
    
    var name: String {
      switch self {
      case .Default:
        return "[DEFAULT]"
      }
    }
  }
}
