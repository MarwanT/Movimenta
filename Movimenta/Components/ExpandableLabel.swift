//
//  ExpandableLabel.swift
//  Movimenta
//
//  Created by Marwan  on 8/10/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import TTTAttributedLabel

class ExpandableLabel: TTTAttributedLabel {
  override func awakeFromNib() {
    super.awakeFromNib()
    delegate = self
  }
  
  override var attributedText: NSAttributedString! {
    willSet {
      setTruncationToken()
    }
  }
}

//MARK: Helpers
extension ExpandableLabel {
  fileprivate func setTruncationToken() {
    let viewMoreAttributedString = NSMutableAttributedString()
    let threeDots = NSAttributedString(string: "...", attributes:
      [
        NSFontAttributeName : font,
        NSForegroundColorAttributeName : textColor
      ]
    )
    let viewMore = NSAttributedString(string: Strings.view_more(), attributes:
      [
        NSForegroundColorAttributeName : ThemeManager.shared.current.color2,
        NSFontAttributeName : ThemeManager.shared.current.font12
      ]
    )
    viewMoreAttributedString.append(threeDots)
    viewMoreAttributedString.append(viewMore)
    attributedTruncationToken = viewMoreAttributedString
  }
}

//MARK: TTTAttributedLabelDelegate
extension ExpandableLabel: TTTAttributedLabelDelegate {
}
