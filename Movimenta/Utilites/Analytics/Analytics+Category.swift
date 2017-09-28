//
//  Analytics+Category.swift
//  Movimenta
//
//  Created by Marwan  on 7/19/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension Analytics {
  enum Category {
    //Use in switch cases default clause
    case Default
    case events
    case venue
    case participants
    case schedule
    case augmentedReality
    case info
    
    var name: String {
      switch self {
      case .Default:
        return "[DEFAULT]"
      case .events:
        return "Events"
      case .venue:
        return "Venue"
      case .participants:
        return "Participants"
      case .schedule:
        return "Schedule"
      case .augmentedReality:
        return "Augmented Reality"
      case .info:
        return "Info"
      }
    }
  }
}
