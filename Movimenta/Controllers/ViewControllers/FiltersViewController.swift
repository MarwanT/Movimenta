//
//  FiltersViewController.swift
//  Movimenta
//
//  Created by Marwan  on 8/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel = FiltersViewModel()
  
  static func instance() -> FiltersViewController {
    return Storyboard.Filter.instantiate(FiltersViewController.self)
  }
  
  func initialize(with filter: Filter?) {
    viewModel.initialize(with: filter)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension FiltersViewController {
  enum Section: Int {
    case dates = 0
    case types
    case withinTime
    case participants
    case withinDistance
    case bookmark
    
    static var numberOfSections: Int {
      return 6
    }
  }
}
