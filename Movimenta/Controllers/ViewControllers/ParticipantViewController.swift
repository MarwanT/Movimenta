//
//  ParticipantViewController.swift
//  Movimenta
//
//  Created by Marwan  on 9/11/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class ParticipantViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel = ParticipantViewModel()
  
  static func instance() -> ParticipantViewController {
    return Storyboard.Event.instantiate(ParticipantViewController.self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
