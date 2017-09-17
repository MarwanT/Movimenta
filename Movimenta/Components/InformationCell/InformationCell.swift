//
//  InformationCell.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

class InformationCell: UITableViewCell {
  static let identifier: String = InformationCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)

  override func awakeFromNib() {
    super.awakeFromNib()
    applyTheme()
  }

  private func applyTheme() {
    //TODO: Apply theme
  }
}
