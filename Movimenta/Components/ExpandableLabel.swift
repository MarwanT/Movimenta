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
  var configuration = Configuration() {
    didSet {
      if isTruncated {
        numberOfLines = configuration.minimumNumberOfLines
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    delegate = self
    addGestureRecognizer()
  }
  
  private func addGestureRecognizer() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
    addGestureRecognizer(tapGesture)
  }
  
  override var attributedText: NSAttributedString! {
    willSet {
      setTruncationToken()
    }
  }
  
  func didTapView(_ sender: UIGestureRecognizer) {
    toggleState()
  }
  
  func toggleState() {
    if isTruncated {
      self.numberOfLines = self.requiredNumberOfLines
    } else {
      self.numberOfLines = self.configuration.minimumNumberOfLines
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
  
  var isTruncated: Bool {
    return numberOfLines < requiredNumberOfLines
  }
  
  var requiredNumberOfLines: Int {
    guard let text = text else {
      return 0
    }
    let nsText = text as NSString
    let boundingRect = nsText.boundingRect(
      with: CGSize(width: frame.width, height: CGFloat.infinity),
      options: NSStringDrawingOptions.usesLineFragmentOrigin,
      attributes: [NSFontAttributeName : font],
      context: nil)
    return Int(ceil(boundingRect.height/font.lineHeight))+1
  }
}

//MARK: TTTAttributedLabelDelegate
extension ExpandableLabel: TTTAttributedLabelDelegate {
}

//MARK: Configuration
extension ExpandableLabel {
  struct Configuration {
    private(set) var minimumNumberOfLines: Int = 5
    mutating func setMinimumNumberOfLines(_ number: Int) {
      minimumNumberOfLines = number + 1
    }
  }
}

//MARK: State Declaration
extension ExpandableLabel {
  enum State {
    case expand
    case collapse
  }
}
