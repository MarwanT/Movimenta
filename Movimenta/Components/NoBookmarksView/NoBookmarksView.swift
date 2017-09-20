//
//  NoBookmarksView.swift
//  Movimenta
//
//  Created by Marwan  on 9/20/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class NoBookmarksView: UIView {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  
  class func instanceFromNib() -> NoBookmarksView {
    return UINib(nibName: NoBookmarksView.defaultNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NoBookmarksView
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initialize()
    applyTheme()
  }
  
  private func initialize() {
    titleLabel.text = Strings.bookmark_your_events()
    contentLabel.text = Strings.how_to_bookmark_text()
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    titleLabel.font = theme.font7
    contentLabel.font = theme.font6
    titleLabel.textColor = theme.darkTextColor
    contentLabel.textColor = theme.darkTextColor
    layoutMargins = UIEdgeInsets(
      top: 0, left: CGFloat(theme.space4),
      bottom: 0, right: CGFloat(theme.space4))
  }
}
