//
//  ScheduleCell.swift
//  Movimenta
//
//  Created by Marwan  on 9/13/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class ScheduleCell: UICollectionViewCell {
  var label: UILabel!
  
  var configuration = Configuration() 
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  private func initialize() {
  }
}

//MARK: Configuration
extension ScheduleCell {
  struct Configuration {
    var layoutMargins = UIEdgeInsets(
      top: CGFloat(ThemeManager.shared.current.space8),
      left: CGFloat(ThemeManager.shared.current.space8),
      bottom: CGFloat(ThemeManager.shared.current.space8),
      right: CGFloat(ThemeManager.shared.current.space8))
    var font = ThemeManager.shared.current.font7
    var highlightColor = ThemeManager.shared.current.white
    var defaultColor = ThemeManager.shared.current.color2
    var sideMarginsValue: CGFloat {
      return layoutMargins.left + layoutMargins.right
    }
  }
}
