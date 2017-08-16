//
//  UIAlertAction+Util.swift
//  Movimenta
//
//  Created by Marwan  on 8/16/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension UIAlertAction {
  class func cancelAction(handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
    let action = UIAlertAction(title: Strings.cancel(), style: .cancel, handler: handler)
    return action
  }
  
  class func okAction(handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
    let action = UIAlertAction(title: Strings.ok(), style: .default, handler: handler)
    return action
  }
  
  class func settingsAction() -> UIAlertAction {
    let action = UIAlertAction(title: Strings.settings(), style: .default) { (alertAction) in
      guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
        return
      }
      
      if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, completionHandler: nil)
      }
    }
    return action
  }
}
