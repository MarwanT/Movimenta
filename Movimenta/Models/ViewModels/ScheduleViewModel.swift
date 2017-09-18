//
//  ScheduleViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 9/14/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

final class ScheduleViewModel {
  fileprivate(set) var scheduleDates = [ScheduleDate]()
  fileprivate(set) var events = [Event]()
  fileprivate(set) var indexOfSelectedDate: Int = 0
  
  init() {
    // Set Scheduale dates
    let firstDate = FiltersManager.shared.firstEventDate
    let lastDate = FiltersManager.shared.lastEventDate
    let dates = firstDate.includedDates(till: lastDate)
    for date in dates {
      scheduleDates.append(ScheduleDate(date: date))
    }
    // Set Selected Index
    if let index = scheduleDates.index(where: { $0.isToday }) {
      indexOfSelectedDate = index
    }
  }
}

//MARK: Collection View Methods
extension ScheduleViewModel {
  var numberOfItems: Int {
    return scheduleDates.count
  }
  
  func infoForCell(at indexPath: IndexPath) -> (label: String, isSelected: Bool) {
    let scheduleDate = scheduleDates[indexPath.item]
    return (scheduleDate.string, indexPath == selectedItemIndexPath)
  }
  
  fileprivate(set) var selectedItemIndexPath: IndexPath {
    get {
      return IndexPath(item: indexOfSelectedDate, section: 0)
    }
    set {
      indexOfSelectedDate = newValue.item
    }
  }
  
  func setSelected(for indexPath: IndexPath) {
    selectedItemIndexPath = indexPath
  }
}

//MARK: Events Table View Methods
extension ScheduleViewModel {
  var numberOfRows: Int {
    return events.count
  }
  
  func values(for indexPath: IndexPath) -> (imageURL: URL?, date: String?, venueName: String?, eventName: String?, categories: String?, time: String?, isBookmarked: Bool?)? {
    guard let selectedDate = scheduleDates[indexOfSelectedDate].date else {
      return nil
    }
    
    let event = events[indexPath.row]
    let preferredDateRange = event.preferredDateRange(for: selectedDate)
    return (imageURL: event.image,
            date: preferredDateRange?.displayedShortDate,
            venueName: event.venue?.name?.uppercased(),
            eventName: event.title?.capitalized,
            categories: event.displayedCategoryLabel,
            time: preferredDateRange?.displayedShortTime,
            isBookmarked: event.isBookmarked)
  }
  
  func toggleEventBookmarkStatus(at indexPath: IndexPath) {
    let event = events[indexPath.row]
    DataManager.shared.toggleBookmarkStatus(event: event)
  }
  
  func updateBookmarkStatus(of event: Event) -> IndexPath? {
    guard let index = events.index(of: event) else {
      return nil
    }
    return IndexPath(row: index, section: 0)
  }
  
  func refreshEvents() {
    events.removeAll()
    
    guard let selectedDate = scheduleDates[indexOfSelectedDate].date else {
      return
    }
    let selectedDateRange = DateRange(from: selectedDate, to: selectedDate)
    events = DataManager.shared.events.filter { (event) -> Bool in
      return event.happens(in: selectedDateRange)
    }
  }
  
  func event(for indexPath: IndexPath) -> Event {
    return events[indexPath.row]
  }
}

//MARK: - Schedule Date
extension ScheduleViewModel {
  struct ScheduleDate {
    var date: Date?
    
    fileprivate var isToday: Bool {
      return date?.same(date: Date()) ?? false
    }
    
    var string: String {
      return isToday ? Strings.today() : date?.formattedDate(format: "dd'.'MM") ?? ""
    }
  }
}
