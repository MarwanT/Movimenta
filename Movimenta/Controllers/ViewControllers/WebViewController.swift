//
//  WebViewController.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/16/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import SafariServices

class WebViewController {
  public static func present(url: String, inViewController: UIViewController? = nil) {
    let presenterViewController: UIViewController = inViewController != nil ? inViewController! : rootViewController
    let safariVC = SFSafariViewController(url: URL(string: url)!)
    safariVC.modalPresentationStyle = .overCurrentContext
    safariVC.modalTransitionStyle = .coverVertical
    if #available(iOS 10.0, *) {
      safariVC.preferredControlTintColor = ThemeManager.shared.current.color2
    }
    presenterViewController.present(safariVC, animated: true, completion: nil)
  }

  public static func present(url: URL!, inViewController: UIViewController? = nil) {
    let presenterViewController: UIViewController = inViewController != nil ? inViewController! : rootViewController
    let safariVC = SFSafariViewController(url: url)
    safariVC.modalPresentationStyle = .overCurrentContext
    safariVC.modalTransitionStyle = .coverVertical
    if #available(iOS 10.0, *) {
      safariVC.preferredControlTintColor = ThemeManager.shared.current.color2
    }
    presenterViewController.present(safariVC, animated: true, completion: nil)
  }

  private static var rootViewController: UIViewController {
    guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else {
      fatalError("No root view controller detected")
    }
    return rootViewController
  }
}
