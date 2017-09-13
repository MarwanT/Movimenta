//
//  EventCell.swift
//  Movimenta
//
//  Created by Marwan  on 9/12/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
  static let identifier: String = EventCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
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
  
  var configuration = Configuration()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  @IBAction func bookmarkButtonTouchUpInside(_ sender: Any) {
  }
}

//MARK: Configuration
extension EventCell {
  struct Configuration {
    var layoutMargins = UIEdgeInsets(
      top: CGFloat(ThemeManager.shared.current.space4),
      left: CGFloat(ThemeManager.shared.current.space7),
      bottom: CGFloat(ThemeManager.shared.current.space4),
      right: CGFloat(ThemeManager.shared.current.space7))
  }
}
