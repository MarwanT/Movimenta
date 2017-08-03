//
//  EventsMapViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 8/2/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import GoogleMaps

typealias MapEvent = (event: Event, marker: GMSMarker)

final class EventsMapViewModel {
  var mapEvents: [MapEvent] = []
  
  func loadEvents() {
    mapEvents = DataManager.shared.events.flatMap { (event) -> MapEvent? in
      guard let position = event.coordinates else {
        return nil
      }
      let marker = GMSMarker.movimentaMarker(position: position)
      return (event, marker)
    }
    //TODO: Filter events
  }
}
