//
//  LoaderOverlay.swift
//  Movimenta
//
//  Created by Marwan  on 10/25/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class LoaderOverlay: UIView {
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  class func instanceFromNib() -> LoaderOverlay {
    return UINib(nibName: LoaderOverlay.defaultNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LoaderOverlay
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    applyTheme()
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    activityIndicator.color = theme.color2
    backgroundColor = theme.white.withAlphaComponent(0.5)
  }
  
}
