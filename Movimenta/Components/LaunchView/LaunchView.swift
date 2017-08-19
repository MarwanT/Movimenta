//
//  LaunchView.swift
//  Movimenta
//
//  Created by Marwan  on 8/18/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class LaunchView: UIView {
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  
  class func instanceFromNib() -> LaunchView {
    return UINib(nibName: LaunchView.defaultNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LaunchView
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    applyTheme()
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    descriptionLabel.font = theme.font3
    descriptionLabel.textColor = theme.lightTextColor
    infoLabel.font = theme.font2
    infoLabel.textColor = theme.lightTextColor
    layoutMargins = UIEdgeInsets(top: 100, left: 40, bottom: 0, right: 40)
  }
}
