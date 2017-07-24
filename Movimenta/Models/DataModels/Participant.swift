//
//  Participant.swift
//  Movimenta
//
//  Created by Marwan  on 7/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

struct Participant: ModelCommonProperties {
  var id: String?
  var type: ParticipantType
  var link: URL?
  var content: String?
  var title: String?
  var excerpt: String?
  var name: String?
  var firstName: String?
  var lastName: String?
  var profession: String?
  var image: URL?
  var website: URL?
  var phone: String?
  var email: String?
  var facebook: URL?
  var twitter: URL?
  var linkedin: URL?
  var googleplus: URL?
  var youtube: URL?
  var tumblr: URL?
  var vimeo: URL?
  var instagram: URL?
}

extension Participant {
  enum ParticipantType: String {
    case Organizer = "organizers"
    case Speaker = "speakers"
    case Artist = "artists"
    case Company = "companies"
    case Sponsor = "sponsors"
    case Default = "default"
  } 
}
