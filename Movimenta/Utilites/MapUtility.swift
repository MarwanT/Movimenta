//
//  MapUtility.swift
//  Movimenta
//
//  Created by Marwan  on 9/22/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import CoreLocation
import Foundation

class MapUtility {
  class func getStaticMapImageURL(for coordinates: CLLocationCoordinate2D, with configuration: MapImageConfiguration = MapImageConfiguration()) -> URL? {
    return URL(string: getStaticMapImageURLString(for: coordinates, with: configuration))
  }
  
  class func getStaticMapImageURLString(for coordinates: CLLocationCoordinate2D, with configuration: MapImageConfiguration = MapImageConfiguration()) -> String {
    return "\(configuration.staticMapBaseURL)?\(configuration.coordinates)=\(coordinates.latitude),\(coordinates.longitude)&\(configuration.zoom)&\(configuration.size)&\(configuration.sensor)&\(configuration.marker)%7C\(coordinates.latitude),\(coordinates.longitude)"
  }
  
  class func direction(from origin: CLLocationCoordinate2D?, to destination: CLLocationCoordinate2D) {
    let configuration = DirectionConfiguration()
    var parameters = ""
    var separator = ""
    
    if let origin = origin {
      parameters += "origin=\(origin.latitude),\(origin.longitude)"
      separator = "&"
    }
    
    parameters += "\(separator)destination=\(destination.latitude),\(destination.longitude)"
    
    if let url = URL(string: configuration.baseURL + parameters) {
      UIApplication.openUrl(url: url)
    }
  }
}

extension MapUtility {
  struct MapImageConfiguration {
    fileprivate var staticMapBaseURL = "http://maps.google.com/maps/api/staticmap"
    var coordinates = "center"
    var zoom = "zoom=15"
    var size = "size=600x600"
    var sensor = "sensor=false"
    var marker = "markers=icon:https://image.ibb.co/jFmfR5/icon_pin_map_selected_blue_copy.png"
  }
  
  struct DirectionConfiguration {
    fileprivate var baseURL = "https://www.google.com/maps/dir/?api=1"
  }
}

//MARK: - CLLocationCoordinate2D
extension CLLocationCoordinate2D {
  var mapImageURL: URL? {
    return MapUtility.getStaticMapImageURL(for: self)
  }
}
