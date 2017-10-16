//
//  Partner.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/15/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Partner: InformationModelCommonProperties {
  var id: String?
  var link: URL?
  var name: String?
  var image: String?
  var description: String?
}

extension Partner: Parsable {
  static func object(from json: JSON) -> Partner? {
    let id = json["id"].stringValue
    let link = json["link"].url
    let name = json["name"].string?.cleanedHTMLTags()
    let image = json["image"].string
    let description = json["desc"].string?.cleanedHTMLTags()

    return Partner(id: id, link: link, name: name, image: image, description: description)
  }
}
