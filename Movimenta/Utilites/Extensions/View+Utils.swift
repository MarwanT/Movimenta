//
//  View+Utils.swift
//  Movimenta
//
//  Created by Marwan  on 8/7/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension UIView {
  public static var defaultNibName: String {
    return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
  }
}
