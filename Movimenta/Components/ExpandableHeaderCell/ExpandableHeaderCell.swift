//
//  ExpandableHeaderCell.swift
//  Movimenta
//
//  Created by Marwan  on 8/28/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class ExpandableHeaderCell: UITableViewCell {
  static let identifier: String = ExpandableHeaderCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var arrowImageView: UIImageView!
  
}

extension ExpandableHeaderCell {
  struct Configuration {
    var layoutMargins = UIEdgeInsets(
      top: CGFloat(ThemeManager.shared.current.space8),
      left: CGFloat(ThemeManager.shared.current.space7),
      bottom: CGFloat(ThemeManager.shared.current.space8),
      right: CGFloat(ThemeManager.shared.current.space7))
    fileprivate var selectedSeparatorInset = UIEdgeInsets(
      top: 0, left: 10000, bottom: 0, right: 0)
    fileprivate var defaultSeparatorInset = UIEdgeInsets(
      top: 0, left: CGFloat(ThemeManager.shared.current.space7), bottom: 0, right: 0)
  }
}
