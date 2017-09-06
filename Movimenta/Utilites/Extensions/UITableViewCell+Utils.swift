//
//  UITableViewCell+Utils.swift
//  Movimenta
//
//  Created by Marwan  on 8/30/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension UITableViewCell {
  func hideSeparator() {
    separatorInset = UIEdgeInsets(
      top: 0, left: 10000, bottom: 0, right: 0)
  }
  
  func showSeparator() {
    separatorInset = UIEdgeInsets.zero
  }
}
