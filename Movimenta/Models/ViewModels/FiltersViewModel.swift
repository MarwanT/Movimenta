//
//  FiltersViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 8/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

final class FiltersViewModel {
  fileprivate(set) var filter: Filter! = nil
  
  fileprivate var didLoadDates = false
  fileprivate var categoriesData = [SelectableRowData]()
  fileprivate var participantsData = [SelectableRowData]()
  
  fileprivate let queue = DispatchGroup()
  
  var finishLoading: (() -> Void)?
  
  var viewControllerTitle: String {
    return Strings.filters()
  }
  
  func initialize(with filter: Filter, completion: (() -> Void)?) {
    self.filter = filter
    finishLoading = completion
    initializeDates()
    initializeCategoriesData()
    initializeParticipantsData()
    queue.notify(queue: .main) { 
      self.finishLoading?()
    }
  }
  
  fileprivate func initializeDates() {
    queue.enter()
    DispatchQueue.global().async {
      let from = self.dateInfo(for: .from(date: nil, minimumDate: nil, maximumDate: nil))!
      let to = self.dateInfo(for: .to(date: nil, minimumDate: nil, maximumDate: nil))!
      self.setDate(for: from)
      self.setDate(for: to)
      self.didLoadDates = true
      self.queue.leave()
    }
  }
  
  fileprivate func initializeCategoriesData() {
    queue.enter()
    DispatchQueue.global().async {
      self.categoriesData.removeAll()
      // On initialization the 'filterCategories' array only contains '.header' cases
      // for the sole reason that at first they are all collapsed
      self.categoriesData = self.generateCategoriesData(categories: FiltersManager.shared.categories)
      self.queue.leave()
    }
  }
  
  fileprivate func initializeParticipantsData() {
    queue.enter()
    DispatchQueue.global().async {
      self.participantsData.removeAll()
      // participantsData array will hold .header row data that are not expanded
      self.participantsData = self.generateParticipantsData()
      self.queue.leave()
    }
  }
  
  private func generateCategoriesData(categories: [Event.Category]) -> [SelectableRowData] {
    var categoriesData = [SelectableRowData]()
    for category in categories {
      let subCategoryData = generateCategoriesData(subCategories: category.subCategories)
      if subCategoryData.count > 0 {
        let selection = selectionStatus(of: category)
        categoriesData.append(
          .header(label: category.label ?? "",
                  expanded: (selection != .none) ? true : false,
                  rowData: subCategoryData))
        // In case the header category is selected
        // Then also add the children categories so they are displayed
        if selection != .none {
          categoriesData.append(contentsOf: subCategoryData)
        }
      }
    }
    return categoriesData
  }
  
  private func generateCategoriesData(subCategories: [Event.Category]?) -> [SelectableRowData] {
    var categoriesData = [SelectableRowData]()
    guard let subCategories = subCategories else {
      return categoriesData
    }
    
    for (index, category) in subCategories.enumerated() {
      let selection = self.selectionStatus(of: category)
      categoriesData.append(
        .child(
          label: category.label ?? "",
          selection: selection,
          isLastChild: index == (subCategories.count - 1),
          data: category)
      )
    }
    
    return categoriesData
  }
  
  // TODO: Enhance by looping throught hhe participant types dynamically
  private func generateParticipantsData() -> [SelectableRowData] {
    var data = [SelectableRowData]()
    data.append(contentsOf: generateParticipantsData(for: FiltersManager.shared.artists))
    data.append(contentsOf: generateParticipantsData(for: FiltersManager.shared.companies))
    data.append(contentsOf: generateParticipantsData(for: FiltersManager.shared.organizers))
    data.append(contentsOf: generateParticipantsData(for: FiltersManager.shared.speakers))
    data.append(contentsOf: generateParticipantsData(for: FiltersManager.shared.sponsers))
    return data
  }
  
