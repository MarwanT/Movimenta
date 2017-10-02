//
//  Breadcrumb.swift
//  Movimenta
//
//  Created by Marwan  on 9/28/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

//MARK: Breadcrumbs related
enum Breadcrumb {
  case dateRange(DateRange)
  case category(Event.Category)
  case withinTime(Int)
  case withinDistance(Double)
  case speaker(Participant)
  case sponsor(Participant)
  case company(Participant)
  case artist(Participant)
  case organizer(Participant)
  case showBookmarked(Bool)
  
  var text: String {
    switch self {
    case .dateRange(let dateRange):
      guard let from = dateRange.from, let to = dateRange.to else {
        return "-"
      }
      if from.same(date: to) {
        return "\(from.formattedDate())"
      } else {
        return "\(from.formattedDate()) - \(to.formattedDate())"
      }
    case .category(let category):
      return category.label ?? ""
    case .artist(let participant):
      return participant.fullName
    case .company(let participant):
      return participant.fullName
    case .organizer(let participant):
      return participant.fullName
    case .speaker(let participant):
      return participant.fullName
    case .sponsor(let participant):
      return participant.fullName
    case .withinTime(let time):
      let unit = FiltersManager.shared.withinTimeValues.unit
      return "\(time) \(unit)"
    case .withinDistance(let distance):
      let unit = FiltersManager.shared.withinDistanceValues.unit
      return "\(Int(distance)) \(unit)"
    case .showBookmarked(let showBookmarked):
      return showBookmarked ? Strings.show_bookmarked_events() :
        Strings.hide_bookmarked_events()
    }
  }
}

extension Breadcrumb: Equatable {}
func ==(lhs: Breadcrumb, rhs: Breadcrumb) -> Bool {
  switch (lhs, rhs) {
  case (.dateRange(_), .dateRange(_)):
    //TODO: Compare the dates
    return true
  case (.category(let lCategory), .category(let rCategory)):
    return lCategory == rCategory
  case (.withinTime(let lTime), .withinTime(let rTime)):
    return lTime == rTime
  case (.withinDistance(let lDistance), .withinDistance(let rDistance)):
    return lDistance == rDistance
  case (.speaker(let lParticipant), .speaker(let rParticipant)):
    return lParticipant == rParticipant
  case (.sponsor(let lParticipant), .sponsor(let rParticipant)):
    return lParticipant == rParticipant
  case (.company(let lParticipant), .company(let rParticipant)):
    return lParticipant == rParticipant
  case (.organizer(let lParticipant), .organizer(let rParticipant)):
    return lParticipant == rParticipant
  case (.artist(let lParticipant), .artist(let rParticipant)):
    return lParticipant == rParticipant
  case (.showBookmarked(let lBool), .showBookmarked(let rBool)):
    return lBool == rBool
  default:
    return false
  }
}
