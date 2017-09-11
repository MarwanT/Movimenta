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
  fileprivate var mapViewImageView: UIImageView!
  @IBOutlet weak var eventDetailsPeekView: EventDetailsPeekView!
  @IBOutlet weak var filtersBreadcrumbView: FiltersBreadcrumbView!
  
  @IBOutlet weak var eventDetailsPeekViewTopConstraintToSuperviewBottom: NSLayoutConstraint!
  @IBOutlet weak var eventDetailsPeekViewBottomConstraintToSuperviewBottom: NSLayoutConstraint!
  @IBOutlet weak var filtersBreadcrumbTopToSuperviewTop: NSLayoutConstraint!
  @IBOutlet weak var filtersBreadcrumbBottomToSuperviewTop: NSLayoutConstraint!
  
  var animationDuration: TimeInterval = 0.4
  
  let locationManager = CLLocationManager()
  static var currentLocation: CLLocation? = nil
  
  var viewModel = EventsMapViewModel()
  
  var eventDetailsSnapPosition: Direction = .bottom
  
  var eventsMapNavigationDelegate = EventsMapNavigationDelegate()
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = Strings.event_map()
    
    // Initialization
    initializeFiltersBreadcrumbView()
    initializeMapsView()
    initializeEventDetailsPeekView()
    initializeLocationManager()
    initializeInteractivePopGestureRecognizer()
    setupNavigationItems()
    refreshMapVisibleArea()
    
    // Loading Data
    reloadEvents()
    
    // Add observers
    addObservers()
    
    self.navigationController?.delegate = eventsMapNavigationDelegate
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    showMapViewMask()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    hideMapViewMask()
  }
  
  private func initializeFiltersBreadcrumbView() {
    filtersBreadcrumbView.delegate = self
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
    
    // Initialize map view image view
    mapViewImageView = UIImageView(frame: CGRect.zero)
    mapViewImageView.isHidden = true
    view.insertSubview(mapViewImageView, aboveSubview: mapView)
    mapViewImageView.snp.makeConstraints { (maker) in
      maker.edges.equalTo(view)
    }
  }
  
  private func initializeEventDetailsPeekView() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleEventDetailsPeekView(panGesture:)))
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEventDetailsPeekView(tapGesture:)))
    eventDetailsPeekView.addGestureRecognizer(panGesture)
    eventDetailsPeekView.addGestureRecognizer(tapGesture)
  }
  
  private func initializeLocationManager() {
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.distanceFilter = 50
    locationManager.startUpdatingLocation()
    locationManager.delegate = self
  }
  
  private func initializeInteractivePopGestureRecognizer() {
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }
  
  private func setupNavigationItems() {
    let filtersButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filters"), style: .plain, target: self, action: #selector(handleFiltersButtonTap(_:)))
    navigationItem.rightBarButtonItem = filtersButton
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(reloadEvents), name: AppNotification.didLoadData, object: nil)
  }
  
  func handleEventDetailsPeekView(panGesture: UIPanGestureRecognizer) {
    if (panGesture.state == UIGestureRecognizerState.began) {
      eventsMapNavigationDelegate.interactionController = UIPercentDrivenInteractiveTransition()
      navigateToEventDetailsVC()
    } else if (panGesture.state == UIGestureRecognizerState.changed) {
      let translation = panGesture.translation(in: view)
      let percentComplete = (translation.y / view.bounds.height) * -1;
      eventDetailsPeekView.transform = CGAffineTransform(translationX: 0, y: translation.y)
      eventsMapNavigationDelegate.interactionController?.update(percentComplete)
    } else if (panGesture.state == UIGestureRecognizerState.ended) {
      let velocity = panGesture.velocity(in: view)
      if velocity.y < 0 {
        // finish
        snapEventDetailsPeekView(direction: .top)
        eventsMapNavigationDelegate.interactionController?.finish()
      } else {
        // cancel
        snapEventDetailsPeekView(direction: .bottom)
        eventsMapNavigationDelegate.interactionController?.cancel()
      }
      eventsMapNavigationDelegate.interactionController = nil
    }
  }
  
  func handleEventDetailsPeekView(tapGesture: UIPanGestureRecognizer) {
    switch eventDetailsSnapPosition {
    case .top:
      snapEventDetailsPeekView(direction: .bottom)
    case .bottom:
      snapEventDetailsPeekView(direction: .top)
      navigateToEventDetailsVC()
    }
  }
  
  func handleFiltersButtonTap(_ sender: UIBarButtonItem) {
    navigateToFiltersVC()
  }
}

