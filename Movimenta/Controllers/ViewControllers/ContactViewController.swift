//
//  ContactViewController.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/16/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import MessageUI

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
    let theme = ThemeManager.shared.current

    contentView.layoutMargins = UIEdgeInsets(
      top: CGFloat(theme.space8), left: CGFloat(theme.space7),
      bottom: CGFloat(theme.space8), right: CGFloat(theme.space7))

    //Setup buttons actions
    emailUsButton.addTarget(self, action: #selector(didTouchUpInsideEmailUsButton(_:)), for: UIControlEvents.touchUpInside)
    emailArtButton.addTarget(self, action: #selector(didTouchUpInsideEmailArtButton(_:)), for: UIControlEvents.touchUpInside)
    callHotlineButton.addTarget(self, action: #selector(didTouchUpInsideCallUsButton(_:)), for: UIControlEvents.touchUpInside)
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
    //set button styles
    theme.stylePrimaryButton(button: callHotlineButton)
    theme.styleSecondaryButton(button: emailUsButton)
    theme.styleSecondaryButton(button: emailArtButton)
  }

  func callNumberAction(phoneNumber: String) {
    if let phoneCallURL: URL = URL(string: "telprompt://\(phoneNumber)") {
      openUrl(url: phoneCallURL)
    }
  }

  func sendEmail(email: String, body: String? = nil) {
    guard email.isValidEmail() else {
      return
    }

    if MFMailComposeViewController.canSendMail() {
      let mail = MFMailComposeViewController()
      mail.mailComposeDelegate = self
      mail.setToRecipients([email])
      mail.setMessageBody(body ?? "", isHTML: true)

      present(mail, animated: true)
    } else {
      let alertController = UIAlertController(title: Strings.send_email_failure_alert_title(), message: Strings.send_email_failure_alert_message(), preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: Strings.ok(), style: .default, handler: { (alert: UIAlertAction) in
        guard let url = URL(string: "mailto:\(email)") else {
          return
        }
        self.openUrl(url: url)
      })
      alertController.addAction(defaultAction)

      present(alertController, animated: true, completion: nil)
    }
  }

  private func openUrl(url: URL) {
    UIApplication.openUrl(url: url)
  }
}

//MARK: Mail Delegate
extension ContactViewController: MFMailComposeViewControllerDelegate {
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true)
  }
}

//MARK: Action
extension ContactViewController {
  func didTouchUpInsideCallUsButton(_ sender: UIButton) {
    callNumberAction(phoneNumber: viewModel.hotline)
  }

  func didTouchUpInsideEmailUsButton(_ sender: UIButton) {
    sendEmail(email: viewModel.businessEmail)
  }

  func didTouchUpInsideEmailArtButton(_ sender: UIButton) {
    sendEmail(email: viewModel.artBusinessEmail)
  }
}

extension ContactViewController {
  static func instance() -> ContactViewController {
    return Storyboard.Information.instantiate(ContactViewController.self)
  }
}
