//
//  ScheduleCell.swift
//  Movimenta
//
//  Created by Marwan  on 9/13/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class ScheduleCell: UICollectionViewCell {
  static let identifier: String = ScheduleCell.defaultNibName
  
  var label: UILabel!
  
  var configuration = Configuration() {
    didSet {
      applyTheme()
      refreshViewForSelection()
    }
  }
  
  override var isSelected: Bool {
    didSet {
      refreshViewForSelection()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  private func initialize() {
    label = UILabel(frame: CGRect.zero)
    contentView.addSubview(label)
    label.snp.makeConstraints { (maker) in
      maker.left.top.right.bottom.equalTo(contentView.snp.margins).priority(750)
      maker.width.greaterThanOrEqualTo(100).priority(1000)
    }
    applyTheme()
  }
  
  private func applyTheme() {
    label.font = configuration.font
    label.textColor = configuration.highlightColor
    contentView.layer.borderColor = configuration.highlightColor.cgColor
    contentView.layer.borderWidth = 0.5
    contentView.layer.cornerRadius = 1
    contentView.layoutMargins = configuration.layoutMargins
    contentView.backgroundColor = configuration.defaultColor
  }
  
  private func refreshViewForSelection() {
    if isSelected {
      label.textColor = configuration.defaultColor
      contentView.backgroundColor = configuration.highlightColor
    } else {
      label.textColor = configuration.highlightColor
      contentView.backgroundColor = configuration.defaultColor
    }
  }
}

//MARK: Configuration
extension ScheduleCell {
  struct Configuration {
    var layoutMargins = UIEdgeInsets(
      top: CGFloat(ThemeManager.shared.current.space8),
      left: CGFloat(ThemeManager.shared.current.space8),
      bottom: CGFloat(ThemeManager.shared.current.space8),
      right: CGFloat(ThemeManager.shared.current.space8))
    var font = ThemeManager.shared.current.font7
    var highlightColor = ThemeManager.shared.current.white
    var defaultColor = ThemeManager.shared.current.color2
    var sideMarginsValue: CGFloat {
      return layoutMargins.left + layoutMargins.right
    }
  }
}
