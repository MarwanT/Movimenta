//
//  InformationModelCommonProperties.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

typealias Type = InformationModelCommonProperties

protocol InformationModelCommonProperties {
  var id: String? { get }
  var link: URL? { get }
  var name: String? { get }
  var image: String? { get }
  var description: String? { get }
}

func equals<T: InformationModelCommonProperties>(lhs: T, rhs: T) -> Bool {
  guard let lhsId = lhs.id, let rhsId = rhs.id else {
    return false
  }
  return lhsId == rhsId
}

extension Hotel {
  var description: String? { return nil }
}

extension Restaurant {
  var description: String? { return nil }
}
