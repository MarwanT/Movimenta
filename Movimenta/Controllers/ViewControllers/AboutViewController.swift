//
//  AboutViewController.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/16/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

class AboutViewController: UIViewController {

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
    //Localize title
    title = Strings.about()

    //TODO: Needed setup
  }

  private func applyTheme() {
    //TODO: Needed theming
  }
}

extension AboutViewController {
  static func instance() -> AboutViewController {
    return Storyboard.Information.instantiate(AboutViewController.self)
  }
}
