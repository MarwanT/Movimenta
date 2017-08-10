//
//  NSLayoutConstraint+Utils.swift
//  Movimenta
//
//  Created by Marwan  on 8/10/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension NSLayoutConstraint {
  func isTopConstraint(for item: AnyObject) -> Bool {
    if item === self.firstItem {
      return isTopConstraintForFirstItem
    } else if item === self.secondItem {
      return isTopConstraintForSecondItem
    } else {
      return false
    }
  }
  
  private var isTopConstraintForFirstItem: Bool {
    return self.firstAttribute == .top
  }
  
  private var isTopConstraintForSecondItem: Bool {
    return self.secondAttribute == .top
  }
}

extension Array where Element == NSLayoutConstraint {
  func topConstraints(item: AnyObject) -> [NSLayoutConstraint] {
    var constraints = [NSLayoutConstraint]()
    self.forEach { (constraint) in
      if constraint.isTopConstraint(for: item) {
        constraints.append(constraint)
      }
    }
    return constraints
  }
}
