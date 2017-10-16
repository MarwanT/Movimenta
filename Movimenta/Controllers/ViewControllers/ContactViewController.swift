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
  @IBOutlet weak var businessQuestionTitleLabel: UILabel!
  @IBOutlet weak var artQuestionTitleLabel: UILabel!
  @IBOutlet weak var emailUsButton: UIButton!
  @IBOutlet weak var emailArtButton: UIButton!

  let viewModel = ContactViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //MARK: [Analytics] Screen Name
    Analytics.shared.send(screenName: Analytics.ScreenNames.Contact)
  }

  private func initialize() {
    //All Initializations and Setup
    applyTheme()
    setupView()
  }

  private func setupView() {
    //localize data
    businessQuestionTitleLabel.text = Strings.business_questions_title()
    artQuestionTitleLabel.text = Strings.art_questions_title()
    emailUsButton.setTitle(Strings.email(), for: .normal)
    emailArtButton.setTitle(Strings.email(), for: .normal)

    //Addtional needed setup
    let theme = ThemeManager.shared.current

    contentView.layoutMargins = UIEdgeInsets(
      top: CGFloat(theme.space8), left: CGFloat(theme.space7),
      bottom: CGFloat(theme.space8), right: CGFloat(theme.space7))

    //Setup buttons actions
    emailUsButton.addTarget(self, action: #selector(didTouchUpInsideEmailUsButton(_:)), for: UIControlEvents.touchUpInside)
    emailArtButton.addTarget(self, action: #selector(didTouchUpInsideEmailArtButton(_:)), for: UIControlEvents.touchUpInside)
    
    navigationItem.backBarButtonItem = UIBarButtonItem.back
  }

  private func applyTheme() {
    let theme = ThemeManager.shared.current

    //set fonts
    businessQuestionTitleLabel.font = theme.font4
    artQuestionTitleLabel.font = theme.font4
    //set colors
    businessQuestionTitleLabel.textColor = theme.darkTextColor
    artQuestionTitleLabel.textColor = theme.darkTextColor
    //set button styles
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
    
    //MARK: [Analytics] Event
    let analyticsEvent = Analytics.Event(category: .info, action: .sendEmail)
    Analytics.shared.send(event: analyticsEvent)
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
