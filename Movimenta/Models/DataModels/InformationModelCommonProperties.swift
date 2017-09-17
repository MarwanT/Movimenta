//
//  InformationModelCommonProperties.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

protocol InformationModelCommonProperties: Equatable {
  var id: String? { get }
  var link: URL? { get }
  var name: String? { get }
  var image: String? { get }
  var description: String? { get }
}

func ==<T: InformationModelCommonProperties>(lhs: T, rhs: T) -> Bool {
  guard let lhsId = lhs.id, let rhsId = rhs.id else {
    return false
  }
  return lhsId == rhsId
}
