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
    initialize()
  }
  
  private func initialize() {
    initializeTableView()
  }
  
  private func initializeTableView() {
    let theme = ThemeManager.shared.current
    
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    
    tableView.layoutMargins = UIEdgeInsets(
      top: 0, left: CGFloat(theme.space7),
      bottom: 0, right: CGFloat(theme.space7))
    
    tableView.separatorStyle = .singleLine
    tableView.separatorColor = theme.separatorColor
  }
}

//MARK: Table View Delegates
extension ParticipantViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
}
