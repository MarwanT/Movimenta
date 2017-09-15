//
//  ScheduleViewController.swift
//  Movimenta
//
//  Created by Marwan  on 9/13/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
  @IBOutlet weak var datesCollectionView: UICollectionView!
  
  var viewModel = ScheduleViewModel()
  
  static func instance() -> ScheduleViewController {
    return Storyboard.Event.instantiate(ScheduleViewController.self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
