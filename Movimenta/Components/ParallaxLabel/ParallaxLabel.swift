//
//  ParallaxLabel.swift
//  Movimenta
//
//  Created by Marwan  on 8/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class ParallaxLabel: UIView {
  @IBOutlet weak var label: UILabel!
  
  class func instanceFromNib() -> ParallaxLabel {
    return UINib(nibName: ParallaxLabel.defaultNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ParallaxLabel
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    applyTheme()
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    label.font = theme.font2
    label.textColor = theme.color3
  }
  
  func set(text: String?) {
    label.text = text
  }
  
  func preferredSize() -> CGSize {
    let size = self.systemLayoutSizeFitting(
      CGSize(width: self.bounds.width, height: 0),
      withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityFittingSizeLevel)
    return size
  }

}
