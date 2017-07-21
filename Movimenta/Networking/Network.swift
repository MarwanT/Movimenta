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

public typealias APICompletion = (_ data: Data?,_ statusCode: Int?,_ response: URLResponse?,_ error: APIError?) -> ()


/**
 An endpoint is a semi-internal data structure that Moya uses to reason about the network request that will ultimately be made. An endpoint stores the following data:
 * The url.
 * The HTTP method (GET, POST, etc).
 * The request parameters.
 * The parameter encoding (URL, JSON, custom, etc).
 * The HTTP request header fields.
 * The sample response (for unit testing).
 
 
 *Providers map Targets to Endpoints, then map Endpoints to actual network requests.*
 
 **There are two ways that you interact with Endpoints:**
 * When creating a provider, you may specify a mapping from **Target** to **Endpoint**.
 * When creating a provider, you may specify a mapping from **Endpoint** to **URLRequest**.
 */


public struct APIProvider {
}
