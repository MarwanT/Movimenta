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

  let viewModel = AboutViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //MARK: [Analytics] Screen Name
    Analytics.shared.send(screenName: Analytics.ScreenNames.About)
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
    //Note: Must be called after both the text and initial style has been set.
    setupAttributedLabels()

    //Addtional needed setup
    let theme = ThemeManager.shared.current

    contentView.layoutMargins = UIEdgeInsets(
      top: 0, left: CGFloat(theme.space7),
      bottom: 0, right: CGFloat(theme.space7))
    
    navigationItem.backBarButtonItem = UIBarButtonItem.back
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

  private func setupAttributedLabels() {
    let theme = ThemeManager.shared.current

    let linkAttributes = [
      NSForegroundColorAttributeName: theme.color2
    ]

    informationLabel.linkAttributes = linkAttributes

    let delimiter = "•"
    let text = informationLabel.text ?? ""
    let ranges = informationLabel.text?.rangesOfStringSurrounded(by: delimiter)
    guard let firstRange = ranges?.first else {
      //Fail If we found more than one range.
      return
    }
    //Remove link delimiter
    informationLabel.text = text.replacingOccurrences(of: delimiter, with: "")
    let rangeWithoutDelimiters = NSRange.init(location: firstRange.location - 1, length: firstRange.length - 1)
    //TODO: We might need this to be in fr / en
    informationLabel.addLink(to: viewModel.developerUrl, with: rangeWithoutDelimiters)
    informationLabel.delegate = self
  }

}

//MARK: Link Action
extension AboutViewController: TTTAttributedLabelDelegate {
  public func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
    WebViewController.present(url: url.absoluteString, inViewController: navigationController)
  }
}

extension AboutViewController {
  static func instance() -> AboutViewController {
    return Storyboard.Information.instantiate(AboutViewController.self)
  }
}
