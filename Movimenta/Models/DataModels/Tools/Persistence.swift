//
//  Persistence.swift
//  Movimenta
//
//  Created by Marwan  on 7/25/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

struct Persistence {
  let documentsDirectory: URL
  let eventsArchive: URL
  
  static let shared = Persistence()
  private init() {
    documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    eventsArchive = documentsDirectory.appendingPathComponent("movimenta-events")
  }
  
  func save(data: Data) {
    try? data.write(to: eventsArchive)
  }
}
