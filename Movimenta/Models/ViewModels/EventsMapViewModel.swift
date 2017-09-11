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
  fileprivate(set) var filter: Filter = Filter.zero
  var selectedMapEvent: MapEvent? = nil {
    didSet {
      oldValue?.marker.iconImageView?.isHighlighted = false
      selectedMapEvent?.marker.iconImageView?.isHighlighted = true
    }
  }
  
  func loadEvents() {
    loadMapEvents(for: DataManager.shared.events)
    selectedMapEvent = nil
  }
  
  func apply(filter: Filter) {
    self.filter = filter
    loadMapEvents(for: FiltersManager.shared.filteredEvents(for: filter))
    selectedMapEvent = nil
  }
  
  func resetFilter() {
    filter = Filter.zero
    loadEvents()
  }
  
  private func loadMapEvents(for events: [Event]) {
    mapEvents = events.flatMap { (event) -> MapEvent? in
      guard let position = event.coordinates else {
        return nil
      }
      let marker = GMSMarker.movimentaMarker(position: position)
      return (event, marker)
    }
  }
  
  /** 
   Returns boolean value indicating wether the tapped marker is
   being selected or unselected
   */
  func updateMapEventSelection(for marker: GMSMarker) -> Bool {
    guard let mapEvent = mapEvents.filter({ $0.marker === marker }).first else {
      return false
    }
    
    if mapEvent.event == selectedMapEvent?.event { // Unselect
      selectedMapEvent = nil
    } else { // Select
      selectedMapEvent = mapEvent
    }

    return selectedMapEvent != nil
  }
}
