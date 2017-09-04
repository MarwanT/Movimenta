//
//  SliderCell.swift
//  Movimenta
//
//  Created by Marwan  on 9/4/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class SliderCell: UITableViewCell {
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var slider: UISlider!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
