//
//  RootViewController.swift
//  Movimenta
//
//  Created by Marwan  on 8/1/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {
  override var selectedViewController: UIViewController? {
    didSet {
      refreshTabItemsTitleStyle()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initializeTabBarViewControllers()
    applyTheme()
    refreshTabItemsTitleStyle()
  }
  
  func initializeTabBarViewControllers() {
    let eventsMapVC = UIViewController()
    let bookmarksVC = UIViewController()
    let schedualeVC = UIViewController()
    let virtualRealityVC = UIViewController()
    let infoVC = UIViewController()
    
    eventsMapVC.tabBarItem = UITabBarItem(title: Strings.event_map(), image: #imageLiteral(resourceName: "pinMenuOutline").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "pinMenuFilled"))
    eventsMapVC.tabBarItem.tag = 1
    bookmarksVC.tabBarItem = UITabBarItem(title: Strings.bookmarks(), image: #imageLiteral(resourceName: "bookmarkOutline"), tag: 2)
    schedualeVC.tabBarItem = UITabBarItem(title: Strings.scheduale(), image: #imageLiteral(resourceName: "schedule"), tag: 3)
    virtualRealityVC.tabBarItem = UITabBarItem(title: Strings.vr(), image: #imageLiteral(resourceName: "vr"), tag: 4)
    infoVC.tabBarItem = UITabBarItem(title: Strings.info(), image: #imageLiteral(resourceName: "info"), tag: 5)
    
    viewControllers = [
      eventsMapVC,
      bookmarksVC,
      schedualeVC,
      virtualRealityVC,
      infoVC
    ]
    
    // Set Default select tab index
    self.selectedIndex = 0
  }
  
  
}

//MARK: Helpers 
extension RootViewController {
  var tabBarItemWidth: CGFloat {
    return tabBar.bounds.width/CGFloat((viewControllers?.count ?? 1))
  }
  
  var tabBarHeight: CGFloat {
    return tabBar.bounds.height
  }
}

//MARK: Instance
extension RootViewController {
  static func instance() -> RootViewController {
    return Storyboard.Root.instantiate(RootViewController.self)
  }
}

//MARK: Theme {
extension RootViewController {
  func applyTheme() {
    view.backgroundColor = ThemeManager.shared.current.defaultBackgroundColor
    tabBar.selectionIndicatorImage = ThemeManager.shared.current.tabSelectionColor.image(
      size: CGSize(width: tabBarItemWidth, height: tabBarHeight))
  }
  
  func refreshTabItemsTitleStyle() {
    guard let viewControllers = viewControllers else {
      return
    }
    
    for viewController in viewControllers {
      if viewController === selectedViewController {
        let selected: [String: AnyObject] =
          [NSFontAttributeName: ThemeManager.shared.current.font16]
        viewController.tabBarItem.setTitleTextAttributes(selected, for: .normal)
      } else {
        let normal: [String: AnyObject] =
          [NSFontAttributeName: ThemeManager.shared.current.font17]
        viewController.tabBarItem.setTitleTextAttributes(normal, for: .normal)
      }
    }
  }
}
