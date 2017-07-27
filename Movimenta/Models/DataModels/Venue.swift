//
//  Venue.swift
//  Movimenta
//
//  Created by Marwan  on 7/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import CoreLocation
import Foundation
import SwiftyJSON

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

extension Venue: Parsable {
  static func object(from json: JSON) -> Venue? {
    let id = json["id"].stringValue
    let link = json["link"].url
    let content = json["content"].string
    let title = json["title"].string
    let excerpt = json["excerpt"].string
    let name = json["name"].string
    let address = json["address"].string
    let city = json["city"].string
    let state = json["state"].string
    let country = json["country"].string
    let website = json["website"].url
    let phone = json["phone"].string
    let mapLink = json["mapLink"].url
    let email = json["email"].string
    let zipcode = json["zipcode"].string
    let image = json["image"].url
    let mapAddress = json["coordinates"]["address"].string
    let coordinates = CLLocationCoordinate2D.object(from: json["coordinates"])
    
    return Venue(id: id, link: link, content: content, title: title, excerpt: excerpt, name: name, address: address, city: city, state: state, country: country, website: website, phone: phone, mapLink: mapLink, email: email, zipcode: zipcode, image: image, mapAddress: mapAddress, coordinates: coordinates)
  }
}