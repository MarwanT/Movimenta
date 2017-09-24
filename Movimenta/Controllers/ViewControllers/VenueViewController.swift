//
//  VenueViewController.swift
//  Movimenta
//
//  Created by Marwan  on 9/21/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import SnapKit
import UIKit

class VenueViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  fileprivate var headerView: VenueDetailsHeaderView!
  fileprivate var hostedEventsLabel: ParallaxLabel!
  
  var viewModel = VenueViewModel()
  
  deinit {
    unregisterToNotificationCenter()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
    registerToNotificationCenter()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    // #Required for the headerView to take the required size of it's content
    resizeHeaderView()
  }
  
  func initialize(with venue: Venue) {
    viewModel.initialize(with: venue)
  }
  
  private func initialize() {
    initializeViewController()
    initializeTableView()
    initializeNavigationItems()
    loadData()
  }
  
  private func initializeViewController() {
    title = viewModel.viewControllerTitle
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
    let theme = ThemeManager.shared.current
    
    headerView = VenueDetailsHeaderView.instanceFromNib()
    headerView.delegate = self
    hostedEventsLabel = ParallaxLabel.instanceFromNib()
    hostedEventsLabel.layoutMargins = UIEdgeInsets(
      top: CGFloat(theme.space8), left: CGFloat(theme.space7),
      bottom: CGFloat(theme.space8), right: CGFloat(theme.space7))
    let separatorView = UIView(frame: CGRect.zero)
    separatorView.backgroundColor = theme.separatorColor
    
    let view = UIView(frame: CGRect.zero)
    view.addSubview(headerView)
    view.addSubview(hostedEventsLabel)
    view.addSubview(separatorView)
    headerView.snp.makeConstraints { (maker) in
      maker.left.top.right.equalTo(view)
      maker.bottom.equalTo(hostedEventsLabel.snp.top)
    }
    hostedEventsLabel.snp.makeConstraints { (maker) in
      maker.left.right.equalTo(view)
      maker.bottom.equalTo(separatorView.snp.top)
    }
    separatorView.snp.makeConstraints { (maker) in
      maker.height.equalTo(0.5)
      maker.left.right.bottom.equalTo(view)
    }
    tableView.tableHeaderView = view
  }
  
  func initializeNavigationItems() {
    let shareBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(tapShareButton(_:)))
    navigationItem.rightBarButtonItem = shareBarButton
  }
  
  private func registerToNotificationCenter() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleBookmarksUpdate(_:)), name: AppNotification.didUpadteBookmarkedEvents, object: nil)
  }
  
  private func unregisterToNotificationCenter() {
    NotificationCenter.default.removeObserver(self)
  }
  
  fileprivate func loadData() {
    loadHeaderViewData()
  }
  
  private func loadHeaderViewData() {
    headerView.loadView(with:
      (venueImages: viewModel.venueImages,
       mapImageURL: viewModel.mapImageURL,
       name: viewModel.name,
       address: viewModel.address)
    )
    hostedEventsLabel.set(text: Strings.hosted_events())
    resizeHeaderView()
  }
  
  func navigateToEventDetailsViewController(event: Event) {
    let vc = EventDetailsViewController.instance()
    vc.initialize(with: event)
    navigationController?.pushViewController(vc, animated: true)
  }
  
  fileprivate func shareParticipant(info: [Any]) {
    presentShareSheet(with: info)
  }
}

//MARK: Helpers
extension VenueViewController {
  fileprivate func resizeHeaderView(size: CGSize? = nil) {
    let chosenSize: CGSize = size != nil ? size! : tableHeaderPreferredSize
    tableView.tableHeaderView?.frame.size = chosenSize
    tableView.reloadData()
  }
  
  fileprivate var tableHeaderPreferredSize: CGSize {
    return CGSize(
      width: view.frame.width,
      height: headerView.preferredSize().height + hostedEventsLabel.preferredSize().height)
  }
}

//MARK: Actions
extension VenueViewController {
  func tapShareButton(_ sender: UIBarButtonItem) {
    guard let info = viewModel.sharingContent() else {
      return
    }
    shareParticipant(info: info)
  }
  
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

//MARK: Header View Delegate
extension VenueViewController: VenueDetailsHeaderViewDelegate {
  var venueDetailsHeaderParentViewController: UIViewController {
    return self
  }
  
  func venueDetailsHeaderDidTapMapImage(_ view: VenueDetailsHeaderView) {
    guard let directions = viewModel.directions else {
      return
    }
    MapUtility.direction(from: directions.origin, to: directions.destination)
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
