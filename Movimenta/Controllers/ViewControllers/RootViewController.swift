//
//  RootViewController.swift
//  Movimenta
//
//  Created by Marwan  on 8/1/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import SnapKit
import UIKit

class RootViewController: UITabBarController {
  fileprivate var launchView: LaunchView!
  
  fileprivate let animationDuration = ThemeManager.shared.current.animationDuration
  
  var didDisplayLaunchView = false
  
  override var selectedViewController: UIViewController? {
    didSet {
      refreshTabItemsTitleStyle()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initializeTabBarViewControllers()
    initializeLaunchView()
    applyTheme()
    refreshTabItemsTitleStyle()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    displayLaunchViewIfNeeded()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    dismissLaunchViewAfterTimeout()
  }
  
  func initializeTabBarViewControllers() {
    let eventsMapVC = EventsMapViewController.instance()
    let bookmarksVC = BookmarksViewController.instance()
    let scheduleVC = ScheduleViewController.instance()
    let augmentedVC = AugmentedViewController.instance()
    let infoVC = InformationViewController.instance()
    
    eventsMapVC.tabBarItem = UITabBarItem(title: Strings.event_map(), image: #imageLiteral(resourceName: "pinMenuOutline"), tag: 1)
    bookmarksVC.tabBarItem = UITabBarItem(title: Strings.bookmarks(), image: #imageLiteral(resourceName: "bookmarkOutline"), tag: 2)
    scheduleVC.tabBarItem = UITabBarItem(title: Strings.schedule(), image: #imageLiteral(resourceName: "schedule"), tag: 3)
    augmentedVC.tabBarItem = UITabBarItem(title: Strings.ar(), image: #imageLiteral(resourceName: "vr"), tag: 4)
    infoVC.tabBarItem = UITabBarItem(title: Strings.info(), image: #imageLiteral(resourceName: "info"), tag: 5)
    
    viewControllers = [
      UINavigationController(rootViewController: eventsMapVC),
      UINavigationController(rootViewController: bookmarksVC),
      UINavigationController(rootViewController: scheduleVC),
      UINavigationController(rootViewController: augmentedVC),
      UINavigationController(rootViewController: infoVC)
    ]
    
    // Set Default select tab index
    self.selectedIndex = 0
  }
  
  private func initializeLaunchView() {
    launchView = LaunchView.instanceFromNib()
  }
  
  private func displayLaunchViewIfNeeded() {
    if !didDisplayLaunchView {
      view.addSubview(launchView)
      launchView.snp.makeConstraints { (maker) in
        maker.edges.equalTo(view)
      }
    }
  }
  
  private func dismissLaunchViewAfterTimeout() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      UIView.animate(withDuration: self.animationDuration, animations: {
        self.launchView.alpha = 0
      }, completion: { (_) -> Void in
        self.didDisplayLaunchView = true
        self.launchView.removeFromSuperview()
        self.launchView.alpha = 1
      })
    }
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