  private func generateParticipantsData(for participants: [Participant]) -> [SelectableRowData] {
    var data = [SelectableRowData]()
    var participantsData = [SelectableRowData]()
    var isHeaderSlected = false
    
    for (index, artist) in participants.enumerated() {
      let participantSelectionsStatus = selectionStatus(of: artist)
      participantsData.append(.child(
        label: artist.titleValue,
        selection: participantSelectionsStatus,
        isLastChild: index == (participants.count - 1),
        data: artist))
      if participantSelectionsStatus != .none {
        isHeaderSlected = true
      }
    }
    
    if participantsData.count > 0 {
      data.append(.header(
        label: participants.first?.type.sectionDisplayName ?? "",
        expanded: isHeaderSlected,
        rowData: participantsData))
      if isHeaderSlected {
        data.append(contentsOf: participantsData)
      }
    }
    
    return data
  }
  
  fileprivate func selectionStatus(of category: Event.Category) -> Selection {
    let isSelected = filter.contains(category: category)
    var subCategoriesSelection: Selection?
    
    // If the category has subcategories
    if let subCategories = category.subCategories {
      var numberOfSelectedSubcategories = 0
      subCategories.forEach({ (subCategory) in
        if filter.contains(category: subCategory) {
          numberOfSelectedSubcategories += 1
        }
      })
      subCategoriesSelection = numberOfSelectedSubcategories == 0 ?
        .none : (numberOfSelectedSubcategories == subCategories.count ? Selection.all : Selection.some)
    }
    
    if let subCategoriesSelection = subCategoriesSelection {
      return subCategoriesSelection
    } else {
      return isSelected ? .all : .none
    }
  }
  
  fileprivate func selectionStatus(of participant: Participant) -> Selection {
    let type = participant.type
    switch type {
    case .Artist:
      return (filter.artists?.contains(participant) ?? false) ? .all : .none
    case .Company:
      return (filter.companies?.contains(participant) ?? false) ? .all : .none
    case .Organizer:
      return (filter.organizers?.contains(participant) ?? false) ? .all : .none
    case .Speaker:
      return (filter.speakers?.contains(participant) ?? false) ? .all : .none
    case .Sponsor:
      return (filter.sponsers?.contains(participant) ?? false) ? .all : .none
    case .Default:
      return .none
    }
  }
}

//MARK: Data Getters
extension FiltersViewModel {
  typealias Section = FiltersViewController.Section
  typealias DateRow = FiltersViewController.DateRow
  
  var numberOfSections: Int {
    return Section.numberOfSections
  }
  
  func numberOfRows(in section: Section) -> Int {
    switch section {
    case .dates:
      return didLoadDates ? 2 : 0
    case .types:
      return categoriesData.count
    case .withinTime:
      return 1
    case .participants:
      return participantsData.count
    case .withinDistance:
      return 1
    case .bookmark:
      return 1
    }
  }
  
  func titleForHeader(in section: Section) -> String? {
    return section.title
  }
  
  func dateInfo(for indexPath: IndexPath) -> DateRow {
    if indexPath.row == 0 {
      return dateInfo(for: .from(date: nil, minimumDate: nil, maximumDate: nil))
    } else {
      return dateInfo(for: .to(date: nil, minimumDate: nil, maximumDate: nil))
    }
  }
  
  fileprivate func dateInfo(for dateRow: DateRow) -> DateRow! {
    var date: Date
    var minimumDate: Date
    var maximumDate: Date
    switch dateRow {
    case .picker(.from):
      fallthrough
    case .from:
      date = filter.dateRange?.from ?? FiltersManager.shared.firstEventDate
      minimumDate = FiltersManager.shared.firstEventDate
      maximumDate = FiltersManager.shared.lastEventDate
      return .from(date: date, minimumDate: minimumDate, maximumDate: maximumDate)
    case .picker(.to):
      fallthrough
    case .to:
      date = filter.dateRange?.to ?? FiltersManager.shared.lastEventDate
      minimumDate = filter.dateRange?.from ?? FiltersManager.shared.firstEventDate
      maximumDate = FiltersManager.shared.lastEventDate
      return .to(date: date, minimumDate: minimumDate, maximumDate: maximumDate)
    default:
      return nil
    }
  }
  
