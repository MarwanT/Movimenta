//
//  DataManager.swift
//  Movimenta
//
//  Created by Marwan  on 7/21/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

class DataManager {
  var movimentaEvent: MovimentaEvent? = nil {
    didSet {
      // Send notification that data has been updated
    }
  }
  
  static let shared = DataManager()
  private init() {}
  
  func reloadData() {
    loadLocalData()
  }
  
  private func loadLocalData() {
    guard let eventsData = Persistence.shared.read(),
      let movimentaEvents = Parser.parseMovimentaEvents(from: eventsData),
      let mainEvent = movimentaEvents.first else {
        return
    }
    movimentaEvent = mainEvent
  }
  
}
