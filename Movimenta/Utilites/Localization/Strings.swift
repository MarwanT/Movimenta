//
//  Strings.swift
//  Movimenta
//
//  Created by Marwan  on 7/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

final class Strings {
  static func bookmarks() -> String {
    return Localization.localize(key: "bookmarks")
  }
  
  static func event_map() -> String {
    return Localization.localize(key: "event_map")
  }
  
  static func info() -> String {
    return Localization.localize(key: "info")
  }
  
  static func scheduale() -> String {
    return Localization.localize(key: "scheduale")
  }
  
  static func view_more() -> String {
    return Localization.localize(key: "view_more")
  }
  
  static func vr() -> String {
    return Localization.localize(key: "vr")
  }
}
