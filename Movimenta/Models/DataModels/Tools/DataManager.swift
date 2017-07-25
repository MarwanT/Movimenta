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
      NotificationCenter.default.post(name: AppNotification.didLoadData, object: nil)
    }
  }
  
  static let shared = DataManager()
  private init() {}
  
  func reloadData() {
    loadLocalData()
    loadDataFromServer()
  }
  
  private func loadLocalData() {
    guard let eventsData = Persistence.shared.read(),
      let movimentaEvents = Parser.parseMovimentaEvents(from: eventsData),
      let mainEvent = movimentaEvents.first else {
        return
    }
    movimentaEvent = mainEvent
  }
  
  private func loadDataFromServer() {
    _ = MovimentaEventAPI.fetchMovimentaEventsDetails { (success, data, events, error) in
      guard success, let data = data, let mainEvent = events?.first else {
        return
      }
      
      Persistence.shared.save(data: data)
      self.movimentaEvent = mainEvent
    }
  }
}