//MARK: - Data Related APIs
extension EventsMapViewController {
  /// Reload events based on filters selected and refresh UI
  func reloadEvents() {
    viewModel.loadEvents()
    refreshMapView()
  }
  
  fileprivate func refreshMapView() {
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
    eventDetailsPeekView.titleLabel.text = event.title
    eventDetailsPeekView.subtitleLabel.text = event.displayedCategoryLabel
    showEventDetailsPeekView()
  }
  
  fileprivate func refreshBreadcrumbView() {
    if !viewModel.filter.isZero {
      showBreadcrumbsView(with: viewModel.filter)
    } else {
      hideBreadcrumbsView()
    }
  }
  
  fileprivate func showBreadcrumbsView(with filter: Filter) {
    filtersBreadcrumbView.setBreadcrumbs(for: filter)
    showBreadcrumbsView()
  }
}

//MARK: - Helper Methods
extension EventsMapViewController {
  //======================================================
  // Map Helpers
  
  fileprivate func showMapViewMask() {
    mapViewImageView.image = UIImage(view: mapView)
    mapViewImageView.isHidden = false
    mapView.isHidden = true
  }
  
  fileprivate func hideMapViewMask() {
    mapView.isHidden = false
    UIView.animate(withDuration: animationDuration, animations: { 
      self.mapViewImageView.alpha = 0
    }) { (finished) in
      self.mapViewImageView.isHidden = true
      self.mapViewImageView.alpha = 1
    }
  }
  
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
    let isBreadcrumbsViewVisible = !viewModel.filter.isZero
    let paddingBottom = isEventDetailsPeekViewVisible ? eventDetailsPeekView.bounds.height : 0
    let paddingTop = isBreadcrumbsViewVisible ? filtersBreadcrumbView.bounds.height : 0
    mapView.padding = UIEdgeInsets(top: paddingTop, left: 0, bottom: paddingBottom, right: 0)
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
  
  fileprivate func navigateToFiltersVC() {
    let vc = FiltersViewController.instance()
    vc.delegate = self
    vc.initialize(with: viewModel.filter)
    navigationController?.pushViewController(vc, animated: true)
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }
  
  //======================================================
  // Breadcrumbs Helpers
  
  fileprivate func showBreadcrumbsView() {
    if filtersBreadcrumbBottomToSuperviewTop.isActive {
      view.removeConstraint(filtersBreadcrumbBottomToSuperviewTop)
    }
    if !filtersBreadcrumbTopToSuperviewTop.isActive {
      view.addConstraint(filtersBreadcrumbTopToSuperviewTop)
    }
    view.setNeedsUpdateConstraints()
    UIView.animate(withDuration: animationDuration) {
      self.view.layoutIfNeeded()
      self.refreshMapVisibleArea()
    }
  }
  
  fileprivate func hideBreadcrumbsView(clear: Bool = true) {
    if filtersBreadcrumbTopToSuperviewTop.isActive {
      view.removeConstraint(filtersBreadcrumbTopToSuperviewTop)
    }
    if !filtersBreadcrumbBottomToSuperviewTop.isActive {
      view.addConstraint(filtersBreadcrumbBottomToSuperviewTop)
    }
    view.setNeedsUpdateConstraints()
    UIView.animate(withDuration: animationDuration) {
      self.view.layoutIfNeeded()
      self.refreshMapVisibleArea()
    }
  }
  
  //======================================================
  // Event Details Peek Helpers
  
