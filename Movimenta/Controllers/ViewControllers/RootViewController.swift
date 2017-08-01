//
//  RootViewController.swift
//  Movimenta
//
//  Created by Marwan  on 8/1/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    initializeTabBarViewControllers()
  }
  
  func initializeTabBarViewControllers() {
  }
}

//MARK: Instance
extension RootViewController {
  static func instance() -> RootViewController {
    return Storyboard.Root.instantiate(RootViewController.self)
  }
}
