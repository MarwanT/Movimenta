//
//  PartnerSectionCell.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class PartnerSectionCell: UITableViewHeaderFooterView {
  static let identifier: String = PartnerSectionCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)

  @IBOutlet weak var label: UILabel!

  var configuration = Configuration()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.layoutMargins = configuration.layoutMargins
    applyTheme()
  }

  private func applyTheme() {
    let theme = ThemeManager.shared.current
    label.font = theme.font4
    label.textColor = theme.color3

    contentView.backgroundColor = theme.white
    backgroundColor = theme.white
  }

  public func setup(title: String?) {
    let theme = ThemeManager.shared.current
    label.paragraph(with: title, lineHeight: theme.fontBook4.lineHeight)
  }
}

//MARK: Configuration
extension PartnerSectionCell {
  struct Configuration {
    var layoutMargins = UIEdgeInsets(
      top: 0,
      left: CGFloat(ThemeManager.shared.current.space7),
      bottom: 0,
      right: CGFloat(ThemeManager.shared.current.space7))
  }
}
