//
//  PartnersViewController.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

class PartnersViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  let viewModel: PartnersViewModel = PartnersViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }

  private func initialize() {
    //All Initializations and Setup
    applyTheme()
    setupView()
  }

  private func setupView() {
    //TODO: Addtional needed setup
  }

  private func applyTheme() {
    //TODO: Apply style
  }
}

extension PartnersViewController {
  static func instance() -> PartnersViewController {
    return Storyboard.Information.instantiate(PartnersViewController.self)
  }
}
