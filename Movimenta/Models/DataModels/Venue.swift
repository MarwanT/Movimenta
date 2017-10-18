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
  var gallery: [URL]?
  
  var fullAddress: String {
    let items = [address, city, state, country].flatMap { (item) -> String? in
      guard let item = item, !item.isEmpty else {
        return nil
      }
      return item
    }
    return items.joined(separator: ", ")
  }
}

extension Venue: Parsable {
  static func object(from json: JSON) -> Venue? {
    let id = json["id"].stringValue
    let link = json["link"].url
    let content = json["content"].string
    let title = json["title"].string?.cleanedHTMLTags()
    let excerpt = json["excerpt"].string?.cleanedHTMLTags()
    let name = json["name"].string?.cleanedHTMLTags()
    let address = json["address"].string?.cleanedHTMLTags()
    let city = json["city"].string?.cleanedHTMLTags()
    let state = json["state"].string
    let country = json["country"].string
    let website = json["website"].url
    let phone = json["phone"].string
    let mapLink = json["mapLink"].url
    let email = json["email"].string
    let zipcode = json["zipcode"].string
    let image = json["image"].url
    let mapAddress = json["coordinates"]["address"].string?.cleanedHTMLTags()
    let coordinates = CLLocationCoordinate2D.object(from: json["coordinates"])
    let gallery = URL.objects(from: json["gallery"])
    
    return Venue(id: id, link: link, content: content, title: title, excerpt: excerpt, name: name, address: address, city: city, state: state, country: country, website: website, phone: phone, mapLink: mapLink, email: email, zipcode: zipcode, image: image, mapAddress: mapAddress, coordinates: coordinates, gallery: gallery)
  }
}
