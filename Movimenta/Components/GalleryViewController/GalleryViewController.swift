//
//  GalleryViewController.swift
//  Movimenta
//
//  Created by Marwan  on 9/22/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class GalleryViewController: UIPageViewController {
  fileprivate var pagesViewControllers = [UIViewController]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }
  
  private func initialize() {
    dataSource = self
    delegate = self
    view.backgroundColor = ThemeManager.shared.current.color2
  }
}


// MARK: Page View Controller Delegates
extension GalleryViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let currentViewControllerIndex = pagesViewControllers.index(of: viewController) else {
      return nil
    }
      return nil
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let currentViewControllerIndex = pagesViewControllers.index(of: viewController) else {
      return nil
    }
      return nil
  }
}

//MARK: Instance
extension GalleryViewController {
  class var identifier: String {
    return "GalleryViewController"
  }
  
  class func instance() -> GalleryViewController {
    guard let vc = UIStoryboard(name: "Gallery", bundle: nil).instantiateViewController(withIdentifier: identifier) as? GalleryViewController else {
      fatalError("Couldn't instantiate \(GalleryViewController.identifier)")
    }
    return vc
  }
}
