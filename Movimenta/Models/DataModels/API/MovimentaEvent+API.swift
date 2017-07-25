//
//  MovimentaEvent+API.swift
//  Movimenta
//
//  Created by Marwan  on 7/25/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import Moya

struct MovimentaEventAPI {
  static func fetchMovimentaEventsDetails(completion: @escaping (_ success: Bool, _ data: Data?, _ movimentaEvents: [MovimentaEvent]?, _ error: APIError?) -> Void) -> Cancellable? {
    let successfulStatusCode = 200
    return apiRequest(target: .events) {
      (data, statusCode, response, apiError) in
      var success: Bool = false
      var error: APIError? = apiError
      var eventsData: Data? = data
      var movimentaEvents: [MovimentaEvent]? = nil
      defer {
        completion(success, eventsData, movimentaEvents, error)
      }
      
      guard statusCode == successfulStatusCode else {
        if error == nil {
          error = APIError.statusCode(nil)
        }
        return
      }
      
      guard let data = data else {
        if error == nil {
          error = APIError.data
        }
        return
      }
      
      success = true
      movimentaEvents = Parser.parseMovimentaEvents(from: data)
      error = nil
    }
  }
}
