//
//  FiltersViewController.swift
//  Movimenta
//
//  Created by Marwan  on 8/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate: class {
  func filters(_ viewController: FiltersViewController, didApply filter: Filter)
  func filtersDidReset(_ viewController: FiltersViewController)
}

class FiltersViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel = FiltersViewModel()
  
  weak var delegate: FiltersViewControllerDelegate?
  
  static func instance() -> FiltersViewController {
    return Storyboard.Filter.instantiate(FiltersViewController.self)
  }
  
  func initialize(with filter: Filter) {
    viewModel.initialize(with: filter) { [unowned self] in
      if self.tableView != nil {
        self.tableView.reloadData()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initializeViewController()
    initializeTableView()
    initializeNavigationBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //MARK: [Analytics] Screen Name
    Analytics.shared.send(screenName: Analytics.ScreenNames.Filters)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    registerToNotificationCenter()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterToNotificationCenter()
  }
  
  func initializeViewController() {
    title = viewModel.viewControllerTitle
  }
  
  private func initializeTableView() {
    let theme = ThemeManager.shared.current
    
    let resetView = ResetFiltersView()
    resetView.delegate = self
    tableView.tableHeaderView = resetView
    resetView.snp.makeConstraints { (maker) in
      maker.width.equalTo(tableView)
    }
    
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 60
    tableView.sectionHeaderHeight = UITableViewAutomaticDimension
    tableView.estimatedSectionHeaderHeight = 40
    
    tableView.allowsMultipleSelection = true
    
    tableView.layoutMargins = UIEdgeInsets(
      top: 0, left: CGFloat(theme.space7),
      bottom: 0, right: CGFloat(theme.space7))
    
    tableView.separatorStyle = .singleLine
    tableView.separatorColor = theme.separatorColor
    
    tableView.register(DateCell.nib, forCellReuseIdentifier: DateCell.identifier)
    tableView.register(DatePickerCell.nib, forCellReuseIdentifier: DatePickerCell.identifier)
    tableView.register(FiltersSectionHeader.self, forHeaderFooterViewReuseIdentifier: FiltersSectionHeader.identifier)
    tableView.register(ExpandableHeaderCell.nib, forCellReuseIdentifier: ExpandableHeaderCell.identifier)
    tableView.register(SelectableCell.nib, forCellReuseIdentifier: SelectableCell.identifier)
    tableView.register(SwitchCell.nib, forCellReuseIdentifier: SwitchCell.identifier)
    tableView.register(SliderCell.nib, forCellReuseIdentifier: SliderCell.identifier)
  }
  
  private func initializeNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: Strings.apply(),
      style: .plain, target: self,
      action: #selector(didTapApplyButton(_:)))
    navigationItem.backBarButtonItem = UIBarButtonItem.back
  }
  
  private func registerToNotificationCenter() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleReloadedData(_:)), name: AppNotification.didLoadData, object: nil)
  }
  
  private func unregisterToNotificationCenter() {
    NotificationCenter.default.removeObserver(self)
  }
  
  func didTapApplyButton(_ sender: UIBarButtonItem) {
    applyFilter()
  }
  
  func applyFilter() {
    delegate?.filters(self, didApply: viewModel.filter)
    navigationController?.popViewController(animated: true)
    
    //MARK: [Analytics] Event
    sendAnalyticsEvents()
  }
  
  private func sendAnalyticsEvents() {
    //MARK: [Analytics] Event
    var analyticsEvent = Analytics.Event(category: .events, action: .applyfilters)
    Analytics.shared.send(event: analyticsEvent)
    //MARK: [Analytics] Event
    if let analyticFilterDate = viewModel.analyticFilterDate {
      analyticsEvent = Analytics.Event(
        category: .events, action: Analytics.Action.filterDate, name: analyticFilterDate)
      Analytics.shared.send(event: analyticsEvent)
    }
    //MARK: [Analytics] Event
    if let analyticFilterCategories = viewModel.analyticFilterCategories {
      analyticsEvent = Analytics.Event(
        category: .events, action: .filterEventType, name: analyticFilterCategories)
      Analytics.shared.send(event: analyticsEvent)
    }
    //MARK: [Analytics] Event
    if let analyticFilterStartsWithin = viewModel.analyticFilterStartsWithin {
      analyticsEvent = Analytics.Event(
        category: .events, action: .filterStartsWithin, name: analyticFilterStartsWithin)
      Analytics.shared.send(event: analyticsEvent)
    }
    //MARK: [Analytics] Event
    if let analyticFilterSpeakers = viewModel.analyticFilterSpeakers {
      analyticsEvent = Analytics.Event(
        category: .events, action: .filterSpeakers, name: analyticFilterSpeakers)
      Analytics.shared.send(event: analyticsEvent)
    }
    //MARK: [Analytics] Event
    if let analyticFilterOrganizers = viewModel.analyticFilterOrganizers {
      analyticsEvent = Analytics.Event(
        category: .events, action: .filterOrganizers, name: analyticFilterOrganizers)
      Analytics.shared.send(event: analyticsEvent)
    }
    //MARK: [Analytics] Event
    if let analyticFilterSponsors = viewModel.analyticFilterSponsors {
      analyticsEvent = Analytics.Event(
        category: .events, action: .filterSponsors, name: analyticFilterSponsors)
      Analytics.shared.send(event: analyticsEvent)
    }
    //MARK: [Analytics] Event
    if let analyticFilterCompanies = viewModel.analyticFilterCompanies {
      analyticsEvent = Analytics.Event(
        category: .events, action: .filterCompanies, name: analyticFilterCompanies)
      Analytics.shared.send(event: analyticsEvent)
    }
    //MARK: [Analytics] Event
    if let analyticFilterArtists = viewModel.analyticFilterArtists {
      analyticsEvent = Analytics.Event(
        category: .events, action: .filterArtists, name: analyticFilterArtists)
      Analytics.shared.send(event: analyticsEvent)
    }
    //MARK: [Analytics] Event
    if let analyticFilterDistance = viewModel.analyticFilterDistance {
      analyticsEvent = Analytics.Event(
        category: .events, action: .fitlerDistance, name: analyticFilterDistance)
      Analytics.shared.send(event: analyticsEvent)
    }
    //MARK: [Analytics] Event
    if let analyticFilterBookmarked = viewModel.analyticFilterBookmarked {
      analyticsEvent = Analytics.Event(
        category: .events, action: .filterBookmarked, name: analyticFilterBookmarked)
      Analytics.shared.send(event: analyticsEvent)
    }
  }
  
  func handleReloadedData(_ sender: Notification) {
    self.navigationController?.popViewController(animated: true)
  }
}

