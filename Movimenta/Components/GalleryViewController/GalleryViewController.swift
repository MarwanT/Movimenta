//
//  GalleryViewController.swift
//  Movimenta
//
//  Created by Marwan  on 9/22/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class GalleryViewController: UIPageViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

//MARK: Instance
extension GalleryViewController {
  class var identifier: String {
    return "GalleryViewController"
  }
  
  class func instance() -> GalleryViewController {
    guard let vc = UIStoryboard(name: "Gallery", bundle: nil).instantiateViewController(withIdentifier: identifier) as? GalleryViewController else {
      fatalError("Couldn't instantiate \(GalleryViewController.identifier)")
    }
    return vc
  }
}
