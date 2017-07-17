//
//  Localization.swift
//  Movimenta
//
//  Created by Marwan  on 7/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

final class Localization {
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

//MARK: - Application Locale
extension Locale {
  static var application: Locale {
    return Locale.current
  }
}
