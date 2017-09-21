//
//  VenueViewController.swift
//  Movimenta
//
//  Created by Marwan  on 9/21/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class VenueViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel = VenueViewModel()
  
  deinit {
    unregisterToNotificationCenter()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
    registerToNotificationCenter()
  }
  
  func initialize(with venue: Venue) {
    viewModel.initialize(with: venue)
  }
  
  private func initialize() {
    initializeTableView()
  }
  
  private func initializeTableView() {
    let theme = ThemeManager.shared.current
    
    initializeTableViewHeader()
    
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    
    tableView.layoutMargins = UIEdgeInsets(
      top: 0, left: CGFloat(theme.space7),
      bottom: 0, right: CGFloat(theme.space7))
    
    tableView.separatorStyle = .singleLine
    tableView.separatorColor = theme.separatorColor
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 118, bottom: 0, right: 0)
    
    tableView.register(EventCell.nib, forCellReuseIdentifier: EventCell.identifier)
  }
  
  private func initializeTableViewHeader() {
    // TODO:
  }
  
  private func registerToNotificationCenter() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleBookmarksUpdate(_:)), name: AppNotification.didUpadteBookmarkedEvents, object: nil)
  }
  
  private func unregisterToNotificationCenter() {
    NotificationCenter.default.removeObserver(self)
  }
  
  func navigateToEventDetailsViewController(event: Event) {
    let vc = EventDetailsViewController.instance()
    vc.initialize(with: event)
    navigationController?.pushViewController(vc, animated: true)
  }
}

//MARK: Actions
extension VenueViewController {
  func handleBookmarksUpdate(_ sender: Notification) {
    guard let event = sender.object as? Event,
      let indexPath = viewModel.updateBookmarkStatus(of: event) else {
        return
    }
    reloadRows(at: [indexPath])
  }
}

//MARK: Table View Delegate
extension VenueViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier, for: indexPath) as? EventCell, let values = viewModel.values(for: indexPath) else {
      return UITableViewCell()
    }
    cell.delegate = self
    cell.set(imageURL: values.imageURL, date: values.date, venueName: values.venueName, eventName: values.eventName, categories: values.categories, time: values.time, isBookmarked: values.isBookmarked)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    navigateToEventDetailsViewController(event: viewModel.event(for: indexPath))
  }
  
  fileprivate func reloadRows(at indexPaths: [IndexPath]) {
    tableView.reloadRows(at: indexPaths, with: .none)
  }
}

//MARK: Event Cell Delegates
extension VenueViewController: EventCellDelegate {
  func eventCellDidTapBookmarkButton(_ cell: EventCell) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    viewModel.toggleEventBookmarkStatus(at: indexPath)
  }
}

//MARK: Instance
extension VenueViewController {
  static func instance() -> VenueViewController {
    return Storyboard.Venue.instantiate(VenueViewController.self)
  }
}
