//
//  Event.swift
//  Movimenta
//
//  Created by Marwan  on 7/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import CoreLocation
import Foundation
import SwiftyJSON

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
  
  var isBookmarked: Bool {
    guard let id = id else {
      return false
    }
    return DataManager.shared.bookmarked(eventId: id)
  }
}

//MARK: APIs
extension Event {
  func bookmark() {
    _ = DataManager.shared.bookmark(event: self)
  }
  
  func unbookmark() {
    _ = DataManager.shared.unBookmark(event: self)
  }
}

//MARK: Parsing
extension Event: Parsable {
  static func object(from json: JSON) -> Event? {
    let id = json["id"].stringValue
    let link = json["link"].url
    let content = json["content"].string
    let title = json["title"].string
    let excerpt = json["excerpt"].string
    let subtitle = json["subtitle"].string
    let languageCode = json["language_code"].string
    let typesIds = json["types"].arrayObject as? [String]
    let categoriesIds = json["categories"].arrayObject as? [String]
    let image = json["image"].url
    let venueId = json["venue"].stringValue
    let coordinates = CLLocationCoordinate2D.object(from: json["coordinates"])
    let address = json["coordinates"]["address"].string
    let organizersIds = json["organizers"].arrayObject?.map({ "\($0)" })
    let speakersIds = json["speakers"].arrayObject?.map({ "\($0)" })
    let artistsIds = json["artists"].arrayObject?.map({ "\($0)" })
    let companiesIds = json["companies"].arrayObject?.map({ "\($0)" })
    let sponsorsIds = json["sponsors"].arrayObject?.map({ "\($0)" })
    let dates = DateRange.objects(from: json["dates"])
    
    return Event(id: id, link: link, content: content, title: title, excerpt: excerpt, subtitle: subtitle, languageCode: languageCode, typesIds: typesIds, categoriesIds: categoriesIds, image: image, venueId: venueId, coordinates: coordinates, address: address, organizersIds: organizersIds, speakersIds: speakersIds, artistsIds: artistsIds, companiesIds: companiesIds, sponsorsIds: sponsorsIds, dates: dates)
  }
}

//MARK: - Declare Event Category
extension Event {
  struct Category {
    var id: String?
    var label: String?
    var subCategories: [Category]?
  }
}

extension Event.Category: Parsable {
  static func object(from json: JSON) -> Event.Category? {
    let id = json["id"].stringValue
    let label = json["label"].stringValue
    let subCategories = objects(from: json["children"])
    return Event.Category(id: id, label: label, subCategories: subCategories)
  }
}

//MARK: - Declare Event Type
extension Event {
  struct EventType {
    var id: String?
    var label: String?
  }
}

extension Event.EventType: Parsable {
  static func object(from json: JSON) -> Event.EventType? {
    let id = json["id"].stringValue
    let label = json["label"].stringValue
    return Event.EventType(id: id, label: label)
  }
}

//MARK: - Equatable
extension Event: Equatable {}
func ==(lhs: Event, rhs: Event) -> Bool {
  guard let lhsId = lhs.id, let rhsId = rhs.id else {
    return false
  }
  return lhsId == rhsId
}
