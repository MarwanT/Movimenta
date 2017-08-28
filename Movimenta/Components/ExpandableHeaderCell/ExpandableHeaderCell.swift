//
//  ExpandableHeaderCell.swift
//  Movimenta
//
//  Created by Marwan  on 8/28/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class ExpandableHeaderCell: UITableViewCell {
  static let identifier: String = ExpandableHeaderCell.defaultNibName
  static let nib: UINib = UINib(nibName: identifier, bundle: nil)
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var arrowImageView: UIImageView!
  
}
