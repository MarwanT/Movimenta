//
//  ViewController+Utilities.swift
//  Movimenta
//
//  Created by Marwan  on 7/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

extension UIViewController {
  public static var defaultNib: String {
    return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
  }
  
  public static var storyboardIdentifier: String {
    return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
  }
}
