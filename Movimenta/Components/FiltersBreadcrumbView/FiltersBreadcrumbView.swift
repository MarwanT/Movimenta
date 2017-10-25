//
//  FiltersBreadcrumbView.swift
//  Movimenta
//
//  Created by Marwan  on 9/6/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import SnapKit
import UIKit

protocol FiltersBreadcrumbViewDelegate: class {
  func filtersBreadcrumbView(_ view: FiltersBreadcrumbView, didTap breadcrumb: Breadcrumb, isShaking: Bool)
  func filtersBreadcrumbView(_ view: FiltersBreadcrumbView, didLongPress breadcrumb: Breadcrumb)
  func filtersBreadcrumbView(_ view: FiltersBreadcrumbView, didRemoveLastBreadcrumb breadcrumb: Breadcrumb)
}

class FiltersBreadcrumbView: UIView {
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var stackView: UIStackView!
  
  weak var delegate: FiltersBreadcrumbViewDelegate?
  
  var breadcrumbs: [Breadcrumb]?
  
  var configuration = Configuration()
  
  fileprivate var isShaking: Bool = false
  
  override func awakeAfter(using aDecoder: NSCoder) -> Any? {
    return viewForNibNameIfNeeded(nibName: type(of: self).defaultNibName)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    applyTheme()
  }
  
  private func applyTheme() {
    let theme = ThemeManager.shared.current
    backgroundColor = configuration.backgroundColor
    stackView.spacing = CGFloat(theme.space8)
    scrollView.contentInset = configuration.layoutMargin
    scrollView.showsHorizontalScrollIndicator = false
  }
  
  //MARK: APIs
  func setBreadcrumbs(for filter: Filter) {
    clear(animated: false)
    breadcrumbs = generateBreadcrumbInfo(for: filter)
    populateBreadcrumbs()
  }
  
  func clear(animated: Bool = true) {
    removeAllBreadcrumbViews(animated: animated)
    breadcrumbs = nil
  }
  
  private func removeAllBreadcrumbViews(animated: Bool = true) {
    let subviews = stackView.arrangedSubviews
    for subview in subviews {
      remove(breadcrumbView: subview, animated: animated)
    }
  }
  
  private func populateBreadcrumbs() {
    if let breadcrumbs = breadcrumbs {
      for breadcrumb in breadcrumbs {
        addBreadcrumbView(breadcrumb)
      }
    }
  }
  
  func remove(breadcrumbView: UIView, animated: Bool = true) {
    if animated {
      UIView.animate(withDuration: ThemeManager.shared.current.animationDuration, animations: {
        breadcrumbView.isHidden = true
      }) { (finished) in
        self.stackView.removeArrangedSubview(breadcrumbView)
        breadcrumbView.removeFromSuperview()
      }
    } else {
      self.stackView.removeArrangedSubview(breadcrumbView)
      breadcrumbView.removeFromSuperview()
    }
    
  }
  
  func remove(breadcrumb: Breadcrumb) {
    guard let index = breadcrumbs?.index(of: breadcrumb) else {
      return
    }
    let view = stackView.arrangedSubviews[index]
    remove(breadcrumbView: view)
    breadcrumbs?.remove(at: index)
    
    if breadcrumbs == nil || breadcrumbs?.count == 0 {
      delegate?.filtersBreadcrumbView(self, didRemoveLastBreadcrumb: breadcrumb)
    }
  }
  
