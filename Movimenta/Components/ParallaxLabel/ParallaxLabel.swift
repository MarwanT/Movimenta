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

  //MARK: - Parallax methods
  override func layoutSubviews() {
    super.layoutSubviews()
    initializeValues()
  }
  
  private func initializeValues() {
    centerMinimumY = label.center.y
    centerMaximumY = self.bounds.height
  }
  
  func update() {
    let visibility = self.visibility
    if case .offScreen = visibility {
      switch visibility {
      case .offScreen(.up):
        label.center.y = centerMinimumY
        return
      case .offScreen(.down):
        label.center.y = centerMaximumY
        return
      default:
        break
      }
    }
    
    label.center.y = yPosition(for: scrollingPercentage)
  }
  
  /// Get the label y position based on the percentage given
  /// The range of values is between the maximum and minum
  /// Values of the label.
  fileprivate func yPosition(for percentage: CGFloat) -> CGFloat {
    let maxValue = centerMaximumY - centerMinimumY
    return (maxValue * percentage) + centerMinimumY
  }
  
  /// Value is between 0 and 1
  var scrollingPercentage: CGFloat {
    guard let scrollView = scrollView,
      let scrollSuperView = scrollSuperView else {
      return 0
    }
    let position = scrollView.convert(self.frame, to: scrollSuperView)
    let yPosition = position.origin.y
    let height = scrollSuperView.frame.size.height
    return yPosition/height
  }
  
  /// Get the visibility status of the whole view
  fileprivate var visibility: Visibility {
    guard let scrollView = scrollView,
      let scrollSuperView = scrollSuperView else {
      return .unidentified
    }
    let position = scrollView.convert(self.frame, to: scrollSuperView)
    if position.origin.y <= 0 {
      return .offScreen(.up)
    } else if position.origin.y > scrollSuperView.frame.size.height {
      return .offScreen(.down)
    } else {
      return .onScreen
    }
  }
}

//MARK: - Enums declaration
extension ParallaxLabel {
  fileprivate enum Direction {
    case up
    case down
  }
  
  fileprivate enum Visibility {
    case onScreen
    case offScreen(Direction)
    case unidentified
  }
}