  func indexPath(for dateRow: DateRow) -> IndexPath? {
    switch dateRow {
    case .from:
      return IndexPath(row: 0, section: Section.dates.rawValue)
    case .to:
      return IndexPath(row: 1, section: Section.dates.rawValue)
    default:
      return nil
    }
  }
  
  func categoriesInfo(for indexPath: IndexPath) -> SelectableRowData {
    return categoriesData[indexPath.row]
  }
  
  func participantsInfo(for indexPath: IndexPath) -> SelectableRowData {
    return participantsData[indexPath.row]
  }
  
  func bookmarkInfo() -> (label: String, showBookmarks: Bool) {
    return (Strings.show_bookmarked_events(), (filter.showBookmarked ?? false))
  }
  
  func withinDistanceInfo() -> (selectedValue: String, unit: String, numberOfValues: Int, selectedValueIndex: Int) {
    let withinDistanceValues = FiltersManager.shared.withinDistanceValues
    
    let numberOfValues = withinDistanceValues.values.count
    let selectedValue = "\(Int(filter.withinDistance ?? 0))"
    let selectedValueIndex = withinDistanceValues.values.index(of: filter.withinDistance ?? 0) ?? 0
    let unit = withinDistanceValues.unit
    
    return (selectedValue, unit, numberOfValues, selectedValueIndex)
  }
  
  func withinTimeInfo() -> (selectedValue: String, unit: String, numberOfValues: Int, selectedValueIndex: Int) {
    let withinTimeValues = FiltersManager.shared.withinTimeValues
    
    let numberOfValues = withinTimeValues.values.count
    let selectedValue = "\(filter.withinTime ?? 0)"
    let selectedValueIndex = withinTimeValues.values.index(of: filter.withinTime ?? 0) ?? 0
    let unit = withinTimeValues.unit
    
    return (selectedValue, unit, numberOfValues, selectedValueIndex)
  }
}

//MARK: Data Setters
extension FiltersViewModel {
  func resetFilters() {
    self.filter = Filter.zero
    initializeDates()
    initializeCategoriesData()
    initializeParticipantsData()
  }
  
  func setDate(for dateRow: DateRow) {
    switch dateRow {
    case .from(let date, _, _):
      setFrom(date: date)
    case .to(let date, _, _):
      setTo(date: date)
    default:
      break
    }
  }
  
  func setFrom(date: Date?) {
    var dateRange = filter.dateRange ?? DateRange()
    dateRange.from = date
    if let date = date, let toDate = filter.dateRange?.to, toDate < date {
      dateRange.to = date
    }
    filter.dateRange = dateRange
  }
  
  func setTo(date: Date?) {
    var dateRange = filter.dateRange ?? DateRange()
    dateRange.to = date
    filter.dateRange = dateRange
  }
  
  //========
  
  func selectCategory(at indexPath: IndexPath) -> (toInsert: Bool, indexPaths: [IndexPath])? {
    switch categoriesInfo(for: indexPath) {
    case .header:
      return toggleCategoryExpansion(at: indexPath)
    case .child:
      toggleCategorySelection(at: indexPath)
      return nil
    }
  }
  
  private func toggleCategoryExpansion(at indexPath: IndexPath) -> (toInsert: Bool, indexPaths: [IndexPath])? {
    if case .header(let label, let expanded, let rowData) = categoriesInfo(for: indexPath) {
      categoriesData[indexPath.row].adjust(with: .header(label: label, expanded: !expanded, rowData: rowData))
      
      var indexPaths = [IndexPath]()
      let startingIndex = indexPath.row + 1
      for index in 0..<rowData.count {
        indexPaths.append(IndexPath(row: startingIndex + index, section: indexPath.section))
      }
      
      if expanded {
        let range = startingIndex..<startingIndex+rowData.count
        categoriesData.removeSubrange(range)
      } else {
        categoriesData.insert(contentsOf: rowData, at: indexPath.row+1)
      }
      
      return (!expanded, indexPaths)
    }
    return nil
  }
  
