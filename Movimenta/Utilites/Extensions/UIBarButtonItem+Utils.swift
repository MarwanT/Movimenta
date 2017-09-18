//
//  UIBarButtonItem+Utils.swift
//  Movimenta
//
//  Created by Marwan  on 9/15/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension UIBarButtonItem {
  
  /**
   A convenience var to ease the creation of the navigation bar back button
   - returns: a `UIBarButtonItem` instance with empty title
   */
  public static var back: UIBarButtonItem {
    return UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
}
