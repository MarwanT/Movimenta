//
//  Venue.swift
//  Movimenta
//
//  Created by Marwan  on 7/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import CoreLocation
import Foundation

struct Venue: ModelCommonProperties {
  var id: String?
  var link: URL?
  var content: String?
  var title: String?
  var excerpt: String?
  var name: String?
  var address: String?
  var city: String?
  var state: String?
  var country: String?
  var website: URL?
  var phone: String?
  var mapLink: URL?
  var email: String?
  var zipcode: String?
  var image: URL?
  var mapAddress: String?
  var coordinates: CLLocationCoordinate2D?
}
}
