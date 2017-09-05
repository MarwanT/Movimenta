//
//  ResetFiltersView.swift
//  Movimenta
//
//  Created by Marwan  on 9/5/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class ResetFiltersView: UIView {
  let resetButton: UIButton! = UIButton(type: .system)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    postInitialization()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    postInitialization()
  }
  
  private func postInitialization() {
  }
}
