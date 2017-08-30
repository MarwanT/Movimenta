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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
}
