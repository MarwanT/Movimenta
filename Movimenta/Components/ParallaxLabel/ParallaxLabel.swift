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
  
  fileprivate var centerMinimumY: CGFloat = 0
  fileprivate var centerMaximumY: CGFloat = 0
  
  fileprivate var scrollView: UIScrollView?
  fileprivate var scrollSuperView: UIView?
  
  class func instanceFromNib() -> ParallaxLabel {
    return UINib(nibName: ParallaxLabel.defaultNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ParallaxLabel
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    applyTheme()
  }
  
  func initialize(in scrollView: UIScrollView) {
    self.scrollView = scrollView
    self.scrollSuperView = scrollView.superview
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    label.font = theme.font2
    label.textColor = theme.color3
    clipsToBounds = true
  }
  
  func set(text: String?) {
    label.text = text
  }
  
  func preferredSize() -> CGSize {
    let size = self.systemLayoutSizeFitting(
      CGSize(width: self.bounds.width, height: 0),
      withHorizontalFittingPriority: UILayoutPriorityRequired,
      verticalFittingPriority: UILayoutPriorityFittingSizeLevel)
    return size
  }

}
