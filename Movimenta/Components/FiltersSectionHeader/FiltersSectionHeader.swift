//
//  FiltersSectionHeader.swift
//  Movimenta
//
//  Created by Marwan  on 8/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import SnapKit
import UIKit

class FiltersSectionHeader: UITableViewHeaderFooterView {
  static let identifier: String = FiltersSectionHeader.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
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
    setup()
    applyTheme()
  }
  
  private func setup() {
    label = UILabel(frame: CGRect.zero)
    label.numberOfLines = 0
    contentView.addSubview(label)
    label.snp.makeConstraints { (maker) in
      maker.edges.equalTo(contentView.snp.margins).priority(750)
      maker.width.greaterThanOrEqualTo(100).priority(1000)
    }
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    label.font = theme.font8
    label.textColor = theme.darkTextColor
    backgroundColor = theme.color4
    contentView.backgroundColor = theme.color4
    contentView.layoutMargins = configuration.contentViewMargins
  }
  
  //MARK: APIs
  func set(_ text: String?) {
    label.text = text
  }
}

extension FiltersSectionHeader {
  struct Configuration {
    var contentViewMargins = UIEdgeInsetsMake(
      CGFloat(ThemeManager.shared.current.space1),
      CGFloat(ThemeManager.shared.current.space7),
      CGFloat(ThemeManager.shared.current.space1),
      CGFloat(ThemeManager.shared.current.space7))
  }
}
