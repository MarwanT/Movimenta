//
//  UITableView+Utils.swift
//  Movimenta
//
//  Created by Marwan  on 9/29/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension UITableView {
  func isCellSelected(at indexPath: IndexPath) -> Bool {
    return indexPathsForSelectedRows?.contains(indexPath) ?? false
  }
}
