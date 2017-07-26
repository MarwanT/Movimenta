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
  var categories: [Event.Category]?
  var types: [Event.EventType]?
  var events: [String: Event]?
  var venues: [String: Venue]?
  var organizers: [Participant]?
  var speakers: [Participant]?
  var artists: [Participant]?
  var companies: [Participant]?
  var sponsors: [Participant]?
}

extension MovimentaEvent: Parsable {
  static func object(from json: JSON) -> MovimentaEvent? {
    let id = json["id"].stringValue
    let title = json["title"].string
    let link = json["link"].url
    let parentCategory = json["parent_category"].string
    let categories = Event.Category.objects(from: json["categories"])
    let types = Event.EventType.objects(from: json["types"])
    let events = Event.objectsDictionay(fromArray: json["events"].array)
    let venues = Venue.objectsDictionay(fromArray: json["venues"].array)
    let organizers = Participant.objects(
      from: json["organizers"], type: Participant.ParticipantType.Organizer)
    let speakers = Participant.objects(
      from: json["speakers"], type: Participant.ParticipantType.Speaker)
    let artists = Participant.objects(
      from: json["artists"], type: Participant.ParticipantType.Artist)
    let companies = Participant.objects(
      from: json["companies"], type: Participant.ParticipantType.Company)
    let sponsors = Participant.objects(
      from: json["sponsors"], type: Participant.ParticipantType.Sponsor)
    
    return MovimentaEvent(id: id, title: title, link: link, parentCategory: parentCategory, categories: categories, types: types, events: events, venues: venues, organizers: organizers, speakers: speakers, artists: artists, companies: companies, sponsors: sponsors)
  }
}
