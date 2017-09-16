//
//  InformationViewController.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/16/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

class InformationViewController: UIViewController {


  @IBOutlet weak var leadingAboutConstraint: NSLayoutConstraint!
  @IBOutlet weak var trailingAboutConstraint: NSLayoutConstraint!
  @IBOutlet weak var topAboutConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomHotelsConstraint: NSLayoutConstraint!
  @IBOutlet weak var spaceBetweenConstraint: NSLayoutConstraint!

  @IBOutlet weak var aboutLabel: UILabel!
  @IBOutlet weak var aboutAppLabel: UILabel!
  @IBOutlet weak var partnersLabel: UILabel!
  @IBOutlet weak var contactLabel: UILabel!
  @IBOutlet weak var hotelsLabel: UILabel!
  @IBOutlet weak var restaurantsLabel: UILabel!

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
    //Localize labels
    aboutLabel.text = Strings.info_app_title()
    aboutAppLabel.text = Strings.info_app_subtitle()
    partnersLabel.text = Strings.partners()
    contactLabel.text = Strings.contact()
    hotelsLabel.text = Strings.hotels()
    restaurantsLabel.text = Strings.restaurants()
  }

  private func applyTheme() {
    let theme = ThemeManager.shared.current

    view.backgroundColor = theme.white

    //Setup bounds
    leadingAboutConstraint.constant = CGFloat(theme.space7)
    trailingAboutConstraint.constant = CGFloat(theme.space7)
    topAboutConstraint.constant = CGFloat(theme.space7)
    bottomHotelsConstraint.constant = CGFloat(theme.space7)
    spaceBetweenConstraint.constant = CGFloat(theme.space7)

    //Fonts
    aboutLabel.font = ThemeManager.shared.current.font1
    aboutAppLabel.font = ThemeManager.shared.current.font6
    partnersLabel.font = ThemeManager.shared.current.font4
    contactLabel.font = ThemeManager.shared.current.font4
    hotelsLabel.font = ThemeManager.shared.current.font4
    restaurantsLabel.font = ThemeManager.shared.current.font4

    aboutLabel.textColor = ThemeManager.shared.current.lightTextColor
    aboutAppLabel.textColor = ThemeManager.shared.current.lightTextColor
    partnersLabel.textColor = ThemeManager.shared.current.lightTextColor
    contactLabel.textColor = ThemeManager.shared.current.lightTextColor
    hotelsLabel.textColor = ThemeManager.shared.current.lightTextColor
    restaurantsLabel.textColor = ThemeManager.shared.current.lightTextColor
  }

}

//MARK: - Instance
extension InformationViewController {
  static func instance() -> InformationViewController {
    return Storyboard.Information.instantiate(InformationViewController.self)
  }
}
