//
//  EventCell.swift
//  Movimenta
//
//  Created by Marwan  on 9/12/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
  @IBOutlet weak var participantImageView: UIImageView!
  @IBOutlet weak var bookmarkButton: UIButton!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var venueNameLabel: UILabel!
  @IBOutlet weak var eventNameLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  @IBOutlet weak var dateLabelLeadingToImageViewTrailing: NSLayoutConstraint!
  @IBOutlet weak var dateLabelTrailingToBookmarkButtonLeading: NSLayoutConstraint!
  @IBOutlet weak var dateLabelTopVerticalSpacing: NSLayoutConstraint!
  @IBOutlet weak var venueNameLabelTopVerticalSpacing: NSLayoutConstraint!
  @IBOutlet weak var eventNameLabelTopVerticalSpacing: NSLayoutConstraint!
  @IBOutlet weak var categoryLabelTopVerticalSpacing: NSLayoutConstraint!
  @IBOutlet weak var timeLabelTopVerticalSpacing: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
