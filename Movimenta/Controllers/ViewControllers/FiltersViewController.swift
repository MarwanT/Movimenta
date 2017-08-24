//
//  FiltersViewController.swift
//  Movimenta
//
//  Created by Marwan  on 8/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel = FiltersViewModel()
  
  static func instance() -> FiltersViewController {
    return Storyboard.Filter.instantiate(FiltersViewController.self)
  }
  
  func initialize(with filter: Filter) {
    viewModel.initialize(with: filter)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initializeTableView()
  }
  
  private func initializeTableView() {
    let theme = ThemeManager.shared.current
    
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.sectionHeaderHeight = UITableViewAutomaticDimension
    tableView.estimatedSectionHeaderHeight = 40
    
    tableView.layoutMargins = UIEdgeInsets(
      top: 0, left: CGFloat(theme.space7),
      bottom: 0, right: CGFloat(theme.space7))
    
    tableView.separatorStyle = .singleLine
    tableView.separatorColor = theme.separatorColor
    
    tableView.register(FiltersSectionHeader.self, forHeaderFooterViewReuseIdentifier: FiltersSectionHeader.identifier)
  }
}

//MARK: Table View Delegates
extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let section = Section(rawValue: section),
      let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FiltersSectionHeader.identifier) as? FiltersSectionHeader, section != .bookmark else {
      return nil
    }
    header.label.text = viewModel.titleForHeader(in: section)
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard let section = Section(rawValue: section) else {
      return 0
    }
    switch section {
    case .bookmark:
      return 0
    default:
      if viewModel.numberOfRows(in: section) > 0 {
        return UITableViewAutomaticDimension
      } else {
        return 0
      }
    }
  }
}

extension FiltersViewController {
  enum Section: Int {
    case dates = 0
    case types
    case withinTime
    case participants
    case withinDistance
    case bookmark
    
    static var numberOfSections: Int {
      return 6
    }
    
    var title: String? {
      switch self {
      case .dates:
        return Strings.date()
      case .types:
        return Strings.event_types()
      case .withinTime:
        return Strings.starts_within()
      case .participants:
        return Strings.participants()
      case .withinDistance:
        return Strings.distance()
      case .bookmark:
        return nil
      }
    }
  }
  
  enum DateRow: Int {
    case from = 0
    case to
    
    static var numberOfRows: Int {
      return 2
    }
  }
}
