//
//  SwitchCell.swift
//  Movimenta
//
//  Created by Marwan  on 9/4/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate: class {
  func switchCell(_ cell: SwitchCell, didSwitchOn isOn: Bool)
}

class SwitchCell: UITableViewCell {
  static let identifier: String = SwitchCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var switchIndicator: UISwitch!
  
  var configuration = Configuration()
  
  weak var delegate: SwitchCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
    applyTheme()
  }
  
  private func setup() {
    selectionStyle = .none
    contentView.layoutMargins = configuration.layoutMargins
    switchIndicator.addTarget(self, action: #selector(didSwitch(_:)), for: UIControlEvents.valueChanged)
    separatorInset = UIEdgeInsets.zero
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    label.font = theme.font9
    label.textColor = theme.darkTextColor
    switchIndicator.onTintColor = theme.color2
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func set(label text: String?, switchOn: Bool) {
    label.text = text
    switchIndicator.isOn = switchOn
  }
  
  //MARK: Action
  func didSwitch(_ sender: UISwitch) {
    delegate?.switchCell(self, didSwitchOn: sender.isOn)
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
