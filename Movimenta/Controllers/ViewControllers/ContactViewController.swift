//
//  ContactViewController.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/16/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

class ContactViewController: UIViewController {

  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var callTitleLabel: UILabel!
  @IBOutlet weak var callDescriptionLabel: UILabel!
  @IBOutlet weak var businessQuestionTitleLabel: UILabel!
  @IBOutlet weak var businessQuestionDescriptionLabel: UILabel!
  @IBOutlet weak var artQuestionTitleLabel: UILabel!
  @IBOutlet weak var artQuestionDescriptionLabel: UILabel!
  @IBOutlet weak var callHotlineButton: UIButton!
  @IBOutlet weak var emailUsButton: UIButton!
  @IBOutlet weak var emailArtButton: UIButton!

  let viewModel = ContactViewModel()

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
    //TODO: setup view
  }

  private func applyTheme() {
    //TODO: apply theme
  }
}

extension ContactViewController {
  static func instance() -> ContactViewController {
    return Storyboard.Information.instantiate(ContactViewController.self)
  }
}
