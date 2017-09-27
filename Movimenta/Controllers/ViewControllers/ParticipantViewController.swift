//
//  ParticipantViewController.swift
//  Movimenta
//
//  Created by Marwan  on 9/11/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class ParticipantViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  fileprivate var headerView: ParticipantDetailsHeaderView!
  fileprivate var eventDetailsLabel: ParallaxLabel!
  
  var viewModel = ParticipantViewModel()
  
  static func instance() -> ParticipantViewController {
    return Storyboard.Event.instantiate(ParticipantViewController.self)
  }
  
  deinit {
    unregisterToNotificationCenter()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    // #Required for the headerView to take the required size of it's content
    resizeHeaderView()
  }
  
  func initialize(with participant: Participant) {
    viewModel.initialize(with: participant)
  }
  
  private func initialize() {
    initializeTitle()
    initializeTableView()
    initializeNavigationItems()
    registerToNotificationCenter()
    loadData()
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
  
  private func initializeTitle() {
    title = viewModel.viewControllerTitle
  }
  
  private func initializeNavigationItems() {
    let shareBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(tapShareButton(_:)))
    navigationItem.rightBarButtonItem = shareBarButton
    navigationItem.backBarButtonItem = UIBarButtonItem.back
  }
  
  private func initializeTableViewHeader() {
    let theme = ThemeManager.shared.current
    
    headerView = ParticipantDetailsHeaderView.instanceFromNib()
    headerView.delegate = self
    eventDetailsLabel = ParallaxLabel.instanceFromNib()
    eventDetailsLabel.layoutMargins = UIEdgeInsets(
      top: CGFloat(theme.space8), left: CGFloat(theme.space7),
      bottom: CGFloat(theme.space8), right: CGFloat(theme.space7))
    let separatorView = UIView(frame: CGRect.zero)
    separatorView.backgroundColor = theme.separatorColor
    
    let view = UIView(frame: CGRect.zero)
    view.addSubview(headerView)
    view.addSubview(eventDetailsLabel)
    view.addSubview(separatorView)
    headerView.snp.makeConstraints { (maker) in
      maker.left.top.right.equalTo(view)
      maker.bottom.equalTo(eventDetailsLabel.snp.top)
    }
    eventDetailsLabel.snp.makeConstraints { (maker) in
      maker.left.right.equalTo(view)
      maker.bottom.equalTo(separatorView.snp.top)
    }
    separatorView.snp.makeConstraints { (maker) in
      maker.height.equalTo(0.5)
      maker.left.right.bottom.equalTo(view)
    }
    tableView.tableHeaderView = view
  }
  
  private func registerToNotificationCenter() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleBookmarksUpdate(_:)), name: AppNotification.didUpadteBookmarkedEvents, object: nil)
  }
  
  private func unregisterToNotificationCenter() {
    NotificationCenter.default.removeObserver(self)
  }
  
  private func loadData() {
    loadHeaderViewData()
  }
  
  private func loadHeaderViewData() {
    headerView.loadView(with:
      (image: viewModel.image,
       name: viewModel.name,
       roles: viewModel.roles,
       description: viewModel.description))
    eventDetailsLabel.set(text: Strings.related_events())
    resizeHeaderView()
  }
  
  fileprivate func resizeHeaderView(size: CGSize? = nil) {
    let chosenSize: CGSize = size != nil ? size! : tableHeaderPreferredSize
    tableView.tableHeaderView?.frame.size = chosenSize
    tableView.reloadData()
  }
  
  fileprivate var tableHeaderPreferredSize: CGSize {
    return CGSize(
      width: view.frame.width,
      height: headerView.preferredSize().height + eventDetailsLabel.preferredSize().height)
  }
  
  fileprivate func reloadRows(at indexPaths: [IndexPath]) {
    tableView.reloadRows(at: indexPaths, with: .none)
  }
}

//MARK: Actions
extension ParticipantViewController {
  func tapShareButton(_ sender: UIBarButtonItem) {
    guard let info = viewModel.sharingContent() else {
      return
    }
    shareParticipant(info: info)
  }
  
  private func shareParticipant(info: [Any]) {
    presentShareSheet(with: info)
  }
  
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

//MARK: Header View Delegates
extension ParticipantViewController: ParticipantDetailsHeaderViewDelegate {
  func participantDetailsHeaderDidChangeSize(_ headerView: ParticipantDetailsHeaderView, size: CGSize) {
    resizeHeaderView()
  }
}

//MARK: Table View Delegates
extension ParticipantViewController: UITableViewDelegate, UITableViewDataSource {
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
extension ParticipantViewController: EventCellDelegate {
  func eventCellDidTapBookmarkButton(_ cell: EventCell) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    viewModel.toggleEventBookmarkStatus(at: indexPath)
  }
}
