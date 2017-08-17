//
//  ParticipantCell.swift
//  Movimenta
//
//  Created by Marwan  on 8/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class ParticipantCell: UITableViewCell {
  static let identifier: String = ParticipantCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
  @IBOutlet weak var participantImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var roleLabel: UILabel!
  
  @IBOutlet weak var nameLabelHorizontalSpacingToImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var roleLabelVerticalSpacingToNameLabel: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
