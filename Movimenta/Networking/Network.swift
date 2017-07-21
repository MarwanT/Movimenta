//
//  Network.swift
//  Movimenta
//
//  Created by Marwan  on 7/20/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import Moya

public enum APIError: Swift.Error {
  case imageMapping(MoyaError)
  case jsonMapping(MoyaError)
  case stringMapping(MoyaError)
  case statusCode(MoyaError)
  case underlying(MoyaError)
  case requestMapping(MoyaError)
  case unidentified
  
  init(moyaError: MoyaError) {
    switch moyaError {
    case .imageMapping:
      self = .imageMapping(moyaError)
    case .jsonMapping:
      self = .jsonMapping(moyaError)
    case .requestMapping:
      self = .requestMapping(moyaError)
    case .statusCode:
      self = .statusCode(moyaError)
    case .stringMapping:
      self = .stringMapping(moyaError)
    case .underlying:
      self = .underlying(moyaError)
    }
  }
}
