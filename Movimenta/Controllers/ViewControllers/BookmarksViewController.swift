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
  let noBookmarksView = NoBookmarksView.instanceFromNib()
  
  fileprivate let animationDuration = ThemeManager.shared.current.animationDuration
  
  fileprivate var tableViewLocked: Bool = false
  
  var viewModel = BookmarksViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initializeViewController()
    initializeTableView()
    initializeNavigationItems()
    initializeToolbar()
    initializeNoBookmarksView()
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
  
  private func initializeNoBookmarksView() {
    view.addSubview(noBookmarksView)
    noBookmarksView.snp.makeConstraints { (maker) in
      maker.edges.equalTo(self.view)
    }
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
  
  fileprivate func toggleEditingMode() {
    tableView.isEditing ? turnEditingModeOff() : turnEditingModeOn()
  }
  
  fileprivate func turnEditingModeOn() {
    // Clear Any Previous Selection
    viewModel.unSelectAll()
    tableView.setEditing(true, animated: true)
    refreshRightBarButtonItem()
    refreshBottomToolbarVisibility()
  }
  
  fileprivate func turnEditingModeOff() {
    // Clear Any Previous Selection
    viewModel.unSelectAll()
    tableView.setEditing(false, animated: true)
    refreshRightBarButtonItem()
    refreshBottomToolbarVisibility()
  }
  
  fileprivate func showNoBookmarksView() {
    noBookmarksView.isHidden = false
    noBookmarksView.alpha = 0
    UIView.animate(withDuration: animationDuration, animations: { 
      self.noBookmarksView.alpha = 1
    })
  }

  fileprivate func hideNoBookmarksView() {
    UIView.animate(withDuration: animationDuration, animations: { 
      self.noBookmarksView.alpha = 0
    }, completion: { (finished) in
      self.noBookmarksView.isHidden = true
    })
  }
}

//MARK: Actions
extension BookmarksViewController {
  func handleBookmarksUpdate(_ sender: Notification) {
    refreshTableView()
  }
  
  func handleEditButtonTap(_ sender: UIBarButtonItem) {
    toggleEditingMode()
  }
  
  func didTapSelectAllEventsItem(_ sender: UIBarButtonItem) {
    if viewModel.areAllEventsSelected {
      viewModel.unSelectAll()
      tableView.unSelectVisibleRows()
    } else {
      viewModel.selectAll()
      tableView.selectVisibleRows()
    }
  }
  
  func didTapUnbookmarkSelectedItem(_ sender: UIBarButtonItem) {
    tableViewLocked = true
    let indexPaths = viewModel.unBookmarkSelectedEvents()
    tableView.deleteRows(at: indexPaths, with: .automatic)
    tableViewLocked = false
  }
}

//MARK: Table View Controller
extension BookmarksViewController: UITableViewDelegate, UITableViewDataSource {
  fileprivate func refreshTableView() {
    if !tableViewLocked {
      viewModel.loadEvents()
      tableView.reloadData()
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfRows = viewModel.numberOfRows
    numberOfRows > 0 ? hideNoBookmarksView() : showNoBookmarksView()
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
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if viewModel.isSelected(indexPath: indexPath) {
      tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    } else {
      tableView.deselectRow(at: indexPath, animated: false)
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if !tableView.isEditing {
      tableView.deselectRow(at: indexPath, animated: true)
      navigateToEventDetailsViewController(event: viewModel.event(for: indexPath))
    } else {
      viewModel.selectEvent(at: indexPath)
    }
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    if tableView.isEditing {
      viewModel.unselectEvent(at: indexPath)
    }
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
