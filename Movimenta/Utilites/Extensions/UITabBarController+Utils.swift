//
//  UITabBarController+Utils.swift
//  Movimenta
//
//  Created by Marwan  on 9/20/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension UITabBarController {
  func setTabBarVisible(visible: Bool, animated: Bool, completion: (() -> Void)?) {
    guard isTabBarVisible != visible else {
      return
    }
    
    let frame = tabBar.frame
    let height = frame.size.height
    let offsetY = (visible ? -height : height)
    let duration: TimeInterval = (animated ? 0.4 : 0.0)
    
    UIView.animate(withDuration: duration, animations: {
      [weak self] () -> Void in
      guard let weakSelf = self else { return }
      weakSelf.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY)
      weakSelf.view.frame = CGRect(x: 0, y: 0, width: weakSelf.view.frame.width, height: weakSelf.view.frame.height + offsetY)
      weakSelf.view.setNeedsDisplay()
      weakSelf.view.layoutIfNeeded()
    }) { (finished) in
      completion?()
    }
  }
  
  var isTabBarVisible: Bool {
    return tabBar.frame.origin.y < UIScreen.main.bounds.height
  }
}
