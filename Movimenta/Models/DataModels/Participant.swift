//
//  Participant.swift
//  Movimenta
//
//  Created by Marwan  on 7/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

struct Participant: ModelCommonProperties {
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
