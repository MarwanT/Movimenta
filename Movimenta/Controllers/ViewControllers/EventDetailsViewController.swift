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
    tableView.register(DateTimeCell.nib, forCellReuseIdentifier: DateTimeCell.identifier)
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
      return UITableViewCell()
    case .participants:
      return UITableViewCell()
    }
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

//MARK: Actions
extension EventDetailsViewController {
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
}

//MARK: - EventDetailsHeaderViewDelegate
extension EventDetailsViewController: EventDetailsHeaderViewDelegate {
  func eventDetailsHeaderDidChangeSize(_ headerView: EventDetailsHeaderView, size: CGSize) {
    resizeHeaderView(size: size)
  }
}

//MARK: - EKEventEditViewDelegate
extension EventDetailsViewController: EKEventEditViewDelegate {
  func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
    dismiss(animated: true, completion: nil)
  }
}
