//
//  ModelCommonProperties.swift
//  Movimenta
//
//  Created by Marwan  on 7/21/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

protocol ModelCommonProperties: Equatable {
  var id: String? { get }
  var link: URL? { get }
  var title: String? { get }
  var content: String? { get }
  var excerpt: String? { get }
}

func ==<T: ModelCommonProperties>(lhs: T, rhs: T) -> Bool {
  guard let lhsId = lhs.id, let rhsId = rhs.id else {
    return false
  }
  return lhsId == rhsId
}

extension MovimentaEvent {
  var content: String? { return nil }
  var excerpt: String? { return nil }
}

extension Hotel {
  var content: String? { return nil }
  var excerpt: String? { return nil }
  var title: String? { return nil }
}
