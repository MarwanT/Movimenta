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
  @IBOutlet weak var datesActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var eventsActivityIndicator: UIActivityIndicatorView!
  
  fileprivate let noScheduledEventsView = NoScheduledEventsView.instanceFromNib()
  
  fileprivate let animationDuration = ThemeManager.shared.current.animationDuration
  
  var viewModel = ScheduleViewModel()
  
  fileprivate var isLoaded: Bool = false
  
  static func instance() -> ScheduleViewController {
    return Storyboard.Event.instantiate(ScheduleViewController.self)
  }
  
  deinit {
    unregisterToNotificationCenter()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isLoaded = true
    initializeTitle()
    initializeActivityIndicators()
    initializeNavigationItems()
    initializeCollectionView()
    initializeTableView()
    initializeNoScheduledEventsView()
    reloadData(reloadView: true)
    registerToNotificationCenter()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    hideNavigationBarShadow()
    
    //MARK: [Analytics] Screen Name
    Analytics.shared.send(screenName: Analytics.ScreenNames.Schedule)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    navigateToSelectedDate()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    showNavigationBarShadow()
  }
  
  private func initializeTitle() {
    title = viewModel.viewControllerTitle
  }
  
  private func initializeNavigationItems() {
    navigationItem.backBarButtonItem = UIBarButtonItem.back
  }
  
  private func initializeActivityIndicators() {
    let theme = ThemeManager.shared.current
    datesActivityIndicator.color = theme.white
    eventsActivityIndicator.color = theme.color2
    eventsActivityIndicator.isHidden = true
  }
  
  private func initializeCollectionView() {
    // Featured Content View
    let interItemSpacing: CGFloat = 10
    let contentInset = UIEdgeInsets(
      top: 0, left: CGFloat(ThemeManager.shared.current.space7),
      bottom: 0, right: CGFloat(ThemeManager.shared.current.space7))
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
    if #available(iOS 10.0, *) {
      flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
    } else {
      flowLayout.itemSize = CGSize(width: 80, height: 44)
    }
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
  
  private func initializeNoScheduledEventsView() {
    view.insertSubview(noScheduledEventsView, belowSubview: eventsActivityIndicator)
    noScheduledEventsView.snp.makeConstraints { (maker) in
      maker.edges.equalTo(self.eventsTableView)
    }
  }
  
  private func registerToNotificationCenter() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleBookmarksUpdate(_:)), name: AppNotification.didUpadteBookmarkedEvents, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleReloadedData(_:)), name: AppNotification.didLoadData, object: nil)
  }
  
  private func unregisterToNotificationCenter() {
    NotificationCenter.default.removeObserver(self)
  }
  
  fileprivate func navigateToSelectedDate() {
    if viewModel.hasDates {
      datesCollectionView.scrollToItem(at: viewModel.selectedItemIndexPath, at: .centeredHorizontally, animated: true)
    }
  }
  
  //MARK: Reload Data
  
  /// Reload dates and events
  fileprivate func reloadData(reloadView: Bool = false) {
    activityIndicators(activate: true)
    viewModel.refreshDates {
      self.activityIndicators(activate: false)
      if reloadView {
        self.reloadDatesView()
        self.navigateToSelectedDate()
      }
      // Reload events too
      self.reloadEventsData(reloadView: reloadView)
    }
  }
  
  fileprivate func reloadEventsData(reloadView: Bool = false) {
    viewModel.refreshEvents()
    if reloadView {
      reloadEventsView()
    }
  }
  
  //MARK: Reload Views
  fileprivate func reloadDatesView() {
    if isLoaded {
      datesCollectionView.reloadData()
    }
  }
  
  fileprivate func reloadEventsView() {
    if isLoaded {
      eventsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
      if viewModel.hasEvents {
        eventsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
      }
    }
  }
  
  fileprivate func reloadRows(at indexPaths: [IndexPath]) {
    guard let eventsTableView = eventsTableView,
      var indexPathsForVisibleRows = eventsTableView.indexPathsForVisibleRows else {
      return
    }
    
    indexPathsForVisibleRows = indexPathsForVisibleRows.filter { (indexPath) -> Bool in
      return indexPaths.contains(indexPath)
    }
    eventsTableView.reloadRows(at: indexPathsForVisibleRows, with: .none)
  }
  
  fileprivate func showNoScheduledEventsView() {
    noScheduledEventsView.isHidden = false
    noScheduledEventsView.alpha = 0
    UIView.animate(withDuration: animationDuration, animations: {
      self.noScheduledEventsView.alpha = 1
    })
  }
  
  fileprivate func hideNoScheduledEventsView() {
    UIView.animate(withDuration: animationDuration, animations: {
      self.noScheduledEventsView.alpha = 0
    }, completion: { (finished) in
      self.noScheduledEventsView.isHidden = true
    })
  }
  
  func refreshViewForNumberOfVisibleEvents() {
    if viewModel.numberOfRows > 0 {
      hideNoScheduledEventsView()
    } else {
      showNoScheduledEventsView()
    }
  }
  
  fileprivate func showNavigationBarShadow() {
    self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    self.navigationController?.navigationBar.shadowImage = nil
  }
  
  fileprivate func hideNavigationBarShadow() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
  }
  
//  fileprivate
  
  fileprivate func activityIndicators(activate: Bool) {
    guard datesActivityIndicator != nil,
      eventsActivityIndicator != nil else {
      return
    }
    
    if activate {
      datesActivityIndicator.startAnimating()
      datesActivityIndicator.isHidden = false
//      eventsActivityIndicator.startAnimating()
//      eventsActivityIndicator.isHidden = false
    } else {
      datesActivityIndicator.stopAnimating()
      datesActivityIndicator.isHidden = true
//      eventsActivityIndicator.stopAnimating()
//      eventsActivityIndicator.isHidden = true
    }
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
  
  func handleReloadedData(_ sender: Notification) {
    reloadData()
  }
  
  func navigateToEventDetailsViewController(event: Event) {
    let vc = EventDetailsViewController.instance()
    vc.initialize(with: event)
    navigationController?.pushViewController(vc, animated: true)
    
    //MARK: [Analytics] Event
    let analyticsEvent = Analytics.Event(
      category: .events, action: .goToEventDetails, name: event.title ?? "")
    Analytics.shared.send(event: analyticsEvent)
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
    reloadEventsData(reloadView: true)
    navigateToSelectedDate()
    
    //MARK: [Analytics] Event
    let analyticsEvent = Analytics.Event(
      category: .schedule, action: .goToDate, name: viewModel.selectedDate?.formattedDate() ?? "")
    Analytics.shared.send(event: analyticsEvent)
  }
}

//MARK: Table View Delegates
extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    refreshViewForNumberOfVisibleEvents()
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
