//
//  SliderCell.swift
//  Movimenta
//
//  Created by Marwan  on 9/4/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class SliderCell: UITableViewCell {
  static let identifier: String = SliderCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var slider: UISlider!
  
  var configuration = Configuration()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

extension SliderCell {
  struct Configuration {
    var layoutMargins = UIEdgeInsets(
      top: CGFloat(ThemeManager.shared.current.space7),
      left: CGFloat(ThemeManager.shared.current.space7),
      bottom: CGFloat(ThemeManager.shared.current.space7),
      right: CGFloat(ThemeManager.shared.current.space7))
  }
}
