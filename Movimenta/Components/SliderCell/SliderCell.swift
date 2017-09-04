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
    initialize()
    applyTheme()
  }
  
  private func initialize() {
    selectionStyle = .none
    contentView.layoutMargins = configuration.layoutMargins
    separatorInset = UIEdgeInsets.zero
    slider.addTarget(self, action: #selector(didSlide(_:)), for: .valueChanged)
    slider.addTarget(self, action: #selector(finishedEditing(_:)), for: .touchUpInside)
    slider.addTarget(self, action: #selector(finishedEditing(_:)), for: .touchUpOutside)
    slider.isContinuous = true
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    label.font = theme.font9
    label.textColor = theme.darkTextColor
    slider.tintColor = theme.color2
    slider.maximumTrackTintColor = theme.color5
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  //MARK: Action
  func didSlide(_ slider: UISlider) {
  }
  
  func finishedEditing(_ slider: UISlider) {
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
