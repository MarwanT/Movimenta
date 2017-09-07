//
//  FiltersBreadcrumbView.swift
//  Movimenta
//
//  Created by Marwan  on 9/6/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class FiltersBreadcrumbView: UIView {
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var stackView: UIStackView!
  
}

//MARK: Configuration
extension FiltersBreadcrumbView {
  struct Configuration {
    var backgroundColor: UIColor = ThemeManager.shared.current.color2
    var foregroundColor: UIColor = ThemeManager.shared.current.lightTextColor
    var layoutMargin: UIEdgeInsets = UIEdgeInsets(
      top: 0, left: CGFloat(ThemeManager.shared.current.space7),
      bottom: 0, right: CGFloat(ThemeManager.shared.current.space7))
  }
}
