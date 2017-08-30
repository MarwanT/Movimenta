//
//  FiltersViewModel.swift
//  Movimenta
//
//  Created by Marwan  on 8/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

final class FiltersViewModel {
  fileprivate var filter: Filter! = nil
  
  fileprivate var categoriesData = [SelectableRowData]()
  
  func initialize(with filter: Filter) {
    self.filter = filter
    initializeCategoriesData()
  }
  
  private func initializeCategoriesData() {
    self.categoriesData.removeAll()
    // On initialization the 'filterCategories' array only contains '.header' cases
    // for the sole reason that at first they are all collapsed
    self.categoriesData = generateCategoriesData(categories: FiltersManager.shared.categories)
  }
  
  private func generateCategoriesData(categories: [Event.Category]) -> [SelectableRowData] {
    var categoriesData = [SelectableRowData]()
    for category in categories {
      let subCategoryData = generateCategoriesData(subCategories: category.subCategories)
      categoriesData.append(.header(label: category.label ?? "", expanded: false, rowData: subCategoryData))
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
  
  fileprivate func selectionStatus(of category: Event.Category) -> Selection {
    let isSelected = filter.contains(category: category)
    var subCategoriesSelection: Selection?
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
      return DateRow.numberOfRows
    case .types:
      return categoriesData.count
    default:
      return 0
    }
  }
  
  func titleForHeader(in section: Section) -> String? {
    return section.title
  }
  
  func dateInfo(for dateRow: DateRow) -> (date: Date, minimumDate: Date, maximumDate: Date) {
    var date: Date
    var minimumDate: Date
    var maximumDate: Date
    switch dateRow {
    case .from:
      date = filter.dateRange?.from ?? FiltersManager.shared.firstEventDate
      minimumDate = FiltersManager.shared.firstEventDate
      maximumDate = FiltersManager.shared.lastEventDate
    case .to:
      date = filter.dateRange?.to ?? FiltersManager.shared.lastEventDate
      minimumDate = filter.dateRange?.from ?? FiltersManager.shared.firstEventDate
      maximumDate = FiltersManager.shared.lastEventDate
    }
    return (date, minimumDate, maximumDate)
  }
  
  func categoriesInfo(for indexPath: IndexPath) -> SelectableRowData {
    return categoriesData[indexPath.row]
  }
}

//MARK: Data Setters
extension FiltersViewModel {
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
    }
  }
  
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
