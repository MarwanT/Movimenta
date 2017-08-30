//
//  Selection.swift
//  Movimenta
//
//  Created by Marwan  on 8/25/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

enum Selection {
  case all
  case some
  case none
  
  var opposite: Selection {
    switch self {
    case .all:
      return .none
    case .some:
      return .all
    case .none:
      return .all
    }
  }
}
