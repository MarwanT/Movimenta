//
//  EventsMapViewController.swift
//  Movimenta
//
//  Created by Marwan  on 8/2/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import GoogleMaps
import SnapKit
import UIKit

class EventsMapViewController: UIViewController {
  fileprivate var mapView: GMSMapView!
  
  var viewModel = EventsMapViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = Strings.event_map()
    
    initializeMapsView()
    
    refreshMapVisibleArea()
    
    // Loading Data
    reloadEvents()
  }
  
  private func initializeMapsView() {
    let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 1.0)
    mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    mapView.delegate = self
    view.addSubview(mapView)
    mapView.snp.makeConstraints { (maker) in
      maker.edges.equalTo(view)
    }
  }
  
}

///MARK: - Data Related APIs
extension EventsMapViewController {
  /// Reload events based on filters selected and refresh UI
  func reloadEvents() {
    viewModel.loadEvents()
    refreshMarkers()
  }
}

///MARK: - Helper Methods
extension EventsMapViewController {
  fileprivate func refreshMarkers() {
    clearMarkers()
    setEventsMarkers(events: viewModel.mapEvents)
  }
  
  fileprivate func setEventsMarkers(events: [MapEvent]) {
    for mapEvent in events {
      mapEvent.marker.map = mapView
    }
  }
  
  fileprivate func refreshMapVisibleArea() {
    //Calculate overlapping views and update padding
    mapView.padding = UIEdgeInsets.zero
  }
  
  fileprivate func clearMarkers() {
    mapView.clear()
  }
}

//MARK: Map View Delegate
extension EventsMapViewController: GMSMapViewDelegate {
  
}

//MARK: Instance
extension EventsMapViewController {
  static func instance() -> EventsMapViewController {
    return Storyboard.Event.instantiate(EventsMapViewController.self)
  }
}
