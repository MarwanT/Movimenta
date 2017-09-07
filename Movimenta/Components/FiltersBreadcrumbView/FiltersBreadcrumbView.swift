//
//  FiltersBreadcrumbView.swift
//  Movimenta
//
//  Created by Marwan  on 9/6/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import SnapKit
import UIKit

class FiltersBreadcrumbView: UIView {
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var stackView: UIStackView!
  
}

//MARK: Breadcrumbs related
extension FiltersBreadcrumbView {
  enum Breadcrump {
    case dateRange(DateRange)
    case category(Event.Category)
    case withinTime(Int)
    case withinDistance(Double)
    case speaker(Participant)
    case sponsor(Participant)
    case company(Participant)
    case artist(Participant)
    case organizer(Participant)
    case showBookmarked(Bool)
  }
}

//MARK: Configuration
extension FiltersBreadcrumbView {
  struct Configuration {
    var backgroundColor: UIColor = ThemeManager.shared.current.color2
    var foregroundColor: UIColor = ThemeManager.shared.current.lightTextColor
    var layoutMargin: UIEdgeInsets = UIEdgeInsets(
      top: 0, left: CGFloat(ThemeManager.shared.current.space7),
      bottom: 0, right: CGFloat(ThemeManager.shared.current.space7))
  }
}

//MARK: -
extension UILabel {
  static fileprivate func breadcrumb(backgroundColor: UIColor, foregroundColor: UIColor) -> UILabel {
    let theme = ThemeManager.shared.current
    let label = PadableLabel()
    label.font = theme.font15
    label.backgroundColor = backgroundColor
    label.layer.borderWidth = 1
    label.layer.borderColor = foregroundColor.cgColor
    label.layer.cornerRadius = 3
    label.textColor = foregroundColor
    label.padding = UIEdgeInsets(
      top: 0, left: CGFloat(theme.space8),
      bottom: 0, right: CGFloat(theme.space8))
    label.snp.makeConstraints { (maker) in
      maker.height.equalTo(30)
    }
    return label
  }
}
