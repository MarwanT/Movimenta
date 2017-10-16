//
//  TableViewSectionHeader.swift
//  Movimenta
//
//  Created by Marwan  on 8/14/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import SnapKit
import UIKit

class TableViewSectionHeader: UITableViewHeaderFooterView {
  static let identifier: String = TableViewSectionHeader.defaultNibName
  
  var label: UILabel!
  var separatorContainerView: UIView!
  var separatorView: UIView!
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    initializeView()
    applyTheme()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initializeView()
    applyTheme()
  }
  
  private func initializeView() {
    separatorContainerView = UIView(frame: CGRect.zero)
    contentView.addSubview(separatorContainerView)
    separatorContainerView.snp.makeConstraints { (maker) in
      maker.left.top.right.equalTo(contentView)
    }
    
    separatorView = UIView(frame: CGRect.zero)
    separatorContainerView.addSubview(separatorView)
    separatorView.snp.makeConstraints { (maker) in
      maker.height.equalTo(0.5)
      maker.edges.equalTo(separatorContainerView.snp.margins)
    }
    
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
    label.font = theme.font4
    label.textColor = theme.darkTextColor
    separatorView.backgroundColor = theme.separatorColor
    contentView.backgroundColor = theme.white
    backgroundColor = theme.white
    contentView.layoutMargins = UIEdgeInsets(
      top: CGFloat(theme.space4),
      left: CGFloat(theme.space7), bottom: 0, right: 0)
    layoutMargins = UIEdgeInsets.zero
  }
  
  var text: String? {
    get {
      return label.text
    }
    
    set {
      label.text = newValue
    }
  }
  
  var separatorMargins: UIEdgeInsets {
    get {
      return separatorContainerView.layoutMargins
    }
    set {
      separatorContainerView.layoutMargins = newValue
    }
  }
}
