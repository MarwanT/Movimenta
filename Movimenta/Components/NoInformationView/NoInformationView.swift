//
//  NoInformationView.swift
//  Movimenta
//
//  Created by Marwan  on 10/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class NoInformationView: UIView {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  
  var mode: InformationListingViewModel.Mode = .hotels {
    didSet {
      refreshViewForMode()
    }
  }

  class func instanceFromNib() -> NoInformationView {
    return UINib(nibName: NoInformationView.defaultNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NoInformationView
  }
  
  func initialize(with mode: InformationListingViewModel.Mode) {
    self.mode = mode
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    applyTheme()
    refreshViewForMode()
  }
  
  private func refreshViewForMode() {
    switch mode {
    case .hotels:
      titleLabel.text = Strings.no_hotels_available()
    case .restaurants:
      titleLabel.text = Strings.no_restaurants_available()
    }
    contentLabel.text = nil
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    titleLabel.font = theme.font7
    titleLabel.textColor = theme.darkTextColor
    contentLabel.font = theme.font6
    contentLabel.textColor = theme.darkTextColor
    layoutMargins = UIEdgeInsets(
      top: 0, left: CGFloat(theme.space6),
      bottom: 0, right: CGFloat(theme.space6))
  }
}
