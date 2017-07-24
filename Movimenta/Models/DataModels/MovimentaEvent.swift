//
//  MovimentaEvent.swift
//  Movimenta
//
//  Created by Marwan  on 7/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

struct MovimentaEvent: ModelCommonProperties {
  var id: String?
  var title: String?
  var link: URL?
  var parentCategory: String?
  var categories: [Event.Category]?
  var types: [Event.EventType]?
  var events: [Event]?
  var venues: [Venue]?
  var organizers: [Participant]?
  var speakers: [Participant]?
  var artists: [Participant]?
  var companies: [Participant]?
  var sponsors: [Participant]?
}
