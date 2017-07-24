//
//  DataParser.swift
//  Movimenta
//
//  Created by Marwan  on 7/22/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

protocol Parsable {
  associatedtype T
  static func objects(from json: JSON) -> [T]?
  static func object(from json: JSON) -> T?
}
