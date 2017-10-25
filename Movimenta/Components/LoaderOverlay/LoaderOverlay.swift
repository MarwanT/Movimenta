//
//  LoaderOverlay.swift
//  Movimenta
//
//  Created by Marwan  on 10/25/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class LoaderOverlay: UIView {
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  class func instanceFromNib() -> LoaderOverlay {
    return UINib(nibName: LoaderOverlay.defaultNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LoaderOverlay
  }
  
}
