//
//  PartnerGroup.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/15/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PartnerGroup {
  var id: String?
  var title: String?
  var partners: [Partner]?
}

extension PartnerGroup: Parsable {
  static func object(from json: JSON) -> PartnerGroup? {
    let id = json["id"].stringValue
    let title = json["title"].string
    let partners = Partner.objects(from: json["partners"])


    return PartnerGroup(id: id, title: title, partners: partners)
  }
}
