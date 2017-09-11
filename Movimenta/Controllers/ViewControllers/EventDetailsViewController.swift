//
//  EventDetailsViewController.swift
//  Movimenta
//
//  Created by Marwan  on 8/8/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import EventKit
import EventKitUI
import SDWebImage
import UIKit

class EventDetailsViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  fileprivate var headerView: EventDetailsHeaderView!
  fileprivate var eventDetailsLabel: ParallaxLabel!
  fileprivate var bookmarkBarButton: UIBarButtonItem!
  
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
    resizeHeaderView()
  }
  
  private func setup() {
    setupTableView()
    setupNavigationItems()
  }
  
  private func setupTableView() {
    let theme = ThemeManager.shared.current
    
    headerView = EventDetailsHeaderView.instanceFromNib()
    headerView.delegate = self
    eventDetailsLabel = ParallaxLabel.instanceFromNib()
    eventDetailsLabel.layoutMargins = UIEdgeInsets(
      top: CGFloat(theme.space8), left: CGFloat(theme.space7),
      bottom: CGFloat(theme.space8), right: CGFloat(theme.space7))
    tableView.tableHeaderView = getHeaderView()
    
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
    
    tableView.separatorStyle = .singleLine
    tableView.separatorColor = theme.separatorColor
    
    tableView.register(TableViewSectionHeader.nib, forHeaderFooterViewReuseIdentifier: TableViewSectionHeader.identifier)
    tableView.register(DateTimeCell.nib, forCellReuseIdentifier: DateTimeCell.identifier)
    tableView.register(VenueCell.nib, forCellReuseIdentifier: VenueCell.identifier)
    tableView.register(ParticipantCell.nib, forCellReuseIdentifier: ParticipantCell.identifier)
  }
  
  private func setupNavigationItems() {
    let shareBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(tapShareButton(_:)))
    bookmarkBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "bookmarkOutline"), style: .plain, target: self, action: #selector(tapBookmarkButton(_:)))
    navigationItem.rightBarButtonItems = [shareBarButton, bookmarkBarButton]
  }
  
  private func loadData() {
    refreshBookmarkButton()
    loadHeaderViewData()
    loadAdditionalDetailsData()
  }
  
  fileprivate func refreshBookmarkButton() {
    if viewModel.isBookmarked {
      bookmarkBarButton.image = #imageLiteral(resourceName: "bookmarkFilled")
    } else {
      bookmarkBarButton.image = #imageLiteral(resourceName: "bookmarkOutline")
    }
  }
  
  private func loadHeaderViewData() {
    headerView.loadView(with:
      (image: viewModel.image,
       title: viewModel.title,
       categories: viewModel.categoriesLabel,
       participants: viewModel.participantsLabel,
       description: viewModel.description))
    eventDetailsLabel.set(text: Strings.event_details())
    resizeHeaderView()
  }
  
  private func loadAdditionalDetailsData() {
    tableView.reloadData()
  }
  
  fileprivate func resizeHeaderView(size: CGSize? = nil) {
    let chosenSize: CGSize = size != nil ? size! : tableHeaderPreferredSize
    tableView.tableHeaderView?.frame.size = chosenSize
    tableView.reloadData()
  }
  
  private func getHeaderView() -> UIView {
    let view = UIView(frame: CGRect.zero)
    view.addSubview(headerView)
    view.addSubview(eventDetailsLabel)
    view.backgroundColor = UIColor.red
    headerView.snp.makeConstraints { (maker) in
      maker.left.top.right.equalTo(view)
      maker.bottom.equalTo(eventDetailsLabel.snp.top)
    }
    eventDetailsLabel.snp.makeConstraints { (maker) in
      maker.left.bottom.right.equalTo(view)
    }
    return view
  }
  
  fileprivate var tableHeaderPreferredSize: CGSize {
    return CGSize(
      width: view.frame.width,
      height: headerView.preferredSize().height + eventDetailsLabel.preferredSize().height)
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
    guard let section = Section(rawValue: indexPath.section),
      let values = viewModel.values(for: indexPath) else {
      return UITableViewCell()
    }
    switch section {
    case .dates:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTimeCell.identifier, for: indexPath) as? DateTimeCell, let value = values as? DateRange else {
        return UITableViewCell()
      }
      cell.set(dateTime: value)
      return cell
    case .venue:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: VenueCell.identifier, for: indexPath) as? VenueCell, let values = values as? EventVenueInfo else {
        return UITableViewCell()
      }
      cell.set(title: values.title, location: values.location)
      return cell
    case .participants:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: ParticipantCell.identifier, for: indexPath) as? ParticipantCell, let values = values as? EventParticipantInfo else {
        return UITableViewCell()
      }
      cell.set(imageURL: values.imageURL, name: values.name, role: values.role)
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard
      let section = Section(rawValue: section),
      let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewSectionHeader.identifier) as? TableViewSectionHeader,
      viewModel.numberOfRows(in: section) > 0 else {
        return nil
    }
    headerView.text = viewModel.headerViewTitle(for: section)
    
    switch section {
    case .dates:
      headerView.separatorMargins = UIEdgeInsets.zero
    case .venue, .participants:
      headerView.separatorMargins = UIEdgeInsets(
        top: 0, left: CGFloat(ThemeManager.shared.current.space7),
        bottom: 0, right: 0)
    }
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard let section = Section(rawValue: section) else {
      return 0
    }
    
    if viewModel.numberOfRows(in: section) > 0 {
      return UITableViewAutomaticDimension
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    guard let section = Section(rawValue: indexPath.section) else {
      return
    }
    
    switch section {
    case .dates:
      addToCalendar(dateAt: indexPath)
    case .venue:
      return
    case .participants:
      navigateToParticipantVC(for: indexPath)
    }
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

//MARK: Actions
extension EventDetailsViewController {
  func tapShareButton(_ sender: UIBarButtonItem) {
    guard let info = viewModel.sharingContent() else {
      return
    }
    shareEvent(info: info)
  }
  
  func tapBookmarkButton(_ sender: UIBarButtonItem) {
    toggleBookmark()
  }
  
  private func shareEvent(info: [Any]) {
    presentShareSheet(with: info)
  }
  
  private func toggleBookmark() {
    viewModel.toggleBookmark()
    refreshBookmarkButton()
  }
  
  fileprivate func addToCalendar(dateAt indexPath: IndexPath) {
    guard let info = viewModel.calendarEventDetails(for: indexPath) else {
      return
    }
    
    let authotizationStatus = EKEventStore.authorizationStatus(for: EKEntityType.event)
    switch authotizationStatus {
    case .authorized:
      addToCalendar(eventWith: info)
    case .notDetermined:
      requestCalendarAccess(completion: { (authorized) in
        if authorized {
          self.addToCalendar(eventWith: info)
        }
      })
    case .denied, .restricted:
      showAlertForNoEventStoreAuthorization()
      return
    }
  }
  
  private func requestCalendarAccess(completion: @escaping (_ authorized: Bool) -> Void) {
    let eventStore = EKEventStore()
    eventStore.requestAccess(to: .event) { (success, error) in
      completion(success)
    }
  }
  
  private func addToCalendar(eventWith info: CalendarEventInfo) {
    let eventStore = EKEventStore()
    
    let calendarEvent = EKEvent(eventStore: eventStore)
    calendarEvent.title = info.title
    calendarEvent.url = info.url
    calendarEvent.location = info.location
    calendarEvent.notes = info.note
    calendarEvent.startDate = info.startDate
    calendarEvent.endDate = info.endDate
    
    // prompt user to add event (to whatever calendar they want)
    let eventEditController = EKEventEditViewController()
    eventEditController.event = calendarEvent
    eventEditController.eventStore = eventStore
    eventEditController.editViewDelegate = self
    present(eventEditController, animated: true, completion: nil)
  }
  
  private func showAlertForNoEventStoreAuthorization() {
    let alertController = UIAlertController(
      title: Strings.no_event_store_authorization_title(),
      message: Strings.no_event_store_authorization_message(),
      preferredStyle: .alert)
    alertController.addAction(UIAlertAction.settingsAction())
    alertController.addAction(UIAlertAction.cancelAction(handler: nil))
    present(alertController, animated: true, completion: nil)
  }
  
  fileprivate func navigateToVenueDetailsVC(for indexPath: IndexPath) {
    guard let venue = viewModel.venue(for: indexPath) else {
      return
    }
    navigateToVenueDetailsVC(venue: venue)
  }
  
  private func navigateToVenueDetailsVC(venue: Venue) {
    //TODO: navigate to venue details vc
  }
  
  fileprivate func navigateToParticipantVC(for indexPath: IndexPath) {
    navigateToParticipantVC(participant: viewModel.participant(for: indexPath))
  }
  
  private func navigateToParticipantVC(participant: Participant) {
    //TODO: navigate to participant vc
  }
}

//MARK: - EventDetailsHeaderViewDelegate
extension EventDetailsViewController: EventDetailsHeaderViewDelegate {
  func eventDetailsHeaderDidChangeSize(_ headerView: EventDetailsHeaderView, size: CGSize) {
    resizeHeaderView()
  }
}

//MARK: - EKEventEditViewDelegate
extension EventDetailsViewController: EKEventEditViewDelegate {
  func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
    dismiss(animated: true, completion: nil)
  }
}