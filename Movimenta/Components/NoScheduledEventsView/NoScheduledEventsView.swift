//
//  NoScheduledEventsView.swift
//  Movimenta
//
//  Created by Marwan  on 10/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class NoScheduledEventsView: UIView {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!

  class func instanceFromNib() -> NoScheduledEventsView {
    return UINib(nibName: NoScheduledEventsView.defaultNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NoScheduledEventsView
  }
  
}