  private func toggleCategorySelection(at indexPath: IndexPath) {
    if case .child(let label, let selection, let isLastChild, let data) = categoriesInfo(for: indexPath),
      let headerIndexes = headerSelectableRowIndex(in: categoriesData, forChildAt: indexPath.row),
      case .header(let headerLabel, let expanded, var rowData) = categoriesData[headerIndexes.header] {
      
      // Adjust the data held in the header data
      rowData[headerIndexes.child].adjust(with: .child(label: label, selection: selection.opposite, isLastChild: isLastChild , data: data))
      categoriesData[headerIndexes.header].adjust(with: .header(label: headerLabel, expanded: expanded, rowData: rowData))
      // Adjust the data of the child item
      categoriesData[indexPath.row].adjust(with:
        .child(label: label, selection: selection.opposite, isLastChild: isLastChild , data: data))
      
      // Adjust data in filter object
      if let selectedCategory = data as? Event.Category {
        switch selection.opposite {
        case .all, .some:
          filter.add(category: selectedCategory)
        case .none:
          filter.remove(category: selectedCategory)
        }
      }
    }
  }
  
  func selectParticipant(at indexPath: IndexPath) -> (toInsert: Bool, indexPaths: [IndexPath])? {
    switch participantsInfo(for: indexPath) {
    case .header:
      return toggleParticipantExpansion(at: indexPath)
    case .child:
      toggleParticipantSelection(at: indexPath)
      return nil
    }
  }
  
  // ========
  
  private func toggleParticipantExpansion(at indexPath: IndexPath) -> (toInsert: Bool, indexPaths: [IndexPath])? {
    if case .header(let label, let expanded, let rowData) = participantsInfo(for: indexPath) {
      participantsData[indexPath.row].adjust(with: .header(label: label, expanded: !expanded, rowData: rowData))
      
      var indexPaths = [IndexPath]()
      let startingIndex = indexPath.row + 1
      for index in 0..<rowData.count {
        indexPaths.append(IndexPath(row: startingIndex + index, section: indexPath.section))
      }
      
      if expanded {
        let range = startingIndex..<startingIndex+rowData.count
        participantsData.removeSubrange(range)
      } else {
        participantsData.insert(contentsOf: rowData, at: indexPath.row+1)
      }
      
      return (!expanded, indexPaths)
    }
    return nil
  }
  
  private func toggleParticipantSelection(at indexPath: IndexPath) {
    if case .child(let label, let selection, let isLastChild, let data) = participantsInfo(for: indexPath),
      let headerIndexes = headerSelectableRowIndex(in: participantsData, forChildAt: indexPath.row),
      case .header(let headerLabel, let expanded, var rowData) = participantsData[headerIndexes.header] {
      
      // Adjust the data held in the header data
      rowData[headerIndexes.child].adjust(with: .child(label: label, selection: selection.opposite, isLastChild: isLastChild , data: data))
      participantsData[headerIndexes.header].adjust(with: .header(label: headerLabel, expanded: expanded, rowData: rowData))
      // Adjust the data of the child item
      participantsData[indexPath.row].adjust(with:
        .child(label: label, selection: selection.opposite, isLastChild: isLastChild , data: data))
      
      // Adjust data in filter object
      if let selectedParticipant = data as? Participant {
        switch selection.opposite {
        case .all, .some:
          filter.add(participant: selectedParticipant)
        case .none:
          filter.remove(participant: selectedParticipant)
        }
      }
    }
  }
  
  //========
  
