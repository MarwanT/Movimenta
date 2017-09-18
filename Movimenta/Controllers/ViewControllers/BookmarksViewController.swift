//
//  BookmarksViewController.swift
//  Movimenta
//
//  Created by Marwan  on 9/18/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel = BookmarksViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
