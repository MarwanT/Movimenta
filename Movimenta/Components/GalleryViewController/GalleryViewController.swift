//
//  GalleryViewController.swift
//  Movimenta
//
//  Created by Marwan  on 9/22/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

protocol GalleryViewControllerDelegate: class {
  func gallery(_ controller: GalleryViewController, didTap image: UIImage?, with url: URL?, at index: Int?)
}

class GalleryViewController: UIPageViewController {
  fileprivate var pagesViewControllers = [UIViewController]()
  
  weak var galleryDelegate: GalleryViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let subViews = view.subviews
    var scrollView: UIScrollView?
    var pageControl: UIPageControl?
    
    for view in subViews {
      if view is UIScrollView {
        scrollView = view as? UIScrollView
      }
      else if view is UIPageControl {
        pageControl = view as? UIPageControl
      }
    }
    
    if (scrollView != nil && pageControl != nil) {
      scrollView?.frame = view.bounds
      view.bringSubview(toFront: pageControl!)
    }
  }
  
  func initialize(with imagesURLs: [URL], placeholderImage: UIImage?) {
    pagesViewControllers = imagesURLs.map { (url) -> GalleryPageViewController in
      let vc = GalleryPageViewController.instance()
      vc.initialize(with: url, imagePlaceholder: placeholderImage)
      return vc
    }
    
    if let firstPageViewController = pagesViewControllers.first {
      setViewControllers([firstPageViewController], direction: .forward,
                         animated: true, completion: nil)
    } else {
      let vc = GalleryPageViewController.instance()
      vc.initialize(with: nil, imagePlaceholder: placeholderImage)
      setViewControllers([vc], direction: .forward, animated: true, completion: nil)
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
