//
//  ParticipantDetailsHeaderView.swift
//  Movimenta
//
//  Created by Marwan  on 9/11/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class ParticipantDetailsHeaderView: UIView {
  typealias DetailsData = (image: URL?, name: String?, roles: String?, description: String?)
  
  @IBOutlet weak var detailsStackView: UIStackView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var labelsContainerView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var rolesLabel: UILabel!
  @IBOutlet weak var descriptionLabel: ExpandableLabel!

}
