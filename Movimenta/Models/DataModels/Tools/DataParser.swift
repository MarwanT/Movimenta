//
//  DataParser.swift
//  Movimenta
//
//  Created by Marwan  on 7/22/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Parsable {
  associatedtype T
  static func objects(from json: JSON) -> [T]?
  static func object(from json: JSON) -> T?
}

extension Parsable {
  static func objects(from json: JSON) -> [T]? {
    guard let jsonArray = json.array else {
      return nil
    }
    
    var parsedObjects = [T]()
    for jsonObject in jsonArray {
      guard let generatedObject = object(from: jsonObject) else {
        continue
      }
      parsedObjects.append(generatedObject)
    }
    return parsedObjects
  }
}

struct Parser {
  static func parseMovimentaEvents(from data: Data) -> [MovimentaEvent]? {
    let json = JSON(data: data)
    return MovimentaEvent.objects(from: json)
  }
}