  func setShowBookmarkedEvents(show: Bool) {
    filter.showBookmarked = show
  }
  
  //========
  
  func setWithinDistance(for index: Int) -> (selectedValue: String, unit: String) {
    let withinDistanceValues = FiltersManager.shared.withinDistanceValues
    filter.withinDistance = withinDistanceValues.values[index]
    let values = withinDistanceInfo()
    return (values.selectedValue, values.unit)
  }
  
  //========
  
  func setWithinTime(for index: Int) -> (originalValue: Int, selectedValue: String, unit: String) {
    let withinTimeValues = FiltersManager.shared.withinTimeValues
    let originalValue = withinTimeValues.values[index]
    filter.withinTime = originalValue
    let values = withinTimeInfo()
    return (originalValue, values.selectedValue, values.unit)
  }
  
  //========
  
  private func headerSelectableRowIndex(in selectableRowsData: [SelectableRowData], forChildAt index: Int) -> (header: Int, child: Int)? {
    guard case .child = selectableRowsData[index] else {
      return nil
    }
    
    for i in (0..<index).reversed() {
      if case .header = selectableRowsData[i] {
        return (i, index - (i + 1))
      }
    }
    return nil
  }
}

//MARK: DynamicSelectableRowData Declaration
extension FiltersViewModel {
  enum SelectableRowData {
    case header(label: String, expanded: Bool, rowData: [SelectableRowData])
    case child(label: String, selection: Selection, isLastChild: Bool, data: Any?)
    
    mutating func adjust(with rowData: SelectableRowData) {
      self = rowData
    }
  }
}

//MARK: - [Analytics]
extension FiltersViewModel {
  var analyticFilterDate: String? {
    guard let dateRange = filter.dateRange else {
      return nil
    }
    return Breadcrumb.dateRange(dateRange).text
  }
  
  var analyticFilterCategories: String? {
    guard let categories = filter.categories else {
      return nil
    }
    let categoriesText = categories.map({ Breadcrumb.category($0).text })
    return categoriesText.joined(separator: ", ")
  }
  
  var analyticFilterStartsWithin: String? {
    guard let withinTime = filter.withinTime, withinTime != 0 else {
      return nil
    }
    return Breadcrumb.withinTime(withinTime).text
  }
  
  var analyticFilterSpeakers: String? {
    guard let speakers = filter.speakers, speakers.count > 0 else {
      return nil
    }
    let participantsArray = speakers.map({ Breadcrumb.speaker($0).text })
    return participantsArray.joined(separator: ", ")
  }
  
  var analyticFilterOrganizers: String? {
    guard let organizers = filter.organizers, organizers.count > 0 else {
      return nil
    }
    let participantsArray = organizers.map({ Breadcrumb.organizer($0).text })
    return participantsArray.joined(separator: ", ")
  }
  
  var analyticFilterSponsors: String? {
    guard let sponsors = filter.sponsers, sponsors.count > 0 else {
      return nil
    }
    let participantsArray = sponsors.map({ Breadcrumb.sponsor($0).text })
    return participantsArray.joined(separator: ", ")
  }
  
  var analyticFilterCompanies: String? {
    guard let companies = filter.companies, companies.count > 0 else {
      return nil
    }
    let participantsArray = companies.map({ Breadcrumb.company($0).text })
    return participantsArray.joined(separator: ", ")
  }
  
  var analyticFilterArtists: String? {
    guard let artists = filter.artists, artists.count > 0 else {
      return nil
    }
    let participantsArray = artists.map({ Breadcrumb.artist($0).text })
    return participantsArray.joined(separator: ", ")
  }
  
  var analyticFilterDistance: String? {
    guard let withinDistance = filter.withinDistance, withinDistance != 0 else {
      return nil
    }
    return Breadcrumb.withinDistance(withinDistance).text
  }
  
  var analyticFilterBookmarked: String? {
    return (filter.showBookmarked ?? false) ? "true" : "false"
  }
}