  private func addBreadcrumbView(_ breadcrumb: Breadcrumb) {
    let label = UILabel.breadcrumb(
      backgroundColor: configuration.backgroundColor,
      foregroundColor: configuration.foregroundColor)
    label.text = breadcrumb.text.lowercased()
    stackView.addArrangedSubview(label)
    
    // Add tap Gesture recognizer
    let tapGestureRecognizer = UITapGestureRecognizer(
      target: self, action: #selector(didTapBreadcrumb(_:)))
    label.addGestureRecognizer(tapGestureRecognizer)
    
    // Add long press Gesture recognizer
    let longPressGestureRecognizer = UILongPressGestureRecognizer(
      target: self, action: #selector(didLongPressBreadcrump(_:)))
    label.addGestureRecognizer(longPressGestureRecognizer)
  }
  
  fileprivate func breadcrump(from view: UIView?) -> Breadcrumb? {
    guard let breadcrumbs = breadcrumbs,
      let breadcrumbLabel = view as? UILabel,
      let indexOfLabel = stackView.arrangedSubviews.index(of: breadcrumbLabel) else {
        return nil
    }
    return breadcrumbs[indexOfLabel]
  }
}

//MARK: Actions
extension FiltersBreadcrumbView {
  func didTapBreadcrumb(_ sender: UITapGestureRecognizer) {
    guard let breadcrumb = breadcrump(from: sender.view) else {
      return
    }
    delegate?.filtersBreadcrumbView(self, didTap: breadcrumb, isShaking: isShaking)
  }
  
  func didLongPressBreadcrump(_ sender: UITapGestureRecognizer) {
    guard let breadcrumb = breadcrump(from: sender.view) else {
      return
    }
    delegate?.filtersBreadcrumbView(self, didLongPress: breadcrumb)
  }
}

//MARK: APIs
extension FiltersBreadcrumbView {
  func shakeBreadcrumbs() {
    isShaking = true
    stackView.arrangedSubviews.forEach({ $0.shake() })
  }
  
  func stopShakingBreadcrumbs() {
    isShaking = false
    stackView.arrangedSubviews.forEach({ $0.stopShaking() })
  }
}

extension FiltersBreadcrumbView {
  fileprivate func generateBreadcrumbInfo(for filter: Filter) -> [Breadcrumb] {
    var breadcrumbs = [Breadcrumb]()
    
    if let dateRange = filter.dateRange {
      breadcrumbs.append(.dateRange(dateRange))
    }
    
    if let categories = filter.categories {
      for category in categories {
        breadcrumbs.append(.category(category))
      }
    }
    
    if let artists = filter.artists {
      for artist in artists {
        breadcrumbs.append(.artist(artist))
      }
    }
    
    if let companies = filter.companies {
      for company in companies {
        breadcrumbs.append(.company(company))
      }
    }
    
    if let organizers = filter.organizers {
      for organizer in organizers {
        breadcrumbs.append(.organizer(organizer))
      }
    }
    
    if let speakers = filter.speakers {
      for speaker in speakers {
        breadcrumbs.append(.speaker(speaker))
      }
    }
    
    if let sponsors = filter.sponsers {
      for sponsor in sponsors {
        breadcrumbs.append(.sponsor(sponsor))
      }
    }
    
    if let withinTime = filter.withinTime, withinTime != 0 {
      breadcrumbs.append(.withinTime(withinTime))
    }
    
    if let withinDistance = filter.withinDistance, withinDistance != 0 {
      breadcrumbs.append(.withinDistance(withinDistance))
    }
    
    if let showBookmarked = filter.showBookmarked, showBookmarked {
      breadcrumbs.append(.showBookmarked(showBookmarked))
    }
    
    return breadcrumbs
  }
}

//MARK: Configuration
extension FiltersBreadcrumbView {
  struct Configuration {
    var backgroundColor: UIColor = ThemeManager.shared.current.color2
    var foregroundColor: UIColor = ThemeManager.shared.current.lightTextColor
    var layoutMargin: UIEdgeInsets = UIEdgeInsets(
      top: 0, left: CGFloat(ThemeManager.shared.current.space7),
      bottom: 0, right: CGFloat(ThemeManager.shared.current.space7))
  }
}

//MARK: -
extension UILabel {
  static fileprivate func breadcrumb(backgroundColor: UIColor, foregroundColor: UIColor) -> UILabel {
    let theme = ThemeManager.shared.current
    let label = PadableLabel()
    label.isUserInteractionEnabled = true
    label.font = theme.font15
    label.backgroundColor = backgroundColor
    label.layer.borderWidth = 1
    label.layer.borderColor = foregroundColor.cgColor
    label.layer.cornerRadius = 3
    label.textColor = foregroundColor
    label.padding = UIEdgeInsets(
      top: 0, left: CGFloat(theme.space8),
      bottom: 0, right: CGFloat(theme.space8))
    label.snp.makeConstraints { (maker) in
      maker.height.equalTo(30)
    }
    return label
  }
}
