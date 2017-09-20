//
//  NoBookmarksView.swift
//  Movimenta
//
//  Created by Marwan  on 9/20/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class NoBookmarksView: UIView {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  
  class func instanceFromNib() -> NoBookmarksView {
    return UINib(nibName: NoBookmarksView.defaultNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NoBookmarksView
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initialize()
  }
  
  private func initialize() {
    titleLabel.text = Strings.bookmark_your_events()
    contentLabel.text = Strings.how_to_bookmark_text()
  }
}
