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

  var label: UILabel!

  var configuration = Configuration()
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    initializeView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initializeView()
  }
  
  private func initializeView() {
    initialize()
    applyTheme()
  }
  
  private func initialize() {
    label = UILabel(frame: CGRect.zero)
    label.numberOfLines = 0
    contentView.addSubview(label)
    label.snp.makeConstraints { (maker) in
      maker.edges.equalTo(contentView.snp.margins).priority(750)
      maker.width.greaterThanOrEqualTo(100).priority(1000)
    }
    
    contentView.layoutMargins = configuration.layoutMargins
  }

  private func applyTheme() {
    let theme = ThemeManager.shared.current
    label.font = theme.font4
    label.textColor = theme.color3
    label.numberOfLines = 0

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
