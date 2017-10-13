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
  
  private static var measureCell = ScheduleCell()
  static func preferredSize(for text: String?) -> CGSize {
    measureCell.set(text)
    return measureCell.preferredSize()
  }
  
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
      maker.width.greaterThanOrEqualTo(configuration.layoutMargins.left + configuration.layoutMargins.right).priority(1000)
    }
    applyTheme()
  }
  
  private func applyTheme() {
    label.font = configuration.font
    label.textColor = configuration.highlightColor
    contentView.layer.borderColor = configuration.highlightColor.cgColor
    contentView.layer.borderWidth = 1
    contentView.layer.cornerRadius = 3
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
  
  func preferredSize() -> CGSize {
    let text = label.text ?? ""
    let height: CGFloat = configuration.targetSize.height
    let width: CGFloat = text.width(withConstraintedHeight: height, font: ThemeManager.shared.current.font7) + configuration.layoutMargins.left + layoutMargins.right
    return CGSize(width: width, height: height)
  }
  
  //MARK: APIs
  func set(_ text: String?, isSelected: Bool = false) {
    label.text = text
    self.isSelected = isSelected
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
    var targetSize = CGSize(width: 0, height: 44)
  }
}
