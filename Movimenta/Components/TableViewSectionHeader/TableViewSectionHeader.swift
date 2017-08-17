//
//  TableViewSectionHeader.swift
//  Movimenta
//
//  Created by Marwan  on 8/14/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class TableViewSectionHeader: UITableViewHeaderFooterView {
  static let identifier: String = TableViewSectionHeader.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var separatorContainerView: UIView!
  @IBOutlet weak var separatorView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    applyTheme()
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    label.font = theme.font4
    label.textColor = theme.darkTextColor
    separatorView.backgroundColor = theme.separatorColor
    contentView.backgroundColor = theme.white
    backgroundColor = theme.white
    self.constraints.topConstraints(item: label).first?.constant = CGFloat(theme.space4)
    self.layoutIfNeeded()
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
