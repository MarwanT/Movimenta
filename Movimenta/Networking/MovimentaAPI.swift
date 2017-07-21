//
//  MovimentaAPI.swift
//  Movimenta
//
//  Created by Marwan  on 7/20/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import Moya

public enum MovimentaAPI {
  case events
}

extension MovimentaAPI: TargetType {
  public var baseURL: URL {
    switch self {
    default:
      return Environment.current.apiBaseURL
    }
  }
  
  public var path: String {
    let languagePath = apiLanguagePath
    let apiBasePath = "/wp-json/wp/v2"
    var path = ""
    
    switch self {
    case .events:
      path = "/biennale"
    }
    
    return languagePath + apiBasePath + path
  }
  
  public var method: Moya.Method {
    switch self {
    case .events:
      return .get
    }
  }
  
  public var parameters: [String: Any]? {
    return nil
  }
  
  public var parameterEncoding: ParameterEncoding {
    switch self.method {
    case .get:
      return URLEncoding.default
    default:
      return JSONEncoding.default
    }
  }
  
  public var sampleData: Data {
    return stubbedResponse(target: self)
  }
  
  public var task: Task {
    switch self {
    default:
      return .request
    }
  }
  
  /// Whether or not to perform Alamofire validation. Defaults to `false`.
  public var validate: Bool {
    return false
  }
}

//MARK: - Helpers
extension MovimentaAPI {
  var apiLanguagePath: String {
    let applicationLanguage = Locale.applicationLanguage
    switch applicationLanguage {
    case .French:
      return ""
    case .English:
      return "/\(applicationLanguage.rawValue)"
    }
  }
  
  func stubbedResponse(target: MovimentaAPI) -> Data! {
    var filename: String = ""
    
    switch target {
    default:
      filename = ""
    }
    
    let bundle = Bundle.main
    let path = "\(bundle.resourcePath!)/\(filename).json"
    return (try? Data(contentsOf: URL(fileURLWithPath: path)))
  }
}
