//
//  Event.swift
//  Movimenta
//
//  Created by Marwan  on 7/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import CoreLocation
import Foundation

struct Event: ModelCommonProperties {
  var id: String?
  var link: URL?
  var content: String?
  var title: String?
  var excerpt: String?
  var subtitle: String?
  var languageCode: String?
  var typesIds: [String]?
  var categoriesIds: [String]?
  var image: URL?
  var venueId: String?
  var coordinates: CLLocationCoordinate2D?
  var address: String?
  var organizersIds: [String]?
  var speakersIds: [String]?
  var artistsIds: [String]?
  var companiesIds: [String]?
  var sponsorsIds: [String]?
  var dates: [DateRange]?
}

//MARK: - Declare Event Category
extension Event {
  struct Category {
    var id: String?
    var label: String?
    var subCategories: [Category]?
  }
}

//MARK: - Declare Event Type
extension Event {
  struct EventType {
    var id: String?
    var label: String?
  }
}
