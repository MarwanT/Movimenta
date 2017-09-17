//
//  InformationListingViewController.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

class InformationListingViewController: UIViewController {

  let viewModel = InformationListingViewModel()

  func initialize(with mode: InformationListingViewModel.Mode) {
    viewModel.initialize(with: mode)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }

  private func initialize() {
    //All Initializations and Setup
    applyTheme()
    setupView()
  }

  private func applyTheme() {
    //TODO: apply theme
  }

  private func setupView() {
    title = viewModel.vcTitle()
    //Additional: setup view
  }
}

extension InformationListingViewController {
  static func instance() -> InformationListingViewController {
    return Storyboard.Information.instantiate(InformationListingViewController.self)
  }
}
