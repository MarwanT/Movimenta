//
//  CLLocationCoordinate2D+Util.swift
//  Movimenta
//
//  Created by Marwan  on 8/22/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import CoreLocation
import Foundation
import GoogleMaps

extension CLLocationCoordinate2D {
  static func getDistance(fromCoordinates one: CLLocationCoordinate2D, toCoordinates two: CLLocationCoordinate2D) -> CLLocationDistance {
    return GMSGeometryDistance(one, two)
  }
}
