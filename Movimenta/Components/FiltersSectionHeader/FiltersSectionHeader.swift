//
//  FiltersSectionHeader.swift
//  Movimenta
//
//  Created by Marwan  on 8/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import SnapKit
import UIKit

class FiltersSectionHeader: UITableViewHeaderFooterView {
  static let identifier: String = FiltersSectionHeader.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
  
  var configuration = Configuration()
}

extension FiltersSectionHeader {
  struct Configuration {
    var contentViewMargins = UIEdgeInsetsMake(
      CGFloat(ThemeManager.shared.current.space1),
      CGFloat(ThemeManager.shared.current.space7),
      CGFloat(ThemeManager.shared.current.space1),
      CGFloat(ThemeManager.shared.current.space7))
  }
}
