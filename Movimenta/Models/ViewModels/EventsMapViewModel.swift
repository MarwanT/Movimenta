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
  var selectedMapEvent: MapEvent? = nil {
    didSet {
      /**
       Updating the marker 'tracksViewChanges' property is required
       To reflect the image change upon changing value of the isHighlighted flag.
       */
      
      oldValue?.marker.tracksViewChanges = true
      selectedMapEvent?.marker.tracksViewChanges = true
      
      oldValue?.marker.iconImageView?.isHighlighted = false
      selectedMapEvent?.marker.iconImageView?.isHighlighted = true
      
      oldValue?.marker.tracksViewChanges = false
      selectedMapEvent?.marker.tracksViewChanges = false
    }
  }
  
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