  fileprivate func navigateToEventDetailsVC() {
    guard let event = viewModel.selectedMapEvent?.event else {
      return
    }
    
    let vc = EventDetailsViewController.instance()
    vc.initialize(with: event)
    navigationController?.pushViewController(vc, animated: true)
    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  }
  
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
  
  func snapEventDetailsPeekView(direction: Direction) {
    eventDetailsSnapPosition = direction
    
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
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    EventsMapViewController.currentLocation = manager.location
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

//MARK: - Filters View Controller Delegate
extension EventsMapViewController: FiltersViewControllerDelegate {
  func filters(_ viewController: FiltersViewController, didApply filter: Filter) {
    viewModel.apply(filter: filter)
    refreshMapView()
    refreshEventDetailsForSelection()
    refreshBreadcrumbView()
  }
  
  func filtersDidReset(_ viewController: FiltersViewController) {
    viewModel.resetFilter()
    refreshMapView()
    refreshEventDetailsForSelection()
    refreshBreadcrumbView()
  }
}

//MARK: - Filters Breadcrumb View Delegate
extension EventsMapViewController: FiltersBreadcrumbViewDelegate {
  func filtersBreadcrumbView(_ view: FiltersBreadcrumbView, didTap breadcrumb: Breadcrumb) {
    navigateToFiltersVC()
  }
}

//MARK: - Gesture Recognizer Delegate
extension EventsMapViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

//MARK: - Navigation Delegate
extension EventsMapViewController {
  class EventsMapNavigationDelegate: NSObject, UINavigationControllerDelegate {
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      switch operation {
      case .push:
        guard verifyViewControllers(eventsMap: fromVC, eventDetails: toVC) else {
          return nil
        }
        return SlideUpAnimator()
      case .pop:
        guard verifyViewControllers(eventsMap: toVC, eventDetails: fromVC) else {
          return nil
        }
        return SlideDownAnimator()
      default:
        return nil
      }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
      return self.interactionController
    }
    
    private func verifyViewControllers(eventsMap: UIViewController, eventDetails: UIViewController) -> Bool {
      return (eventsMap is EventsMapViewController) && (eventDetails is EventDetailsViewController)
    }
  }
  
  class SlideUpAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      guard let eventMapsVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? EventsMapViewController,
        let eventDetailsVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? EventDetailsViewController,
        let eventMapsView = eventMapsVC.view,
        let eventDetailsView = eventDetailsVC.view
      else {
        return
      }
      
      transitionContext.containerView.addSubview(eventDetailsView)
      
      var bottomPoint = eventMapsView.frame.origin
      bottomPoint.y += (eventMapsView.frame.height - eventMapsVC.eventDetailsPeekView.frame.height)
      
      eventDetailsView.frame = eventMapsView.frame
      eventDetailsView.frame.origin = bottomPoint
      eventDetailsView.alpha = 0.5
      
      var origin = eventMapsView.frame.origin
      
      UIView.animate(withDuration: transitionDuration(using: nil) , animations: { () -> Void in
        eventDetailsView.frame.origin = origin
        eventDetailsView.alpha = 1
      }) { (completed: Bool) -> Void in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
    }
  }
  
  class SlideDownAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      guard let eventMapsVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? EventsMapViewController,
        let eventDetailsVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? EventDetailsViewController,
        let eventMapsView = eventMapsVC.view,
        let eventDetailsView = eventDetailsVC.view
        else {
          return
      }
      
      transitionContext.containerView.insertSubview(eventMapsView, belowSubview: eventDetailsView)
      
      var bottomPoint = eventMapsView.frame.origin
      bottomPoint.y += eventMapsView.frame.height
      
      eventMapsVC.snapEventDetailsPeekView(direction: .bottom)
      
      UIView.animate(withDuration: transitionDuration(using: nil) , animations: { () -> Void in
        eventDetailsView.frame.origin = bottomPoint
        eventDetailsView.alpha = 0.5
      }) { (completed: Bool) -> Void in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
    }
  }
}