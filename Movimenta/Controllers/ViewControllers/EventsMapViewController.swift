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
  
  let locationManager = CLLocationManager()
  
  var viewModel = EventsMapViewModel()
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = Strings.event_map()
    
    // Initialization
    initializeMapsView()
    initializeLocationManager()
    refreshMapVisibleArea()
    
    // Loading Data
    reloadEvents()
    
    // Add observers
    addObservers()
  }
  
  private func initializeMapsView() {
    let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: MapZoom.world)
    mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    mapView.delegate = self
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
    view.addSubview(mapView)
    mapView.snp.makeConstraints { (maker) in
      maker.edges.equalTo(view)
    }
  }
  
  private func initializeLocationManager() {
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.distanceFilter = 50
    locationManager.startUpdatingLocation()
    locationManager.delegate = self
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(reloadEvents), name: AppNotification.didLoadData, object: nil)
  }
}

//MARK: - Data Related APIs
extension EventsMapViewController {
  /// Reload events based on filters selected and refresh UI
  func reloadEvents() {
    viewModel.loadEvents()
    refreshMarkers()
    updateCameraForMapEvents()
  }
  
  fileprivate func refreshEventDetailsForSelection() {
    // TODO: To be implemented
  }
}

//MARK: - Helper Methods
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
  
  fileprivate func clearMarkers() {
    mapView.clear()
  }
  
  fileprivate func refreshMapVisibleArea() {
    //Calculate overlapping views and update padding
    mapView.padding = UIEdgeInsets.zero
  }
  
  fileprivate func updateCameraForSelection() {
    guard let mapEvent = viewModel.selectedMapEvent else {
      return
    }
    updateCamera(mapEvent: mapEvent)
  }
  
  fileprivate func updateCameraForMapEvents() {
    updateCamera(mapEvents: viewModel.mapEvents)
  }
  
  fileprivate func updateCamera(mapEvent: MapEvent) {
    guard let coordinates = mapEvent.event.coordinates else {
      return
    }
    let camera = GMSCameraPosition.camera(withTarget: coordinates, zoom: MapZoom.street)
    mapView.animate(to: camera)
  }
  
  fileprivate func updateCamera(mapEvents: [MapEvent]) {
    let coordinates = mapEvents.map { (event, marker) in
      return marker.position
    }

    guard coordinates.count > 0 else {
      return
    }
    
    var bounds = GMSCoordinateBounds()
    coordinates.forEach { coordinates in
      bounds = bounds.includingCoordinate(coordinates)
    }
    
    let cameraUpdate = GMSCameraUpdate.fit(bounds)
    mapView.animate(with: cameraUpdate)
  }
}

//MARK: - Map View Delegate
extension EventsMapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    _ = viewModel.updateMapEventSelection(for: marker)
    updateCameraForSelection()
    refreshEventDetailsForSelection()
    return true
  }
}

//MARK: - Location Manager Delegate
extension EventsMapViewController: CLLocationManagerDelegate {
  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .denied:
      // TODO: Display Alert stating that the app have no access to the user location
      return
    default:
      return
    }
  }
  
  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    print("Error: \(error)")
  }
}

//MARK: - Instance
extension EventsMapViewController {
  static func instance() -> EventsMapViewController {
    return Storyboard.Event.instantiate(EventsMapViewController.self)
  }
}

//MARK: - Map Zoom
struct MapZoom{
  static let world: Float = 1
  static let street: Float = 15
}
