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
  case imageMapping(MoyaError?)
  case jsonMapping(MoyaError?)
  case stringMapping(MoyaError?)
  case statusCode(MoyaError?)
  case underlying(MoyaError?)
  case requestMapping(MoyaError?)
  case data
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
  
  //-----------------------------------------
  /// mapping from **Target** to **Endpoint**
  private static func endpointClosure(target: MovimentaAPI) -> Endpoint<MovimentaAPI> {
    // Create Endpoint
    var endpoint: Endpoint<MovimentaAPI> = Endpoint<MovimentaAPI>(
      url: absoluteString(for: target),
      sampleResponseClosure:{ () -> EndpointSampleResponse in
        return .networkResponse(200, target.sampleData)
    },
      method: target.method,
      parameters: target.parameters,
      parameterEncoding: target.parameterEncoding,
      httpHeaderFields: nil)
    
    var headerParameters = [String : String]();
    headerParameters["User-Agent"] = userAgentValue
    
    // Add header fields to Endpoint
    if headerParameters.count > 0 {
      endpoint = endpoint.adding(newHTTPHeaderFields: headerParameters)
    }
    
    // return Endpoint
    return endpoint
  }
  
  //---------------------------------------------
  /// mapping from **Endpoint** to **URLRequest**
  private static func requestClosure(endpoint: Endpoint<MovimentaAPI>, done: MoyaProvider<MovimentaAPI>.RequestResultClosure) {
    var request = endpoint.urlRequest!
    request.httpShouldHandleCookies = false
    done(.success(request))
  }
  
  private struct SharedProvider {
    static var instance = SharedProvider.shouldStubResponses ? APIProvider.StubbedProvider() : APIProvider.DefaultProvider()
    
    private static var shouldStubResponses: Bool {
      let env = ProcessInfo.processInfo.environment
      if let mode = env["STUB_RESPONSES"]?.lowercased() {
        return (mode == "yes")||(mode == "true")
      }
      return false
    }
  }
  
  private static func DefaultProvider() -> MoyaProvider<MovimentaAPI> {
    return MoyaProvider<MovimentaAPI>(
      endpointClosure: endpointClosure,
      requestClosure: requestClosure,
      stubClosure:{ (target: MovimentaAPI) -> Moya.StubBehavior in
        return .never
    }
    )
  }
  
  private static func StubbedProvider() -> MoyaProvider<MovimentaAPI> {
    return MoyaProvider<MovimentaAPI>(
      endpointClosure: endpointClosure,
      requestClosure:requestClosure,
      stubClosure: { (target: MovimentaAPI) -> StubBehavior in
        return StubBehavior.delayed(seconds: 3)
    }
    )
  }
  
  
  public static var sharedProvider: MoyaProvider<MovimentaAPI> {
    get {
      return SharedProvider.instance
    }
    
    set (newSharedProvider) {
      SharedProvider.instance = newSharedProvider
    }
  }
}

extension APIProvider {
  static var userAgentValue: String {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    let currentDevice = UIDevice.current
    let deviceType = currentDevice.deviceType
    return "Movimenta/\(version)+\(buildNumber) (iOS/\(currentDevice.systemVersion); \(deviceType.displayName);)"
  }
}

public func absoluteString(for target: TargetType) -> String {
  guard !target.path.isEmpty else {
    return target.baseURL.absoluteString
  }
  return  target.baseURL.appendingPathComponent(target.path).absoluteString
}

public func apiRequest(target: MovimentaAPI, completion: @escaping APICompletion) -> Cancellable {
  showActivityIndicator()
  return APIProvider.sharedProvider.request(target, completion: { (result) in
    hideActivityIndicator()
    switch result {
    case .success(let response):
      completion(response.data, response.statusCode, response.response, nil)
    case .failure(let error):
      completion(nil, nil, nil, APIError(moyaError: error))
    }
  })
}

// MARK: - Activity Indicator
func showActivityIndicator() {
  DispatchQueue.main.async {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }
}

func hideActivityIndicator() {
  DispatchQueue.main.async {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}

