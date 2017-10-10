//
//  Restaurant.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/15/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Restaurant: InformationModelCommonProperties {
  var id: String?
  var link: URL?
  var name: String?
  var image: String?
}

extension Restaurant: Parsable {
  static func object(from json: JSON) -> Restaurant? {
    let id = json["id"].stringValue
    let link = json["link"].url
    let name = json["name"].string?.cleanedHTMLTags()
    let image = json["image"].string

    return Restaurant(id: id, link: link, name: name, image: image)
  }
}
