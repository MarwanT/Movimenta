//
//  AboutViewController.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/16/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

class AboutViewController: UIViewController {


  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var separatorView: UIView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var informationLabel: UILabel!


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

    //Addtional needed setup
    let theme = ThemeManager.shared.current

    contentView.layoutMargins = UIEdgeInsets(
      top: 0, left: CGFloat(theme.space7),
      bottom: 0, right: CGFloat(theme.space7))
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
