//
//  FiltersViewController.swift
//  Movimenta
//
//  Created by Marwan  on 8/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
  
  static func instance() -> FiltersViewController {
    return Storyboard.Filter.instantiate(FiltersViewController.self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
