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

  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }

  private func initialize() {
    //All Initializations and Setup
    setupView()
  }

  private func setupView() {
    let theme = ThemeManager.shared.current

    //Setup bounds
    leadingAboutConstraint.constant = CGFloat(theme.space7)
    trailingAboutConstraint.constant = CGFloat(theme.space7)
    topAboutConstraint.constant = CGFloat(theme.space7)
    bottomHotelsConstraint.constant = CGFloat(theme.space7)
    spaceBetweenConstraint.constant = CGFloat(theme.space7)
  }

}

//MARK: - Instance
extension InformationViewController {
  static func instance() -> InformationViewController {
    return Storyboard.Information.instantiate(InformationViewController.self)
  }
}
