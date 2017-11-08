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
  
  fileprivate(set) var isDataReady = false
  
  var selectedDate: Date? {
    guard indexOfSelectedDate < scheduleDates.count else {
      return nil
    }
    return scheduleDates[indexOfSelectedDate].date
  }
  
  func refreshDates(completion: @escaping () -> Void) {
    isDataReady = false
    DispatchQueue.global().async { 
      // Set Scheduale dates
      self.scheduleDates.removeAll()
      self.indexOfSelectedDate = 0
      let firstDate = FiltersManager.shared.firstEventDate
      let lastDate = FiltersManager.shared.lastEventDate
      let dates = firstDate.includedDates(till: lastDate)
      for (index, date) in dates.enumerated() {
        let scheduleDate = ScheduleDate(date: date)
        if scheduleDate.isToday {
          self.indexOfSelectedDate = index
        }
        self.scheduleDates.append(scheduleDate)
      }
      self.isDataReady = true
      DispatchQueue.main.async(execute: {
        completion()
      })
    }
  }
  
  var viewControllerTitle: String? {
    return Strings.schedule()
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
  
  var hasDates: Bool {
    return numberOfItems > 0
  }
  
  var isSelectedDateValid: Bool {
    return hasDates && isDataReady && indexOfSelectedDate < numberOfItems
  }
  
  func isCellSelected(at indexPath: IndexPath) -> Bool {
    return selectedItemIndexPath == indexPath
  }
}

//MARK: Events Table View Methods
extension ScheduleViewModel {
  var numberOfRows: Int {
    return events.count
  }
  
  func values(for indexPath: IndexPath) -> (imageURL: URL?, date: String?, venueName: String?, eventName: String?, categories: String?, time: String?, isBookmarked: Bool?)? {
    guard let selectedDate = selectedDate else {
      return nil
    }
    
    let event = events[indexPath.row]
    let preferredDateRange = event.preferredDateRange(for: selectedDate)
    return (imageURL: event.imageThumb,
            date: preferredDateRange?.displayedShortDate,
            venueName: event.venue?.title?.uppercased(),
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
  
  func updateBookmarkStatus(of events: [Event]) -> [IndexPath] {
    var indexPaths = [IndexPath]()
    events.forEach { (event) in
      if let indexPath =  updateBookmarkStatus(of: event) {
        indexPaths.append(indexPath)
      }
    }
    return indexPaths
  }
  
  func refreshEvents() {
    events.removeAll()
    
    guard let selectedDate = selectedDate else {
      return
    }
    let selectedDateRange = DateRange(from: selectedDate, to: selectedDate)
    events = DataManager.shared.events.filter { (event) -> Bool in
      return event.happens(in: selectedDateRange)
    }
    events.sortByTime(for: selectedDate)
  }
  
  func event(for indexPath: IndexPath) -> Event {
    return events[indexPath.row]
  }
  
  var hasEvents: Bool {
    return numberOfRows > 0
  }
}

//MARK: - Schedule Date
extension ScheduleViewModel {
  struct ScheduleDate {
    let date: Date
    fileprivate(set) var isToday: Bool
    fileprivate(set) var string: String
    
    init(date: Date) {
      self.date = date
      self.isToday = date.same(date: Date())
      self.string = isToday ? Strings.today() : date.formattedDate(format: "dd'.'MM")
    }
  }
}

//MARK: - Sort events array
extension Array where Element == Event {
  mutating func sortByTime(for selectedDate: Date) {
    self = sorted { (firstEvent, secondEvent) -> Bool in
      guard let firstEventFromDate = firstEvent.preferredDateRange(for: selectedDate)?.from,
        let secondEventFromDate = secondEvent.preferredDateRange(for: selectedDate)?.from,
        let alignedSecondEventFromDate = firstEventFromDate.cloneDate(withTimeOf: secondEventFromDate) else {
          return false
      }
      if firstEventFromDate == alignedSecondEventFromDate,
        let firstEventToDate = firstEvent.preferredDateRange(for: selectedDate)?.to,
        let secondEventToDate = secondEvent.preferredDateRange(for: selectedDate)?.to,
        let alignedSecondEventToDate = firstEventToDate.cloneDate(withTimeOf: secondEventToDate) {
        return firstEventToDate < alignedSecondEventToDate
      } else {
        return firstEventFromDate < alignedSecondEventFromDate
      }
    }
  }
}
