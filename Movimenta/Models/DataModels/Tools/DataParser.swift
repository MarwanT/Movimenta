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
  static var jsonKeyForIdAttribute: String { get }
  static func objects(from json: JSON) -> [T]?
  static func object(from json: JSON) -> T?
  static func objectsDictionay(fromArray json: [JSON]?) -> [String : T]?
  static func objectElement(from json: JSON) -> (key: String, value: T)?
}

extension Parsable {
  static var jsonKeyForIdAttribute: String {
    return "id"
  }
  
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
  
  static func objectsDictionay(fromArray json: [JSON]?) -> [String : T]? {
    guard let jsonArray = json else {
      return nil
    }
    
    var parsedObjects = [String: T]()
    for jsonObject in jsonArray {
      guard let generatedObject = objectElement(from: jsonObject) else {
        continue
      }
      parsedObjects[generatedObject.key] = generatedObject.value
    }
    return parsedObjects
  }
  
  static func objectElement(from json: JSON) -> (key: String, value: T)? {
    let id = json[jsonKeyForIdAttribute].stringValue
    guard let event = object(from: json), !id.isEmpty else {
      return nil
    }
    return (id, event)
  }
}

struct Parser {
  static func parseMovimentaEvents(from data: Data) -> [MovimentaEvent]? {
    let json = JSON(data: data)
    return MovimentaEvent.objects(from: json)
  }
}


//MARK: URL
extension URL: Parsable {
  static func object(from json: JSON) -> URL? {
    return json.url
  }
}
