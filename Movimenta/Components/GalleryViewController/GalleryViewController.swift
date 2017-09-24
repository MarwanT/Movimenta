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
  
  func initialize(with imagesURLs: [URL]) {
    pagesViewControllers = imagesURLs.map { (url) -> GalleryPageViewController in
      let vc = GalleryPageViewController.instance()
      vc.initialize(with: url)
      return vc
    }
    
    if let firstPageViewController = pagesViewControllers.first {
      setViewControllers([firstPageViewController], direction: .forward,
                         animated: true, completion: nil)
    }
  }
  
  private func initialize() {
    dataSource = self
    delegate = self
    view.backgroundColor = ThemeManager.shared.current.color2
  }
}

// MARK: Helpers
extension GalleryViewController {
  fileprivate var currentViewControllerIndex: Int {
    guard let currentViewController = viewControllers?.first,
      let currentViewControllerIndex = pagesViewControllers.index(of: currentViewController) else {
        return 0
    }
    return currentViewControllerIndex
  }
}

// MARK: Page View Controller Delegates
extension GalleryViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let currentViewControllerIndex = pagesViewControllers.index(of: viewController) else {
      return nil
    }
    let previousIndex = currentViewControllerIndex-1
    guard previousIndex >= 0, previousIndex < pagesViewControllers.count else {
      return nil
    }
    return pagesViewControllers[previousIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let currentViewControllerIndex = pagesViewControllers.index(of: viewController) else {
      return nil
    }
    let nextIndex = currentViewControllerIndex+1
    guard nextIndex < pagesViewControllers.count else {
      return nil
    }
    return pagesViewControllers[nextIndex]
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return pagesViewControllers.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return currentViewControllerIndex
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
