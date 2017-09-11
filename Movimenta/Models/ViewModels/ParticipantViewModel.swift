//
//  ParticipantViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 9/11/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

final class ParticipantViewModel {
  fileprivate(set) var participant: Participant!
  
  func initialize(with participant: Participant) {
    self.participant = participant
  }
  
  var image: URL? {
    return participant.image
  }
  
  var name: String? {
    return participant.fullName
  }
  
  var roles: String? {
    return participant.profession
  }
  
  var description: String? {
    return participant.content
  }
}
