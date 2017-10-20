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

  @IBOutlet weak var aboutImageView: UIImageView!
  @IBOutlet weak var partnersImageView: UIImageView!
  @IBOutlet weak var contactImageView: UIImageView!
  @IBOutlet weak var hotelsImageView: UIImageView!
  @IBOutlet weak var restaurantsImageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //MARK: [Analytics] Screen Name
    Analytics.shared.send(screenName: Analytics.ScreenNames.Info)
  }

  private func initialize() {
    //All Initializations and Setup
    applyTheme()
    setupView()
  }

  private func setupView() {
    let theme = ThemeManager.shared.current
    
    //Localize title
    title = Strings.info()
    //Localize labels
    aboutLabel.text = Strings.info_app_title()
    aboutAppLabel.text = Strings.info_app_subtitle()
    partnersLabel.paragraph(with: Strings.partners(), lineHeight: theme.fontBook4.lineHeight, alignement: NSTextAlignment.center)
    contactLabel.paragraph(with: Strings.contact(), lineHeight: theme.fontBook4.lineHeight, alignement: NSTextAlignment.center)
    hotelsLabel.paragraph(with: Strings.hotels(), lineHeight: theme.fontBook4.lineHeight, alignement: NSTextAlignment.center)
    restaurantsLabel.paragraph(with: Strings.restaurants(), lineHeight: theme.fontBook4.lineHeight, alignement: NSTextAlignment.center)

    //Set tap listeners
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(aboutImageTapped(tapGestureRecognizer:)))
    aboutImageView.isUserInteractionEnabled = true
    aboutImageView.addGestureRecognizer(tapGestureRecognizer)

    let partnersImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(partnersImageTapped(tapGestureRecognizer:)))
    partnersImageView.isUserInteractionEnabled = true
    partnersImageView.addGestureRecognizer(partnersImageTapGestureRecognizer)

    let contactImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(contactImageTapped(tapGestureRecognizer:)))
    contactImageView.isUserInteractionEnabled = true
    contactImageView.addGestureRecognizer(contactImageTapGestureRecognizer)

    let hotelsImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hotelsImageTapped(tapGestureRecognizer:)))
    hotelsImageView.isUserInteractionEnabled = true
    hotelsImageView.addGestureRecognizer(hotelsImageTapGestureRecognizer)

    let restaurantsImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restaurantsImageTapped(tapGestureRecognizer:)))
    restaurantsImageView.isUserInteractionEnabled = true
    restaurantsImageView.addGestureRecognizer(restaurantsImageTapGestureRecognizer)
    
    navigationItem.backBarButtonItem = UIBarButtonItem.back
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

//MARK: - Actions
extension InformationViewController {

  func aboutImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
    navigationController?.pushViewController(AboutViewController.instance(), animated: true)
  }

  func contactImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
    navigationController?.pushViewController(ContactViewController.instance(), animated: true)
  }

  func hotelsImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
    let vc = InformationListingViewController.instance()
    vc.initialize(with: InformationListingViewModel.Mode.hotels)
    navigationController?.pushViewController(vc, animated: true)
  }

  func restaurantsImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
    let vc = InformationListingViewController.instance()
    vc.initialize(with: InformationListingViewModel.Mode.restaurants)
    navigationController?.pushViewController(vc, animated: true)
  }

  func partnersImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
    let vc = PartnersViewController.instance()
    navigationController?.pushViewController(vc, animated: true)
  }

}

//MARK: - Instance
extension InformationViewController {
  static func instance() -> InformationViewController {
    return Storyboard.Information.instantiate(InformationViewController.self)
  }
}
