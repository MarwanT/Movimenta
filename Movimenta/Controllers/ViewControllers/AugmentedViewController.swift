//
//  AugmentedViewController.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class AugmentedViewController: UIViewController {

  static func instance() -> AugmentedViewController {
    return Storyboard.Root.instantiate(AugmentedViewController.self)
  }

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var arButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }

  private func initialize() {
    applyTheme()
    setupView()
  }

  private func applyTheme() {
    //TODO: apply Theme
  }

  private func setupView() {
    //TODO: setup View
  }
}

