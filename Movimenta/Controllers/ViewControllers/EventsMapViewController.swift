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
  }
  
  private func initializeMapsView() {
    let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 1.0)
    mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    view.addSubview(mapView)
    mapView.snp.makeConstraints { (maker) in
      maker.edges.equalTo(view)
    }
  }
  
  fileprivate func refreshMapVisibleArea() {
    //Calculate overlapping views and update padding
    mapView.padding = UIEdgeInsets.zero
  }
}

//MARK: Instance
extension EventsMapViewController {
  static func instance() -> EventsMapViewController {
    return Storyboard.Event.instantiate(EventsMapViewController.self)
  }
}
