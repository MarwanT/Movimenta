//
//  FiltersManager.swift
//  Movimenta
//
//  Created by Marwan  on 8/21/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

class FiltersManager {
  var events: [Event]? = nil
  
  static let shared = FiltersManager()
  private init() {}
  
  func intialize(with events: [Event]) {
    self.events = events
  }
  
}

//MARK: API
extension FiltersManager {
  var firstEventDate: Date {
    return events?.first?.dates?.first?.from ?? Date()
  }
  
  var lastEventDate: Date {
    return events?.sortedDescending().first?.dates?.first?.to ?? Date()
  }
  
  var categories: [Event.Category] {
    var mainCategories: [Event.Category] = []
    events?.forEach({ (event) in
      event.categories.forEach({ (category) in
        if let index = mainCategories.index(of: category) {
          let subcat = Event.Category.subCategories(of: mainCategories[index], and: category)
          mainCategories[index].subCategories = subcat
        } else {
          mainCategories.append(category)
        }
      })
      
    })
    return mainCategories
  }
}

//MARK: Helpers
extension FiltersManager {
  
}
