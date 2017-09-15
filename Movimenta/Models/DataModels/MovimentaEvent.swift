//
//  MovimentaEvent.swift
//  Movimenta
//
//  Created by Marwan  on 7/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MovimentaEvent: ModelCommonProperties {
  var id: String?
  var title: String?
  var link: URL?
  var parentCategory: String?
  var categories: [String: Event.Category]?
  var types: [Event.EventType]?
  var events: [String: Event]?
  var venues: [String: Venue]?
  var organizers: [String: Participant]?
  var speakers: [String: Participant]?
  var artists: [String: Participant]?
  var companies: [String: Participant]?
  var sponsors: [String: Participant]?
  var restaurants: [Restaurant]?
  var hotels: [Hotel]?
  var partnerGroups: [PartnerGroup]?
}

extension MovimentaEvent: Parsable {
  static func object(from json: JSON) -> MovimentaEvent? {
    let id = json["id"].stringValue
    let title = json["title"].string
    let link = json["link"].url
    let parentCategory = json["parent_category"].string
    let categories = Event.Category.objectsDictionay(fromArray: json["categories"].array)
    let types = Event.EventType.objects(from: json["types"])
    let events = Event.objectsDictionay(fromArray: json["events"].array)
    let venues = Venue.objectsDictionay(fromArray: json["venues"].array)
    let organizers = Participant.objectsDictionary(fromArray: json["organizers"].array, type: .Organizer)
    let speakers = Participant.objectsDictionary(fromArray: json["speakers"].array, type: .Speaker)
    let artists = Participant.objectsDictionary(fromArray: json["artists"].array, type: .Artist)
    let companies = Participant.objectsDictionary(fromArray: json["companies"].array, type: .Company)
    let sponsors = Participant.objectsDictionary(fromArray: json["sponsors"].array, type: .Sponsor)
    let restaurants = Restaurant.objects(from: json["restaurants"])
    let hotels = Hotel.objects(from: json["hotels"])
    let partnerGroups = PartnerGroup.objects(from: json["partner_groups"])

    return MovimentaEvent(id: id, title: title, link: link, parentCategory: parentCategory, categories: categories, types: types, events: events, venues: venues, organizers: organizers, speakers: speakers, artists: artists, companies: companies, sponsors: sponsors, restaurants: restaurants, hotels: hotels, partnerGroups: partnerGroups)
  }
}
