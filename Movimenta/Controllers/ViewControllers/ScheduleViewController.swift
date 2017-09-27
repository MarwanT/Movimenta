//
//  ScheduleViewController.swift
//  Movimenta
//
//  Created by Marwan  on 9/13/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
  @IBOutlet weak var datesCollectionView: UICollectionView!
  @IBOutlet weak var eventsTableView: UITableView!
  
  var viewModel = ScheduleViewModel()
  
  static func instance() -> ScheduleViewController {
    return Storyboard.Event.instantiate(ScheduleViewController.self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initializeTitle()
    initializeNavigationItems()
    initializeCollectionView()
    initializeTableView()
    registerToNotificationCenter()
    navigateToSelectedDate()
    reloadEventsData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //MARK: [Analytics] Screen Name
    Analytics.shared.send(screenName: Analytics.ScreenNames.Schedule)
  }
  
  deinit {
    unregisterToNotificationCenter()
  }
  
  private func initializeTitle() {
    title = viewModel.viewControllerTitle
  }
  
  private func initializeNavigationItems() {
    navigationItem.backBarButtonItem = UIBarButtonItem.back
  }
  
  private func initializeCollectionView() {
    // Featured Content View
    let interItemSpacing: CGFloat = 10
    let contentInset = UIEdgeInsets(
      top: 0, left: CGFloat(ThemeManager.shared.current.space7),
      bottom: 0, right: CGFloat(ThemeManager.shared.current.space7))
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
    flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
    flowLayout.minimumInteritemSpacing = interItemSpacing
    datesCollectionView.collectionViewLayout = flowLayout
    datesCollectionView.register(ScheduleCell.self, forCellWithReuseIdentifier: ScheduleCell.identifier)
    datesCollectionView.dataSource = self
    datesCollectionView.delegate = self
    datesCollectionView.backgroundColor = ThemeManager.shared.current.color2
    datesCollectionView.contentInset = contentInset
    datesCollectionView.showsHorizontalScrollIndicator = false
  }
  
  private func initializeTableView() {
    let theme = ThemeManager.shared.current
    
    eventsTableView.tableFooterView = UIView(frame: CGRect.zero)
    
    eventsTableView.dataSource = self
    eventsTableView.delegate = self
    
    eventsTableView.rowHeight = UITableViewAutomaticDimension
    eventsTableView.estimatedRowHeight = 100
    
    eventsTableView.layoutMargins = UIEdgeInsets(
      top: 0, left: CGFloat(theme.space7),
      bottom: 0, right: CGFloat(theme.space7))
    
    eventsTableView.separatorStyle = .singleLine
    eventsTableView.separatorColor = theme.separatorColor
    eventsTableView.separatorInset = UIEdgeInsets(top: 0, left: 118, bottom: 0, right: 0)
    
    eventsTableView.register(EventCell.nib, forCellReuseIdentifier: EventCell.identifier)
  }
  
  private func registerToNotificationCenter() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleBookmarksUpdate(_:)), name: AppNotification.didUpadteBookmarkedEvents, object: nil)
  }
  
  private func unregisterToNotificationCenter() {
    NotificationCenter.default.removeObserver(self)
  }
  
  fileprivate func navigateToSelectedDate() {
    datesCollectionView.scrollToItem(at: viewModel.selectedItemIndexPath, at: .centeredHorizontally, animated: true)
  }
  
  fileprivate func reloadEventsData() {
    viewModel.refreshEvents()
    eventsTableView.reloadData()
  }
  
  fileprivate func reloadRows(at indexPaths: [IndexPath]) {
    eventsTableView.reloadRows(at: indexPaths, with: .none)
  }
}

//MARK: Actions
extension ScheduleViewController {
  func handleBookmarksUpdate(_ sender: Notification) {
    guard let events = sender.object as? [Event] else {
      return
    }
    let indexPaths = viewModel.updateBookmarkStatus(of: events)
    reloadRows(at: indexPaths)
  }
  
  func navigateToEventDetailsViewController(event: Event) {
    let vc = EventDetailsViewController.instance()
    vc.initialize(with: event)
    navigationController?.pushViewController(vc, animated: true)
  }
}

//MARK: Collection View Delegates
extension ScheduleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfItems
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCell.identifier, for: indexPath) as? ScheduleCell else {
      return UICollectionViewCell()
    }
    let info = viewModel.infoForCell(at: indexPath)
    cell.set(info.label, isSelected: info.isSelected)
    if info.isSelected {
      collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let info = viewModel.infoForCell(at: indexPath)
    return ScheduleCell.preferredSize(for: info.label)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.setSelected(for: indexPath)
    reloadEventsData()
    navigateToSelectedDate()
  }
}

//MARK: Table View Delegates
extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
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
extension ScheduleViewController: EventCellDelegate {
  func eventCellDidTapBookmarkButton(_ cell: EventCell) {
    guard let indexPath = eventsTableView.indexPath(for: cell) else {
      return
    }
    viewModel.toggleEventBookmarkStatus(at: indexPath)
  }
}
