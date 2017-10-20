//
//  FontBook+Utils.swift
//  Movimenta
//
//  Created by Marwan  on 10/19/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension UILabel {
  /// Sets the text and font of the label
  func paragraph(with text: String?, lineHeight: CGFloat? = nil, alignement: NSTextAlignment? = nil) {
    guard var text = text else {
      self.text = nil
      return
    }
  
    let attributedString = NSMutableAttributedString(string: text)
    let style = NSMutableParagraphStyle()
    if let lineHeight = lineHeight {
      style.minimumLineHeight = lineHeight
      style.maximumLineHeight = lineHeight
    }
    if let alignement = alignement {
      style.alignment = alignement
    }
    
    attributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range:
      NSRange(location: 0, length: text.characters.count))
    self.attributedText = attributedString
  }
}
