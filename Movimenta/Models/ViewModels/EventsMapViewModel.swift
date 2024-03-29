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
  
  /// If there are events today, then this method loads the events happening today.
  /// Otherwise it loads all the events available
  func loadPreferredEvents() {
    let todayFilter = self.todayFilter
    let candidateEvents = FiltersManager.shared.filteredEvents(for: todayFilter)
    if candidateEvents.count > 0 {
      self.filter = todayFilter
      mapEvents = mapEvents(for: candidateEvents)
      selectedMapEvent = nil
    } else {
      loadEvents()
    }
  }
  
  func loadEvents() {
    mapEvents = mapEvents(for: DataManager.shared.events)
    selectedMapEvent = nil
  }
  
  func apply(filter: Filter) {
    self.filter = filter
    mapEvents = mapEvents(for: FiltersManager.shared.filteredEvents(for: filter))
    selectedMapEvent = nil
  }
  
  func resetFilter() {
    filter = Filter.zero
    loadEvents()
  }
  
  func updateFilter(byRemoving breadcrumb: Breadcrumb) {
    self.filter.updateFilter(byRemoving: breadcrumb)
    apply(filter: self.filter)
  }
  
  private func mapEvents(for events: [Event]) -> [MapEvent] {
    return events.flatMap { (event) -> MapEvent? in
      guard let position = event.preferredCoordinates else {
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
  
  //MARK: Helpers
  fileprivate var todayFilter: Filter {
    var filter = Filter()
    let todayDate = Date()
    filter.dateRange = DateRange(from: todayDate, to: todayDate)
    return filter
  }
}
