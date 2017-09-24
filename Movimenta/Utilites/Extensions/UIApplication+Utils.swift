//
//  UIApplication+Utils.swift
//  Movimenta
//
//  Created by Marwan  on 9/22/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension UIApplication {
  static func openUrl(url: URL) {
    let application: UIApplication = UIApplication.shared
    if (application.canOpenURL(url)) {
      if #available(iOS 10.0, *) {
        application.open(url)
      } else {
        // Fallback on earlier versions
        application.openURL(url)
      }
    }
  }
}
