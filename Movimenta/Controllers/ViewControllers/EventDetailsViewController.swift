//
//  EventDetailsViewController.swift
//  Movimenta
//
//  Created by Marwan  on 8/8/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import SDWebImage
import UIKit

class EventDetailsViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  fileprivate var headerView: EventDetailsHeaderView!
  
  var viewModel = EventDetailsViewModel()
  
  static func instance() -> EventDetailsViewController {
    return Storyboard.Event.instantiate(EventDetailsViewController.self)
  }
  
  func initialize(with event: Event) {
    viewModel.initialize(with: event)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    loadData()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    // #Required for the headerView to take the required size of it's content
    resizeHeaderView(size: headerView.preferredSize())
  }
  
  private func setup() {
    let theme = ThemeManager.shared.current
    
    headerView = EventDetailsHeaderView.instanceFromNib()
    headerView.delegate = self
    tableView.tableHeaderView = headerView
    
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    tableView.sectionHeaderHeight = UITableViewAutomaticDimension
    tableView.estimatedSectionHeaderHeight = 70
    
    tableView.layoutMargins = UIEdgeInsets(
      top: 0, left: CGFloat(theme.space7),
      bottom: 0, right: CGFloat(theme.space7))
    
    tableView.register(TableViewSectionHeader.nib, forHeaderFooterViewReuseIdentifier: TableViewSectionHeader.identifier)
  }
  
  private func loadData() {
    loadHeaderViewData()
    loadAdditionalDetailsData()
  }
  
  private func loadHeaderViewData() {
    let headerSize = headerView.loadView(with:
      (image: viewModel.image,
       title: viewModel.title,
       categories: viewModel.categoriesLabel,
       participants: viewModel.participantsLabel,
       description: viewModel.description))
    resizeHeaderView(size: headerSize)
  }
  
  private func loadAdditionalDetailsData() {
    tableView.reloadData()
  }
  
  fileprivate func resizeHeaderView(size: CGSize) {
    UIView.animate(withDuration: ThemeManager.shared.current.animationDuration) { 
      self.headerView.frame.size = size
      self.tableView.reloadData()
    }
  }
}

//MARK: Table View Delegates
extension EventDetailsViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = Section(rawValue: section) else {
      return 0
    }
    return viewModel.numberOfRows(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard
      let section = Section(rawValue: section),
      let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewSectionHeader.identifier) as? TableViewSectionHeader else {
        return nil
    }
    headerView.text = viewModel.headerViewTitle(for: section)
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
}

extension EventDetailsViewController {
  enum Section: Int {
    case dates = 0
    case venue
    case participants
    
    static var numberOfSections: Int {
      return 3
    }
  }
}

//MARK: EventDetailsHeaderViewDelegate
extension EventDetailsViewController: EventDetailsHeaderViewDelegate {
  func eventDetailsHeaderDidChangeSize(_ headerView: EventDetailsHeaderView, size: CGSize) {
    resizeHeaderView(size: size)
  }
}
