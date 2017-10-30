//
//  ViewController+Utilities.swift
//  Movimenta
//
//  Created by Marwan  on 7/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

extension UIViewController {
  public static var defaultNib: String {
    return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
  }
  
  public static var storyboardIdentifier: String {
    return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
  }
  
  func presentShareSheet(with shareContent: [Any]) {
    let activityViewController = UIActivityViewController(activityItems: shareContent, applicationActivities: nil)
    present(activityViewController, animated: true, completion: nil)
  }
  
  func add(asChildViewController viewController: UIViewController, toView view: UIView) -> UIView {
    guard let childView = viewController.view else {
      return UIView()
    }
    // Add Child View Controller
    addChildViewController(viewController)
    // Add Child View As Subview
    view.addSubview(childView)
    // Notify Child View Controller
    viewController.didMove(toParentViewController: self)
    return childView
  }
  
  func remove(asChildViewController viewController: UIViewController) {
    // Notify Child View Controller
    viewController.willMove(toParentViewController: nil)
    // Remove Child View From Superview
    viewController.view.removeFromSuperview()
    // Notify Child View Controller
    viewController.removeFromParentViewController()
  }
  
  func showNavigationBarShadow() {
    self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    self.navigationController?.navigationBar.shadowImage = nil
  }
  
  func hideNavigationBarShadow() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
  }

  var ancestor: UIViewController {
    return UIViewController.ancestor(viewController: self)
  }
  
  static func ancestor(viewController: UIViewController) -> UIViewController {
    if let parent = viewController.parent {
      return ancestor(viewController: parent)
    }
    return viewController
  }
}
