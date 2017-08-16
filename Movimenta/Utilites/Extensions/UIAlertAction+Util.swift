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
}
