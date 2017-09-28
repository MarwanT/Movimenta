//
//  Analytics+ScreenName.swift
//  Movimenta
//
//  Created by Marwan  on 7/19/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension Analytics {
  struct ScreenName {
    let name: String
    fileprivate init(name: String) {
      self.name = name
    }
  }
  
  struct ScreenNames {
    private init() {}
    static let Default = ScreenName(name: "[DEFAULT]")
    static let EventsMap = ScreenName(name: "Events Map")
    static let Filters = ScreenName(name: "Filters")
    static let Bookmarks = ScreenName(name: "Bookmarks")
    static let EventDetails = ScreenName(name: "Event Details")
    static let Venue = ScreenName(name: "Venue")
    static let Speaker = ScreenName(name: "Speaker")
    static let Organizer = ScreenName(name: "Organizer")
    static let Sponsor = ScreenName(name: "Sponsor")
    static let Company = ScreenName(name: "Company")
    static let Artist = ScreenName(name: "Artist")
    static let Schedule = ScreenName(name: "Schedule")
    static let Info = ScreenName(name: "Info")
    static let About = ScreenName(name: "About")
    static let Partners = ScreenName(name: "Partners")
    static let Contact = ScreenName(name: "Contact")
    static let Hotels = ScreenName(name: "Hotels")
    static let Restaurants = ScreenName(name: "Restaurants")
    static let AugmentedReality = ScreenName(name: "Augmented Reality")
  }
}
