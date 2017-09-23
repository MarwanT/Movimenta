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
    title = Strings.ar()
    
    applyTheme()
    setupView()
  }

  private func applyTheme() {
    let theme = ThemeManager.shared.current

    view.backgroundColor = theme.white

    //Fonts
    titleLabel.font = ThemeManager.shared.current.font1
    subtitleLabel.font = ThemeManager.shared.current.font3
    //Color
    titleLabel.textColor = ThemeManager.shared.current.lightTextColor
    subtitleLabel.textColor = ThemeManager.shared.current.lightTextColor
  }

  private func setupView() {
    titleLabel.text = Strings.find_m()
    subtitleLabel.text = Strings.find_scan_message()
    arButton.setTitle(Strings.find_button(), for: .normal)
  }
}

