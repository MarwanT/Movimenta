//
//  SelectableCell.swift
//  Movimenta
//
//  Created by Marwan  on 8/29/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class SelectableCell: UITableViewCell {
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var selectionImageView: UIImageView!
  
  @IBOutlet weak var labelLeadingToSuperviewLeading: NSLayoutConstraint!
  
  var configuration = Configuration()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
}

extension SelectableCell {
  struct Configuration {
    var layoutMargins = UIEdgeInsets(
      top: CGFloat(ThemeManager.shared.current.space8),
      left: CGFloat(ThemeManager.shared.current.space7),
      bottom: CGFloat(ThemeManager.shared.current.space8),
      right: CGFloat(ThemeManager.shared.current.space7))
    var indentationWidth: CGFloat = CGFloat(ThemeManager.shared.current.space7)
    fileprivate var defaultSeparatorInset = UIEdgeInsets(
      top: 0, left: CGFloat(ThemeManager.shared.current.space7), bottom: 0, right: 0)
  }
}
