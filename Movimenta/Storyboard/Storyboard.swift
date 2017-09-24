//
//  Storyboard.swift
//  Movimenta
//
//  Created by Marwan  on 7/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

enum Storyboard: String {
  case Root
  case Event
  case Filter
  case Information
  case Venue
  
  public func instantiate<VC: UIViewController>(_ viewController: VC.Type,
                          inBundle bundle: Bundle? = nil) -> VC {
    guard let vc = UIStoryboard(name: self.rawValue, bundle: bundle).instantiateViewController(withIdentifier: VC.storyboardIdentifier) as? VC else {
      fatalError("Couldn't instantiate \(VC.storyboardIdentifier) from \(self.rawValue)")
    }
    return vc
  }
}
