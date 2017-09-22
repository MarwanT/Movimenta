//
//  GalleryPageViewController.swift
//  Movimenta
//
//  Created by Marwan  on 9/22/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class GalleryPageViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

//MARK: Instance
extension GalleryPageViewController {
  class var identifier: String {
    return "GalleryPageViewController"
  }
  
  class func instance() -> GalleryPageViewController {
    guard let vc = UIStoryboard(name: "Gallery", bundle: nil).instantiateViewController(withIdentifier: identifier) as? GalleryPageViewController else {
      fatalError("Couldn't instantiate \(GalleryPageViewController.identifier)")
    }
    return vc
  }
}
