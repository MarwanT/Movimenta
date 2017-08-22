//
//  Filter.swift
//  Movimenta
//
//  Created by Marwan  on 8/22/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

struct Filter {
  var dateRange: DateRange? = nil
  var categories: [Event.Category]? = nil
  var withinTime: Int? = nil
  var speakers: [Participant]? = nil
  var sponsers: [Participant]? = nil
  var companies: [Participant]? = nil
  var artists: [Participant]? = nil
  var organizers: [Participant]? = nil
  var withinDistance: Double? = nil
  var showBookmarked: Bool? = nil
}
