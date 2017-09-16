//
//  AboutViewController.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/16/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import TTTAttributedLabel

class AboutViewController: UIViewController {


  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var separatorView: UIView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var informationLabel: TTTAttributedLabel!


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
    descriptionLabel.text = Strings.about_description()
    subtitleLabel.text = Strings.about_subtitle()
    informationLabel.text = Strings.about_subtitle_description()

    //Addtional needed setup
    let theme = ThemeManager.shared.current

    contentView.layoutMargins = UIEdgeInsets(
      top: 0, left: CGFloat(theme.space7),
      bottom: 0, right: CGFloat(theme.space7))
  }

  private func applyTheme() {
    let theme = ThemeManager.shared.current

    separatorView.backgroundColor = theme.separatorColor

    //Set fonts
    descriptionLabel.font = theme.font6
    subtitleLabel.font = theme.font5
    informationLabel.font = theme.font6
    //Set colors
    descriptionLabel.textColor = theme.darkTextColor
    subtitleLabel.textColor = theme.darkTextColor
    informationLabel.textColor = theme.darkTextColor
  }
}

extension AboutViewController {
  static func instance() -> AboutViewController {
    return Storyboard.Information.instantiate(AboutViewController.self)
  }
}
