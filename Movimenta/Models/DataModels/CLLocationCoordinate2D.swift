//
//  CLLocationCoordinate2D.swift
//  Movimenta
//
//  Created by Marwan  on 7/24/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import CoreLocation
import Foundation
import SwiftyJSON

extension CLLocationCoordinate2D: Parsable {
  static func object(from json: JSON) -> CLLocationCoordinate2D? {
    return CLLocationCoordinate2D(
      latitude: json["lat"].doubleValue,
      longitude: json["lng"].doubleValue)
  }
}
