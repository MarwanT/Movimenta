//
//  Localization.swift
//  Movimenta
//
//  Created by Marwan  on 7/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

final class Localization {
  enum Language: String {
    case English = "en"
    case French = "fr"
    
    static let defaultLanguage = Language.French
    
    static func all() -> [Language] {
      return [.English, .French]
    }
  }
  
  class func localize(key: String, defaultValue: String = "", comment: String = "", formatVariables: CVarArg...) -> String {
    if formatVariables.count > 0 {
      let localized: String = NSLocalizedString(key, value: defaultValue, comment: comment)
      return withVaList(formatVariables, {
        return NSString(format: localized, locale: Locale.application , arguments: $0) as String
      })
    }
    return NSLocalizedString(key, value: defaultValue, comment: comment)
  }
}

//MARK: Application language
extension Localization {
  //Sets the Application Language
  static func set(language: Language?) {
    let newLanguage = language ?? Language.defaultLanguage
    Bundle.setLanguage(newLanguage.rawValue)
  }
}

//MARK: - Application Locale
extension Locale {
  /*
   Returns the current device locale if supported, otherwise falls back
   To the default language locale.
   */
  static var application: Locale {
    return Locale(identifier: applicationLanguage.rawValue)
  }
  
  static var applicationLanguage: Localization.Language {
    let supportedLanguagesIds = Localization.Language.all().map({ $0.rawValue })
    guard let languageIndex = supportedLanguagesIds.index(of: Locale.current.identifier),
      let language = Localization.Language(rawValue: supportedLanguagesIds[languageIndex]) else {
      return Localization.Language.defaultLanguage
    }
    return language
  }
}
