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