//MARK: Table View Delegates
extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
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
    guard let section = Section(rawValue: indexPath.section) else {
      return UITableViewCell()
    }
    
    switch section {
    case .dates:
      guard let dateRow = viewModel.dateInfo(for: indexPath) else {
        return UITableViewCell()
      }
      
      switch dateRow {
      case .from(let date, _, _), .to(let date, _, _):
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DateCell.identifier, for: indexPath) as? DateCell else {
          return UITableViewCell()
        }
        cell.set(label: dateRow.label, date: date)
        return cell
      case .picker(.from(let date, let minimumDate, let maximumDate)),
           .picker(.to(let date, let minimumDate, let maximumDate)):
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerCell.identifier, for: indexPath) as? DatePickerCell else {
          return UITableViewCell()
        }
        cell.delegate = self
        cell.set(date: date)
        cell.set(minimumDate: minimumDate)
        cell.set(maximumDate: maximumDate)
        return cell
      default:
        return UITableViewCell()
      }
    case .withinTime:
      let values = viewModel.withinTimeInfo()
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SliderCell.identifier, for: indexPath) as? SliderCell else {
        return UITableViewCell()
      }
      cell.delegate = self
      cell.set(valuesCount: values.numberOfValues, selectedValue: values.selectedValueIndex)
      cell.setLabel(with: values.selectedValue, unit: values.unit)
      return cell
    case .types:
      let values = viewModel.categoriesInfo(for: indexPath)
      switch values {
      case .header(let label, _, _):
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableHeaderCell.identifier, for: indexPath) as? ExpandableHeaderCell else {
          return UITableViewCell()
        }
        cell.label.text = label
        return cell
      case .child(let label, _, let isLastChild, _):
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableCell.identifier, for: indexPath) as? SelectableCell else {
          return UITableViewCell()
        }
        cell.label.text = label
        cell.indentationLevel = 1
        isLastChild ? cell.showSeparator() : cell.hideSeparator()
        return cell
      }
    case .participants:
      let values = viewModel.participantsInfo(for: indexPath)
      switch values {
      case .header(let label, _, _):
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableHeaderCell.identifier, for: indexPath) as? ExpandableHeaderCell else {
          return UITableViewCell()
        }
        cell.label.text = label
        return cell
      case .child(let label, _, let isLastChild, _):
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableCell.identifier, for: indexPath) as? SelectableCell else {
          return UITableViewCell()
        }
        cell.label.text = label
        cell.indentationLevel = 1
        isLastChild ? cell.showSeparator() : cell.hideSeparator()
        return cell
      }
    case .withinDistance:
      let values = viewModel.withinDistanceInfo()
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SliderCell.identifier, for: indexPath) as? SliderCell else {
        return UITableViewCell()
      }
      cell.delegate = self
      cell.set(valuesCount: values.numberOfValues, selectedValue: values.selectedValueIndex)
      cell.setLabel(with: values.selectedValue, unit: values.unit)
      return cell
    case .bookmark:
      let values = viewModel.bookmarkInfo()
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.identifier, for: indexPath) as? SwitchCell else {
        return UITableViewCell()
      }
      cell.delegate = self
      cell.set(label: values.label, switchOn: values.showBookmarks)
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let section = Section(rawValue: indexPath.section) else {
      return
    }
    
    switch section {
    case .dates:
      break
    case .withinTime:
      break
    case .types:
      let values = viewModel.categoriesInfo(for: indexPath)
      switch values {
      case .header(_, let isExpanded, _):
        if isExpanded && !tableView.isCellSelected(at: indexPath) {
          tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
      case .child(_, let selection, _, _):
        if !tableView.isCellSelected(at: indexPath) && (selection != .none) {
          tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
      }
    case .participants:
      let values = viewModel.participantsInfo(for: indexPath)
      switch values {
      case .header(_, let isExpanded, _):
        if isExpanded && !tableView.isCellSelected(at: indexPath) {
          tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
      case .child(_, let selection, _, _):
        if !tableView.isCellSelected(at: indexPath) && (selection != .none) {
          tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
      }
    case .withinDistance:
      break
    case .bookmark:
      break
    }
  }
  
//  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    guard let section = Section(rawValue: indexPath.section) else {
//      return
//    }
//    
//    switch section {
//    case .dates:
//      guard let cell = cell as? DatePickerCell, let selectedDateRow = viewModel.dateInfoForSelectedRow() else {
//        return
//      }
//      
//      switch selectedDateRow {
//      case .from(let date, let minimumDate, let maximumDate),
//           .to(let date, let minimumDate, let maximumDate):
//        cell.set(date: date, animated: true)
//        cell.set(minimumDate: minimumDate)
//        cell.set(maximumDate: maximumDate)
//      default:
//        break
//      }
//    default:
//      break
//    }
//  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let section = Section(rawValue: section),
      let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FiltersSectionHeader.identifier) as? FiltersSectionHeader, section != .bookmark else {
      return nil
    }
    header.label.text = viewModel.titleForHeader(in: section)
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard let section = Section(rawValue: section) else {
      return 0
    }
    switch section {
    case .bookmark:
      return 0
    default:
      if viewModel.numberOfRows(in: section) > 0 {
        return UITableViewAutomaticDimension
      } else {
        return 0
      }
    }
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    guard let section = Section(rawValue: indexPath.section) else {
      return indexPath
    }
    
    switch section {
    case .bookmark, .withinDistance, .withinTime:
      return nil
    default:
      return indexPath
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let section = Section(rawValue: indexPath.section) else {
      return
    }
    
    switch section {
    case .dates:
      guard let dateRow = dateRow(for: indexPath) else {
        return
      }
      switch dateRow {
      case .from:
        deselect(dateRow: .to(date: nil, minimumDate: nil, maximumDate: nil)) {
          self.select(dateRow: dateRow)
        }
      case .to:
        deselect(dateRow: .from(date: nil, minimumDate: nil, maximumDate: nil)) {
          self.select(dateRow: dateRow)
        }
      default:
        break
      }
    case .types:
      if let (_, affectedIndexPaths) = viewModel.selectCategory(at: indexPath) {
        tableView.insertRows(at: affectedIndexPaths, with: .fade)
        if let lastIndexPath = affectedIndexPaths.last {
          tableView.scrollToRow(at: lastIndexPath, at: .none, animated: true)
        }
      }
      deselect(dateRow: nil)
    case .participants:
      if let (_, affectedIndexPaths) = viewModel.selectParticipant(at: indexPath) {
        tableView.insertRows(at: affectedIndexPaths, with: .fade)
        if let lastIndexPath = affectedIndexPaths.last {
          tableView.scrollToRow(at: lastIndexPath, at: .none, animated: true)
        }
      }
      deselect(dateRow: nil)
    default:
      deselect(dateRow: nil)
      return
    }
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    guard let section = Section(rawValue: indexPath.section) else {
      return
    }
    
    switch section {
    case .dates:
      guard let deselectedDateRow = dateRow(for: indexPath) else {
        return
      }
      deselect(dateRow: deselectedDateRow)
    case .types:
      if let (_, affectedIndexPaths) = viewModel.selectCategory(at: indexPath) {
        tableView.deleteRows(at: affectedIndexPaths, with: .fade)
      }
    case .participants:
      if let (_, affectedIndexPaths) = viewModel.selectParticipant(at: indexPath) {
        tableView.deleteRows(at: affectedIndexPaths, with: .fade)
      }
    default:
      return
    }
  }
  
  fileprivate func updateTableView() {
    tableView.beginUpdates()
    tableView.endUpdates()
  }
  
  //===============================
  
  fileprivate func refreshTableView() {
    tableView.reloadSections(
      IndexSet(Section.all.map({ $0.rawValue })),
      with: UITableViewRowAnimation.automatic)
    // For not identified reasons yet if the dates section is not relloaded
    // without animation, the date cells are disappearing
    tableView.reloadSections(IndexSet(integer: Section.dates.rawValue), with: .none)
  }
  
  fileprivate func refreshDateCells() {
    if let indexPath = indexPath(for: [.from(date: nil, minimumDate: nil, maximumDate: nil)]).first,
      let cell = tableView.cellForRow(at: indexPath) as? DateCell,
      let dateRow = viewModel.dateInfo(for: indexPath),
      case .from(let date, _, _) = dateRow {
      cell.set(label: dateRow.label, date: date)
    }
    if let indexPath = indexPath(for: [.to(date: nil, minimumDate: nil, maximumDate: nil)]).first,
      let cell = tableView.cellForRow(at: indexPath) as? DateCell,
      let dateRow = viewModel.dateInfo(for: indexPath),
      case .to(let date, _, _) = dateRow {
      cell.set(label: dateRow.label, date: date)
    }
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    deselect(dateRow: nil)
  }
  
  /// If the passed parameter was nil then both date picker cells are deselected
  fileprivate func deselect(dateRow: DateRow?, completion: (() -> Void)? = nil) {
    var indexPaths = [IndexPath]()
    if let dateRow = dateRow {
      switch dateRow {
      case .from:
        indexPaths.append(contentsOf: indexPath(for: [.from(date: nil, minimumDate: nil, maximumDate: nil)]))
      case .to:
        indexPaths.append(contentsOf: indexPath(for: [.to(date: nil, minimumDate: nil, maximumDate: nil)]))
      default:
        indexPaths.append(contentsOf: indexPath(for: [
          .from(date: nil, minimumDate: nil, maximumDate: nil),
          .to(date: nil, minimumDate: nil, maximumDate: nil)]))
      }
      
      if let selectedDateRow = viewModel.selectedDateRow {
        // Update view model
        switch (selectedDateRow, dateRow) {
        case (.to, .to),
             (.from, .from):
          viewModel.selectedDateRow = nil
        default:
          break
        }
        
        // Remove the picker cell
        removeDatePickerCell(for: dateRow, completion: completion)
      } else {
        completion?()
      }
    } else {
      if let selectedDateRow = viewModel.selectedDateRow {
        // Update view model
        viewModel.selectedDateRow = nil
        // Get the date rows indexes to deselect rows
        indexPaths = indexPath(for: [selectedDateRow])
        // Delete Date Picker
        removeDatePickerCell(for: selectedDateRow, completion: completion)
      } else {
        completion?()
      }
    }
    indexPaths.forEach { (indexPath) in
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  func select(dateRow: DateRow) {
    switch dateRow {
    case .from, .to:
      // Update view model
      viewModel.selectedDateRow = dateRow
      // Insert picker cell
      tableView.insertRows(at: indexPath(for: [.picker(dateRow: dateRow)]), with: .top)
    default:
      break
    }
  }
  
  
  /**
   The date cell are Can be ordered like one of these representations
   
   ----------       ----------       ----------
    .from            .from            .from
   ----------       ----------       ----------
    .to               .picker         .to
   ----------       ----------       ----------
                     .to               .picker
                    ----------       ----------
   */
  fileprivate func indexPath(for dateRows: [DateRow]) -> [IndexPath] {
    var indexPaths = [IndexPath]()
    for dateRow in dateRows {
      switch dateRow {
      case .from:
        indexPaths.append(IndexPath(row: 0, section: Section.dates.rawValue))
      case .to:
        var toDateCellRow: Int = 1
        if let selectedDateRow = viewModel.selectedDateRow {
          if case .from = selectedDateRow {
            toDateCellRow = 2
          } else { // .to is selected
            toDateCellRow = 1
          }
        }
        let indexPath = IndexPath(row: toDateCellRow, section: Section.dates.rawValue)
        indexPaths.append(indexPath)
      case .picker(.from):
        indexPaths.append(IndexPath(row: 1, section: Section.dates.rawValue))
      case .picker(.to):
        indexPaths.append(IndexPath(row: 2, section: Section.dates.rawValue))
      default:
        continue
      }
    }
    return indexPaths
  }
  
  fileprivate func dateRow(for indexPath: IndexPath) -> DateRow? {
    guard let _ = Section(rawValue: indexPath.section) else {
      return nil
    }
    
    let rowIndex = indexPath.row
    if rowIndex == 0 {
      return .from(date: nil, minimumDate: nil, maximumDate: nil)
    } else if rowIndex == 1 {
      if let selectedDateRow = viewModel.selectedDateRow {
        switch selectedDateRow {
        case .from, .picker(.from):
          return .picker(dateRow: .from(date: nil, minimumDate: nil, maximumDate: nil))
        case .to, .picker(.to):
          return .to(date: nil, minimumDate: nil, maximumDate: nil)
        default:
          return nil
        }
      } else {
        return .to(date: nil, minimumDate: nil, maximumDate: nil)
      }
      
    } else { // == 3
      if let selectedDateRow = viewModel.selectedDateRow {
        switch selectedDateRow {
        case .from, .picker(.from):
          return .to(date: nil, minimumDate: nil, maximumDate: nil)
        case .to, .picker(.to):
          return .picker(dateRow: .from(date: nil, minimumDate: nil, maximumDate: nil))
        default:
          return nil
        }
      } else {
        return nil
      }
    }
  }
  
  fileprivate func removeDatePickerCell(for dateRow: DateRow, completion: (() -> Void)?) {
    let pickerIndexPaths = indexPath(for: [.picker(dateRow: dateRow)])
    CATransaction.begin()
    tableView.beginUpdates()
    CATransaction.setCompletionBlock {
      // Code to be executed upon completion
      completion?()
    }
    tableView.deleteRows(at: pickerIndexPaths, with: .top)
    tableView.endUpdates()
    CATransaction.commit()
  }
}

extension FiltersViewController {
  enum Section: Int {
    case dates = 0
    case types
    case withinTime
    case participants
    case withinDistance
    case bookmark
    
    static var numberOfSections: Int {
      return 6
    }
    
    static var all: [Section] {
      return [.dates, .types, .withinTime, .participants, .withinDistance, .bookmark]
    }
    
    var title: String? {
      switch self {
      case .dates:
        return Strings.date()
      case .types:
        return Strings.event_types()
      case .withinTime:
        return Strings.starts_within()
      case .participants:
        return Strings.participants()
      case .withinDistance:
        return Strings.distance()
      case .bookmark:
        return nil
      }
    }
  }
  
  indirect enum DateRow {
    case from(date: Date?, minimumDate: Date?, maximumDate: Date?)
    case to(date: Date?, minimumDate: Date?, maximumDate: Date?)
    case picker(dateRow: DateRow)
    
    var label: String {
      switch self {
      case .from:
        return Strings.from()
      case .to:
        return Strings.to()
      default:
        return ""
      }
    }
  }
}

//MARK: - Reset View Delegate
extension FiltersViewController: ResetFiltersViewDelegate {
  func resetFiltersDidTap(_ view: ResetFiltersView) {
    viewModel.resetFilters()
    delegate?.filtersDidReset(self)
    navigationController?.popViewController(animated: true)
    
    //MARK: [Analytics] Event
    let analyticsEvent = Analytics.Event(category: .events, action: .resetAllFilters)
    Analytics.shared.send(event: analyticsEvent)
  }
}

//MARK: - Date Picker Cell Delegate
extension FiltersViewController: DatePickerCellDelegate {
  func datePickerCell(_ cell: DatePickerCell, didSelect date: Date) {
    if let selectedDateRow = viewModel.selectedDateRow {
      switch selectedDateRow {
      case .from:
        viewModel.setFrom(date: date)
      case .to:
        viewModel.setTo(date: date)
      default:
        return
      }
      refreshDateCells()
      resetWithinTimeSlider()
    }
  }
}

//MARK: - Switch Cell Delegate
extension FiltersViewController: SwitchCellDelegate {
  func switchCell(_ cell: SwitchCell, didSwitchOn isOn: Bool) {
    viewModel.setShowBookmarkedEvents(show: isOn)
  }
}

//MARK: - Slider Cell Delegate
extension FiltersViewController: SliderCellDelegate {
  func sliderCell(_ cell: SliderCell, selection index: Int) {
    guard let indexPath = tableView.indexPath(for: cell),
      let section = Section(rawValue: indexPath.section) else {
      return
    }
    
    switch section {
    case .withinTime:
      let displayValues = viewModel.setWithinTime(for: index)
      cell.setLabel(with: displayValues.selectedValue, unit: displayValues.unit)
      lockDateRanges(forSelectedWithin: displayValues.originalValue)
    case .withinDistance:
      let displayValues = viewModel.setWithinDistance(for: index)
      cell.setLabel(with: displayValues.selectedValue, unit: displayValues.unit)
    default:
      return
    }
  }
  
  func lockDateRanges(forSelectedWithin minutes: Int) {
    guard minutes != 0 else {
      return
    }
    let now = Date()
    viewModel.setFrom(date: now)
    viewModel.setTo(date: now)
    refreshDateCells()
  }
  
  func resetWithinTimeSlider() {
    let displayValues = viewModel.setWithinTime(for: 0)
    
    let indexPath = IndexPath(row: 0, section: Section.withinTime.rawValue)
    if let cell = self.tableView.cellForRow(at: indexPath) as? SliderCell {
      cell.setLabel(with: displayValues.selectedValue, unit: displayValues.unit)
    }
  }
}

//MARK: - Slider Cell Extension
extension SliderCell {
  fileprivate func setLabel(with value: String, unit: String) {
    let theme = ThemeManager.shared.current
    let valueString = NSMutableAttributedString(string: value, attributes:
      [NSForegroundColorAttributeName : theme.color2])
    let unitString = NSAttributedString(string: " \(unit)", attributes:
      [NSForegroundColorAttributeName : theme.darkTextColor])
    valueString.append(unitString)
    set(labelAttributedText: valueString)
  }
}
