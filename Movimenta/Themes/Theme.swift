//
//  Theme.swift
//  Movimenta
//
//  Created by Marwan  on 7/27/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

protocol Theme: ThemeColors, ThemeSpacing {
  func initialize()
}

protocol ThemeColors {
  var color1: UIColor { get }
  var color2: UIColor { get }
  var color3: UIColor { get }
  var color4: UIColor { get }
  var color5: UIColor { get }
  var color6: UIColor { get }
}

protocol ThemeSpacing {
  var space1: Float { get }
  var space2: Float { get }
  var space3: Float { get }
  var space4: Float { get }
  var space5: Float { get }
  var space6: Float { get }
}
