//
//  Color+Utils.swift
//  Movimenta
//
//  Created by Marwan  on 8/1/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

extension UIColor {
  func image(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
    return UIImage(color: self, size: size)
  }
}


