//
//  TableViewSectionHeader.swift
//  Movimenta
//
//  Created by Marwan  on 8/14/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class TableViewSectionHeader: UITableViewHeaderFooterView {
  static let identifier: String = TableViewSectionHeader.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
  @IBOutlet weak var label: UILabel!
  
}
