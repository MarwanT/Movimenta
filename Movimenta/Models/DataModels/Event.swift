//
//  Event.swift
//  Movimenta
//
//  Created by Marwan  on 7/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

struct Event {
}

//MARK: - Declare Event Category
extension Event {
  struct Category {
    var id: String?
    var label: String?
    var subCategories: [Category]?
  }
}
