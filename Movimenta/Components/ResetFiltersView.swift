//
//  ResetFiltersView.swift
//  Movimenta
//
//  Created by Marwan  on 9/5/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import SnapKit
import UIKit

protocol ResetFiltersViewDelegate: class {
  func resetFiltersDidTap(_ view: ResetFiltersView)
}

class ResetFiltersView: UIView {
  let resetButton: UIButton! = UIButton(type: .system)
  
  weak var delegate: ResetFiltersViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    postInitialization()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    postInitialization()
  }
  
  private func postInitialization() {
    initializeLayout()
    initializeButton()
    applyTheme()
  }
  private func initializeLayout() {
    addSubview(resetButton)
    self.snp.makeConstraints { (maker) in
      maker.height.equalTo(60)
    }
    resetButton.snp.makeConstraints { (maker) in
      maker.edges.equalTo(self)
    }
    layoutIfNeeded()
  }
  private func initializeButton() {
    resetButton.titleLabel?.textAlignment = .center
    resetButton.setTitle(Strings.reset_all_filters().uppercased(), for: .normal)
    resetButton.addTarget(self, action: #selector(didTapResetButton(_:)), for: .touchUpInside)
  }
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    resetButton.titleLabel?.font = theme.font12
    resetButton.setTitleColor(theme.color2, for: .normal)
  }
  
  func didTapResetButton(_ sender: UIButton) {
  }
}
