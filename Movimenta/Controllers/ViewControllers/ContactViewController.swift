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
    //localize data
    callTitleLabel.text = Strings.hotline_title()
    callDescriptionLabel.text = Strings.hotline_description()
    businessQuestionTitleLabel.text = Strings.business_questions_title()
    businessQuestionDescriptionLabel.text = Strings.business_description()
    artQuestionTitleLabel.text = Strings.art_questions_title()
    artQuestionDescriptionLabel.text = Strings.art_description()
    emailUsButton.setTitle(Strings.email(), for: .normal)
    emailArtButton.setTitle(Strings.email(), for: .normal)
    callHotlineButton.setTitle(Strings.call(), for: .normal)

    //Addtional needed setup
  }

  private func applyTheme() {
    let theme = ThemeManager.shared.current

    //set fonts
    callTitleLabel.font = theme.font4
    callDescriptionLabel.font = theme.font6
    businessQuestionTitleLabel.font = theme.font4
    businessQuestionDescriptionLabel.font = theme.font6
    artQuestionTitleLabel.font = theme.font4
    artQuestionDescriptionLabel.font = theme.font6
    //set colors
    callTitleLabel.textColor = theme.darkTextColor
    callDescriptionLabel.textColor = theme.darkTextColor
    businessQuestionTitleLabel.textColor = theme.darkTextColor
    businessQuestionDescriptionLabel.textColor = theme.darkTextColor
    artQuestionTitleLabel.textColor = theme.darkTextColor
    artQuestionDescriptionLabel.textColor = theme.darkTextColor
  }
}

extension ContactViewController {
  static func instance() -> ContactViewController {
    return Storyboard.Information.instantiate(ContactViewController.self)
  }
}
