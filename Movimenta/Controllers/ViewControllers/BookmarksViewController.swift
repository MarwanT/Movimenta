//
//  BookmarksViewController.swift
//  Movimenta
//
//  Created by Marwan  on 9/18/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  let selectAllItem = UIBarButtonItem(title: "Select all", style: .plain, target: nil, action: #selector(didTapSelectAllEventsItem(_:)))
  let unbookmarkItem = UIBarButtonItem(title: "Remove", style: .plain, target: nil, action: #selector(didTapUnbookmarkSelectedItem(_:)))
  
  var viewModel = BookmarksViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initializeViewController()
    initializeTableView()
    initializeNavigationItems()
    initializeToolbar()
    registerToNotificationCenter()
    refreshTableView()
  }
  
  deinit {
    unregisterToNotificationCenter()
  }
  
  private func initializeViewController() {
    title = viewModel.viewControllerTitle
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }
  
  private func initializeTableView() {
    let theme = ThemeManager.shared.current
    
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
    
    tableView.allowsMultipleSelectionDuringEditing = true
  }
  
  private func initializeNavigationItems() {
    refreshRightBarButtonItem()
  }
  
  private func initializeToolbar() {
    selectAllItem.target = self
    unbookmarkItem.target = self
    
    toolbarItems = [
      selectAllItem,
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      unbookmarkItem
    ]
    let theme = ThemeManager.shared.current
    self.navigationController?.toolbar.tintColor = theme.color2
    self.navigationController?.toolbar.barTintColor = theme.white
    self.navigationController?.toolbar.isTranslucent = false
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
  
  fileprivate func refreshRightBarButtonItem() {
    if tableView.isEditing {
      let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleEditButtonTap(_:)))
      navigationItem.rightBarButtonItem = doneBarButton
    } else {
      let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEditButtonTap(_:)))
      navigationItem.rightBarButtonItem = editBarButton
    }
  }
  
  fileprivate func refreshBottomToolbarVisibility() {
    self.navigationController?.tabBarController?.setTabBarVisible(visible: !tableView.isEditing, animated: true) {
      self.navigationController?.setToolbarHidden(!self.tableView.isEditing, animated: true)
    }
  }
}

//MARK: Actions
extension BookmarksViewController {
  func handleBookmarksUpdate(_ sender: Notification) {
    refreshTableView()
  }
  
  func handleEditButtonTap(_ sender: UIBarButtonItem) {
  }
  
  func didTapSelectAllEventsItem(_ sender: UIBarButtonItem) {
  }
  
  func didTapUnbookmarkSelectedItem(_ sender: UIBarButtonItem) {
  }
}

//MARK: Table View Controller
extension BookmarksViewController: UITableViewDelegate, UITableViewDataSource {
  fileprivate func refreshTableView() {
    viewModel.loadEvents()
    tableView.reloadData()
  }
  
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
}

//MARK: Event Cell Delegates
extension BookmarksViewController: EventCellDelegate {
  func eventCellDidTapBookmarkButton(_ cell: EventCell) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    viewModel.toggleEventBookmarkStatus(at: indexPath)
  }
}

//MARK: Instance
extension BookmarksViewController {
  static func instance() -> BookmarksViewController {
    return Storyboard.Event.instantiate(BookmarksViewController.self)
  }
}

//MARK: - Table View Extension
extension UITableView {
  fileprivate func selectVisibleRows(_ animation: UITableViewRowAnimation = .none) {
    guard let indexPaths = indexPathsForVisibleRows else {
      return
    }
    for indexPath in indexPaths {
      selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
  }
  
  fileprivate func unSelectVisibleRows(_ animation: UITableViewRowAnimation = .none) {
    guard let indexPaths = indexPathsForVisibleRows else {
      return
    }
    for indexPath in indexPaths {
      deselectRow(at: indexPath, animated: false)
    }
  }
}
