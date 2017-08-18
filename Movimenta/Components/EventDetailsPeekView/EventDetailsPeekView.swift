//
//  EventDetailsPeekView.swift
//  Movimenta
//
//  Created by Marwan  on 8/7/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class EventDetailsPeekView: UIView {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
  var configuration = Configuration()
  
  override func awakeAfter(using aDecoder: NSCoder) -> Any? {
    return viewForNibNameIfNeeded(nibName: type(of: self).defaultNibName)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    applyTheme()
    setup()
  }
  
  private func setup() {
    layoutMargins = configuration.internalMargins
  }
  
  private func applyTheme() {
    titleLabel.font = ThemeManager.shared.current.font4
    subtitleLabel.font = ThemeManager.shared.current.font12
    titleLabel.textColor = ThemeManager.shared.current.color2
    subtitleLabel.textColor = ThemeManager.shared.current.darkTextColor
  }
}

extension EventDetailsPeekView {
  struct Configuration {
    var internalMargins = UIEdgeInsets(
      top: CGFloat(ThemeManager.shared.current.space7),
      left: CGFloat(ThemeManager.shared.current.space7),
      bottom: CGFloat(ThemeManager.shared.current.space7),
      right: CGFloat(ThemeManager.shared.current.space7))
  }
}
