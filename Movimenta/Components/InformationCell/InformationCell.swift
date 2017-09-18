//
//  InformationCell.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class InformationCell: UITableViewCell {
  static let identifier: String = InformationCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var displayImageView: UIImageView!
  @IBOutlet weak var websiteLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    applyTheme()
  }

  private func applyTheme() {
    //TODO: Apply theme
  }
}
