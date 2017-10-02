//
//  Theme.swift
//  Movimenta
//
//  Created by Marwan  on 7/27/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

protocol Theme: ThemeColors, ThemeSpacing, ThemeFont, ThemeButtonsSytle {
  func initialize()
  
  var animationDuration: TimeInterval { get }
}

protocol ThemeColors {
  var color1: UIColor { get }
  var color2: UIColor { get }
  var color3: UIColor { get }
  var color4: UIColor { get }
  var color5: UIColor { get }
  var color6: UIColor { get }
  
  var white: UIColor { get }
  var darkTextColor: UIColor { get }
  var lightTextColor: UIColor { get }
  var disableColor: UIColor { get }
  var defaultBackgroundColor: UIColor { get }
  var separatorColor: UIColor { get }
  var tabBarTintColor: UIColor { get }
  var tabTintColor: UIColor { get }
  var tabSelectionColor: UIColor { get }
  var tabUnselectedItemTintColor: UIColor { get }
}

protocol ThemeSpacing {
  var space1: Float { get }
  var space2: Float { get }
  var space3: Float { get }
  var space4: Float { get }
  var space5: Float { get }
  var space6: Float { get }
  var space7: Float { get }
  var space8: Float { get }
}

protocol ThemeFont {
  var font1: UIFont { get }
  var font2: UIFont { get }
  var font3: UIFont { get }
  var font4: UIFont { get }
  var font5: UIFont { get }
  var font6: UIFont { get }
  var font7: UIFont { get }
  var font8: UIFont { get }
  var font9: UIFont { get }
  var font10: UIFont { get }
  var font11: UIFont { get }
  var font12: UIFont { get }
  var font13: UIFont { get }
  var font14: UIFont { get }
  var font15: UIFont { get }
  var font16: UIFont { get }
  var font17: UIFont { get }
}

protocol ThemeButtonsSytle {
  func stylePrimaryButton(button: UIButton)
  func styleSecondaryButton(button: UIButton)
}
