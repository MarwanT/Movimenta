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
  @IBOutlet weak var eventDetailsPeekView: EventDetailsPeekView!
  
  @IBOutlet weak var eventDetailsPeekViewTopConstraintToSuperviewBottom: NSLayoutConstraint!
  @IBOutlet weak var eventDetailsPeekViewBottomConstraintToSuperviewBottom: NSLayoutConstraint!
  
  var animationDuration: TimeInterval = 0.4
  
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
    initializeEventDetailsPeekView()
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
    view.sendSubview(toBack: mapView)
    mapView.snp.makeConstraints { (maker) in
      maker.edges.equalTo(view)
    }
  }
  
  private func initializeEventDetailsPeekView() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleEventDetailsPeekView(_:)))
    eventDetailsPeekView.addGestureRecognizer(panGesture)
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
  
  func handleEventDetailsPeekView(_ gesture: UIPanGestureRecognizer) {
    if (gesture.state == UIGestureRecognizerState.began) {
    } else if (gesture.state == UIGestureRecognizerState.changed) {
      let translation = gesture.translation(in: view)
      eventDetailsPeekView.transform = CGAffineTransform(translationX: 0, y: translation.y)
    } else if (gesture.state == UIGestureRecognizerState.ended) {
      let velocity = gesture.velocity(in: view)
      if velocity.x < 0 {
        // finish
        snapEventDetailsPeekView(direction: .top)
      } else {
        // cancel
        snapEventDetailsPeekView(direction: .bottom)
      }
    }
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
    if let mapEvent = viewModel.selectedMapEvent {
      showEventDetailsPeekView(event: mapEvent.event)
    } else {
      hideEventDetailsPeekView()
    }
  }
  
  func showEventDetailsPeekView(event: Event) {
    showEventDetailsPeekView()
  }
}

//MARK: - Helper Methods
extension EventsMapViewController {
  //======================================================
  // Map Helpers
  
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
    let isEventDetailsPeekViewVisible = viewModel.selectedMapEvent != nil
    let paddingBottom: CGFloat = isEventDetailsPeekViewVisible ? eventDetailsPeekView.bounds.height : 0
    mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: paddingBottom, right: 0)
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
  
  //======================================================
  // Event Details Peek View Helpers
  
  func showEventDetailsPeekView() {
    if eventDetailsPeekViewTopConstraintToSuperviewBottom.isActive {
      view.removeConstraint(eventDetailsPeekViewTopConstraintToSuperviewBottom)
    }
    if !eventDetailsPeekViewBottomConstraintToSuperviewBottom.isActive {
      view.addConstraint(eventDetailsPeekViewBottomConstraintToSuperviewBottom)
    }
    view.setNeedsUpdateConstraints()
    UIView.animate(withDuration: animationDuration) {
      self.view.layoutIfNeeded()
      self.refreshMapVisibleArea()
    }
  }
  
  func hideEventDetailsPeekView() {
    if eventDetailsPeekViewBottomConstraintToSuperviewBottom.isActive {
      view.removeConstraint(eventDetailsPeekViewBottomConstraintToSuperviewBottom)
    }
    if !eventDetailsPeekViewTopConstraintToSuperviewBottom.isActive {
      view.addConstraint(eventDetailsPeekViewTopConstraintToSuperviewBottom)
    }
    view.setNeedsUpdateConstraints()
    UIView.animate(withDuration: animationDuration) { 
      self.view.layoutIfNeeded()
      self.refreshMapVisibleArea()
    }
  }
  
  fileprivate func snapEventDetailsPeekView(direction: Direction) {
    var value: CGFloat = 0
    switch direction {
    case .top:
      value = view.bounds.height - eventDetailsPeekView.bounds.height
    case .bottom:
      value = 0
    }
  
    eventDetailsPeekViewBottomConstraintToSuperviewBottom.constant = -value
    view.setNeedsUpdateConstraints()
    UIView.animate(withDuration: animationDuration) {
      self.eventDetailsPeekView.transform = CGAffineTransform(translationX: 0, y: 0)
      self.view.layoutIfNeeded()
    }
  }
  
  enum Direction {
    case top
    case bottom
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
