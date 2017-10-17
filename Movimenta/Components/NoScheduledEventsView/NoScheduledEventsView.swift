//
//  NoScheduledEventsView.swift
//  Movimenta
//
//  Created by Marwan  on 10/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class NoScheduledEventsView: UIView {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!

  class func instanceFromNib() -> NoScheduledEventsView {
    return UINib(nibName: NoScheduledEventsView.defaultNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NoScheduledEventsView
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initialize()
    applyTheme()
  }
  
  private func initialize() {
    titleLabel.text = Strings.no_events_found()
    contentLabel.text = Strings.no_events_happening_on_day()
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    titleLabel.font = theme.font7
    titleLabel.textColor = theme.darkTextColor
    contentLabel.font = theme.font6
    contentLabel.textColor = theme.darkTextColor
    layoutMargins = UIEdgeInsets(
      top: 0, left: CGFloat(theme.space4),
      bottom: 0, right: CGFloat(theme.space4))
  }
}
