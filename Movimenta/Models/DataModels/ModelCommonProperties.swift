//
//  ModelCommonProperties.swift
//  Movimenta
//
//  Created by Marwan  on 7/21/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

protocol ModelCommonProperties {
  var id: String? { get }
  var link: URL? { get }
  var title: String? { get }
  var content: String? { get }
  var excerpt: String? { get }
}

extension MovimentaEvent {
  var content: String? { return nil }
  var excerpt: String? { return nil }
}
