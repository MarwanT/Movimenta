//
//  EventDetailsHeaderView.swift
//  Movimenta
//
//  Created by Marwan  on 8/14/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class EventDetailsHeaderView: UIView {
  @IBOutlet weak var detailsStackView: UIStackView!
  @IBOutlet weak var labelsContainerView: UIView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  @IBOutlet weak var participantsLabel: UILabel!
  @IBOutlet weak var descriptionLabel: ExpandableLabel!
}
