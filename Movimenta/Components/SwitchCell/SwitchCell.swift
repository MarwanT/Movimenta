//
//  SwitchCell.swift
//  Movimenta
//
//  Created by Marwan  on 9/4/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {
  static let identifier: String = SwitchCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var switchIndicator: UISwitch!
  
  var configuration = Configuration()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

extension SwitchCell {
  struct Configuration {
    var layoutMargins = UIEdgeInsets(
      top: CGFloat(ThemeManager.shared.current.space2),
      left: CGFloat(ThemeManager.shared.current.space7),
      bottom: CGFloat(ThemeManager.shared.current.space2),
      right: CGFloat(ThemeManager.shared.current.space7))
  }
}
