//
//  EventCell.swift
//  Movimenta
//
//  Created by Marwan  on 9/12/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import SDWebImage
import UIKit

protocol EventCellDelegate: class {
  func eventCellDidTapBookmarkButton(_ cell: EventCell)
}

class EventCell: UITableViewCell {
  static let identifier: String = EventCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
  @IBOutlet weak var baseView: UIView!
  @IBOutlet weak var eventImageView: UIImageView!
  @IBOutlet weak var pinImageView: UIImageView!
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
  
  var isBookmarked: Bool = false {
    didSet {
      refreshBookmarkButton()
    }
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    bookmarkButton.isHidden = editing
    refreshSelectionBackground()
  }
  
  weak var delegate: EventCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    applyTheme()
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    dateLabel.font = theme.font1
    venueNameLabel.font = theme.font14
    eventNameLabel.font = theme.font4
    categoryLabel.font = theme.font14
    timeLabel.font = theme.font13
    dateLabel.textColor = theme.darkTextColor
    venueNameLabel.textColor = theme.darkTextColor
    eventNameLabel.textColor = theme.color2
    categoryLabel.textColor = theme.darkTextColor
    timeLabel.textColor = theme.darkTextColor
    bookmarkButton.tintColor = theme.color2
    pinImageView.tintColor = theme.darkTextColor
    refreshBookmarkButton()
    setLabelsTopPadding()
    setSideMargins()
    eventImageView.clipsToBounds = true
    eventImageView.contentMode = .scaleAspectFill
    contentView.layoutMargins = configuration.layoutMargins
    baseView.layoutMargins = configuration.layoutMargins
    selectedBackgroundView = UIImageView(image: theme.color6.image())
    tintColor = theme.color2
  }
  
  fileprivate func refreshBookmarkButton() {
    bookmarkButton.setImage(isBookmarked ? #imageLiteral(resourceName: "bookmarkFilled") : #imageLiteral(resourceName: "bookmarkOutline"), for: .normal)
  }
  
  fileprivate func refreshSelectionBackground() {
    selectedBackgroundView = UIImageView(image: (isEditing ? UIColor.clear : ThemeManager.shared.current.color6).image())
  }
  
  fileprivate func setLabelsTopPadding() {
    dateLabelTopVerticalSpacing.constant = -15
    venueNameLabelTopVerticalSpacing.constant = 0
    eventNameLabelTopVerticalSpacing.constant = 5
    categoryLabelTopVerticalSpacing.constant = 5
    timeLabelTopVerticalSpacing.constant = 5
    contentView.layoutIfNeeded()
  }
  
  fileprivate func setSideMargins() {
    let theme = ThemeManager.shared.current
    dateLabelLeadingToImageViewTrailing.constant = CGFloat(theme.space7)
    dateLabelTrailingToBookmarkButtonLeading.constant = 0
    contentView.layoutIfNeeded()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  @IBAction func bookmarkButtonTouchUpInside(_ sender: Any) {
    delegate?.eventCellDidTapBookmarkButton(self)
  }
  
  func set(imageURL: URL?, date: String?, venueName: String?, eventName: String?, categories: String?, time: String?, isBookmarked: Bool?) {
    eventImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "imagePlaceholderSmall"))
    dateLabel.text = date
    venueNameLabel.text = venueName
    eventNameLabel.text = eventName
    categoryLabel.text = categories
    timeLabel.text = time
    self.isBookmarked = isBookmarked ?? false
    if let venueName = venueName, !venueName.trimed().isEmpty {
      pinImageView.isHidden = false
    } else {
      pinImageView.isHidden = true
    }
    contentView.manipulateLabelsSubviewsTopMarginsIfNeeded()
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
