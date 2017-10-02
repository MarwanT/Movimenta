//
//  Analytics+Action.swift
//  Movimenta
//
//  Created by Marwan  on 7/19/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension Analytics {
  enum Action {
    case Default
    case goToEventDetails
    case applyfilters
    case resetAllFilters
    case filterDate
    case filterEventType
    case filterStartsWithin
    case filterSpeakers
    case filterOrganizers
    case filterSponsors
    case filterCompanies
    case filterArtists
    case fitlerDistance
    case filterBookmarked
    case removeFilter
    case bookmarkEvent
    case unbookmarkEvent
    case shareEvent
    case addEventToCalendar
    case goToVenue
    case goToParticipant
    case viewVenueImageGallery
    case viewVenueMapLocation
    case viewVenueImageFullScreen
    case goToVenueMapLocation
    case shareVenue
    case shareParticipant
    case goToDate
    case getStarted
    case scanImage
    case goToKeeward
    case goToPartner
    case sendEmail
    case goToHotel
    case goToRestaurant
    
    var name: String {
      switch self {
      case .Default:
        return "[DEFAULT]"
      case .goToEventDetails:
        return "Go To Event Details"
      case .applyfilters:
        return "Apply Filters"
      case .resetAllFilters:
        return "Reset All Filters"
      case .filterDate:
        return "Filter Date"
      case .filterEventType:
        return "Filter Event Type"
      case .filterStartsWithin:
        return "Filter Starts Within"
      case .filterSpeakers:
        return "Filter Speakers"
      case .filterOrganizers:
        return "Filter Organizers"
      case .filterSponsors:
        return "Filter Sponsors"
      case .filterCompanies:
        return "Filter Companies"
      case .filterArtists:
        return "Filter Artists"
      case .fitlerDistance:
        return "Fitler Distance"
      case .filterBookmarked:
        return "Filter Bookmarked"
      case .removeFilter:
        return "Remove Filter"
      case .bookmarkEvent:
        return "Bookmark Event"
      case .unbookmarkEvent:
        return "Unbookmark Event"
      case .shareEvent:
        return "Share Event"
      case .addEventToCalendar:
        return "Add Event To Calendar"
      case .goToVenue:
        return "Go To Venue"
      case .goToParticipant:
        return "Go To Participant"
      case .viewVenueImageGallery:
        return "View Venue Image Gallery"
      case .viewVenueMapLocation:
        return "View Venue Map Location"
      case .viewVenueImageFullScreen:
        return "View Venue Image Full Screen"
      case .goToVenueMapLocation:
        return "Go To Venue Map Location "
      case .shareVenue:
        return "Share Venue"
      case .shareParticipant:
        return "Share Participant"
      case .goToDate:
        return "Go To Date"
      case .getStarted:
        return "Get Started "
      case .scanImage:
        return "Scan Image"
      case .goToKeeward:
        return "Go To Keeward"
      case .goToPartner:
        return "Go To Partner"
      case .sendEmail:
        return "Send Email"
      case .goToHotel:
        return "Go To Hotel"
      case .goToRestaurant:
        return "Go To Restaurant"
      }
    }
  }
}
