//
//  PadableLabel.swift
//  Movimenta
//
//  Created by Marwan  on 9/7/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

class PadableLabel: UILabel {
  var padding = UIEdgeInsets.zero {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override func drawText(in rect: CGRect) {
    super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
  }
  
  override var intrinsicContentSize: CGSize {
    var size = super.intrinsicContentSize
    size.width += padding.right + padding.left
    return size
  }
}
