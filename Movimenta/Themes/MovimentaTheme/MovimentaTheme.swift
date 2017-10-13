//
//  MovimentaTheme.swift
//  Movimenta
//
//  Created by Marwan  on 7/27/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

final class MovimentaTheme: Theme {
  func initialize() {
    let appearance = UINavigationBar.appearance()
    appearance.barTintColor = color2
    appearance.tintColor = lightTextColor
    appearance.isTranslucent = false
    appearance.titleTextAttributes = [
      NSFontAttributeName: font7,
      NSForegroundColorAttributeName : lightTextColor
    ]
    
    let tabBarAppearance = UITabBar.appearance()
    tabBarAppearance.isTranslucent = false
    tabBarAppearance.barTintColor = tabBarTintColor
    tabBarAppearance.tintColor =  tabTintColor
    if #available(iOS 10.0, *) {
      tabBarAppearance.unselectedItemTintColor = tabUnselectedItemTintColor
    }
    let tabBarItemAppearance = UITabBarItem.appearance()
    tabBarItemAppearance.setTitleTextAttributes(
      [NSFontAttributeName : fontTab], for: .normal)
    
    let segmentedControlAppearance = UISegmentedControl.appearance()
    segmentedControlAppearance.setTitleTextAttributes(
      [NSFontAttributeName : font14], for: .normal)
    
    let pageControlAppearance = UIPageControl.appearance()
    pageControlAppearance.currentPageIndicatorTintColor = white
    pageControlAppearance.pageIndicatorTintColor = color6
  }
  
  var animationDuration: TimeInterval = 0.4
  
  //MARK: - Colors
  //===============
  
  /// #000000
  var color1: UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
  /// #0000ff
  var color2: UIColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)
  /// #8989ff
  var color3: UIColor = UIColor(red: 137/255, green: 137/255, blue: 255/255, alpha: 1)
  /// #f2f2ff
  var color4: UIColor = UIColor(red: 242/255, green: 242/255, blue: 255/255, alpha: 1)
  /// #737373
  var color5: UIColor = UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1)
  /// #c0c0c2
  var color6: UIColor = UIColor(red: 192/255, green: 192/255, blue: 194/255, alpha: 1)
  /// #ffffff
  var white: UIColor = UIColor.white
  
  
  var darkTextColor: UIColor {
    return color1
  }
  var lightTextColor: UIColor {
    return white
  }
  var disableColor: UIColor {
    return color6
  }
  var defaultBackgroundColor: UIColor {
    return white
  }
  var separatorColor: UIColor {
    return color6
  }
  var tabBarTintColor: UIColor {
    return white
  }
  var tabTintColor: UIColor {
    return lightTextColor
  }
  var tabSelectionColor: UIColor {
    return color2
  }
  var tabUnselectedItemTintColor: UIColor {
    return color2
  }
  
  //MARK: - Spacings
  //=================
  
  var space1: Float = 12
  var space2: Float = 15
  var space3: Float = 22
  var space4: Float = 26
  var space5: Float = 30
  var space6: Float = 48
  var space7: Float = 20
  var space8: Float = 10
  
  
  // MARK: - Fonts
  //===============
  
  var font1: UIFont = FontBook.title1.font
  var font2: UIFont = FontBook.title2.font
  var font3: UIFont = FontBook.title3.font
  var font4: UIFont = FontBook.title4.font
  var font5: UIFont = FontBook.title5.font
  var font6: UIFont = FontBook.body1.font
  var font7: UIFont = FontBook.header1.font
  var font8: UIFont = FontBook.listTitle.font
  var font9: UIFont = FontBook.listBody.font
  var font10: UIFont = FontBook.action1.font
  var font11: UIFont = FontBook.action2.font
  var font12: UIFont = FontBook.label1.font
  var font13: UIFont = FontBook.label2.font
  var font14: UIFont = FontBook.label3.font
  var font15: UIFont = FontBook.filter.font
  var font16: UIFont = FontBook.menu1.font
  var font17: UIFont = FontBook.menu2.font
  var fontTab: UIFont = FontBook.tabLabel.font
  var fontTabSelected: UIFont = FontBook.tabLabelSelected.font

  // MARK: - Buttons
  //===============

  func stylePrimaryButton(button: UIButton) {
    button.titleLabel?.font = font5
    button.setTitleColor(lightTextColor, for: .normal)
    button.setBackgroundImage(color2.image(), for: .normal)
    button.setTitleColor(color2, for: .highlighted)
    button.setBackgroundImage(lightTextColor.image(), for: .highlighted)
    button.backgroundColor = color2
    addButtonBorders(button: button)
    addButtonConstraints(button: button)
  }

  func styleSecondaryButton(button: UIButton) {
    button.titleLabel?.font = font5
    button.setTitleColor(color2, for: .normal)
    button.setBackgroundImage(lightTextColor.image(), for: .normal)
    button.setTitleColor(lightTextColor, for: .highlighted)
    button.setBackgroundImage(color2.image(), for: .highlighted)
    button.backgroundColor = lightTextColor
    addButtonBorders(button: button)
    addButtonConstraints(button: button)
  }

  private func addButtonBorders(button: UIButton, radius: CGFloat = 2.0, width: CGFloat = 2.0, color: UIColor? = nil) {
    let borderColor = color ?? color2
    button.clipsToBounds = true
    button.layer.cornerRadius = radius
    button.layer.borderWidth = width
    button.layer.borderColor = borderColor.cgColor
  }

  private func addButtonConstraints(button: UIButton) {
    let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 44)
    button.addConstraint(heightConstraint)

    let lowerWidthConstraint = NSLayoutConstraint(item:button, attribute:.width,
        relatedBy:.greaterThanOrEqual, toItem:nil, attribute:.width, multiplier:0,
        constant:125)
    button.addConstraint(lowerWidthConstraint)
  }
}
