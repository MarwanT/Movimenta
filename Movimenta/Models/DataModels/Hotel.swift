//
//  Hotel.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/15/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Hotel {
  var id: String?
  var link: URL?
  var name: String?
  var image: String?
}

extension Hotel: Parsable {
  static func object(from json: JSON) -> Hotel? {
    let id = json["id"].stringValue
    let link = json["link"].url
    let name = json["name"].string
    let image = json["image"].string

    return Hotel(id: id, link: link, name: name, image: image)
  }
}
