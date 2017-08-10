//
//  ExpandableLabel.swift
//  Movimenta
//
//  Created by Marwan  on 8/10/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import TTTAttributedLabel

class ExpandableLabel: TTTAttributedLabel {
  override func awakeFromNib() {
    super.awakeFromNib()
    delegate = self
}

//MARK: TTTAttributedLabelDelegate
extension ExpandableLabel: TTTAttributedLabelDelegate {
}
