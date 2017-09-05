//
//  FiltersViewController.swift
//  Movimenta
//
//  Created by Marwan  on 8/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  fileprivate var fromDateCell: DatePickerCell!
  fileprivate var toDateCell: DatePickerCell!
  
  var viewModel = FiltersViewModel()
  
  static func instance() -> FiltersViewController {
    return Storyboard.Filter.instantiate(FiltersViewController.self)
  }
  
  func initialize(with filter: Filter) {
    viewModel.initialize(with: filter)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initializeTableView()
  }
  
  private func setup() {
    fromDateCell = DatePickerCell.instanceFromNib()
    toDateCell = DatePickerCell.instanceFromNib()
    fromDateCell.configuration.labelText = Strings.from()
    toDateCell.configuration.labelText = Strings.to()
    fromDateCell.delegate = self
    toDateCell.delegate = self
  }
  
  private func initializeTableView() {
    let theme = ThemeManager.shared.current
    
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
    
    tableView.register(FiltersSectionHeader.self, forHeaderFooterViewReuseIdentifier: FiltersSectionHeader.identifier)
    tableView.register(ExpandableHeaderCell.nib, forCellReuseIdentifier: ExpandableHeaderCell.identifier)
    tableView.register(SelectableCell.nib, forCellReuseIdentifier: SelectableCell.identifier)
    tableView.register(SwitchCell.nib, forCellReuseIdentifier: SwitchCell.identifier)
    tableView.register(SliderCell.nib, forCellReuseIdentifier: SliderCell.identifier)
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
      guard let dateRow = DateRow(rawValue: indexPath.row) else {
        return UITableViewCell()
      }
      let values = viewModel.dateInfo(for: dateRow)
      let cell: DatePickerCell = dateRow == .from ? fromDateCell : toDateCell
      cell.set(date: values.date)
      cell.set(minimumDate: values.minimumDate)
      cell.set(maximumDate: values.maximumDate)
      return cell
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
      case .child(let label, let selection, let isLastChild, _):
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableCell.identifier, for: indexPath) as? SelectableCell else {
          return UITableViewCell()
        }
        cell.label.text = label
        cell.indentationLevel = 1
        isLastChild ? cell.showSeparator() : cell.hideSeparator()
        if cell.isSelected == false && (selection == .all || selection == .some ) {
          tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
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
      case .child(let label, let selection, let isLastChild, _):
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableCell.identifier, for: indexPath) as? SelectableCell else {
          return UITableViewCell()
        }
        cell.label.text = label
        cell.indentationLevel = 1
        isLastChild ? cell.showSeparator() : cell.hideSeparator()
        if cell.isSelected == false && (selection == .all || selection == .some ) {
          tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
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
      guard let dateRow = DateRow(rawValue: indexPath.row) else {
        return
      }
      switch dateRow {
      case .from:
        deselectDatePickerCell(except: fromDateCell)
      case .to:
        deselectDatePickerCell(except: toDateCell)
      }
    case .types:
      if let (_, affectedIndexPaths) = viewModel.selectCategory(at: indexPath) {
        tableView.insertRows(at: affectedIndexPaths, with: .fade)
        if let lastIndexPath = affectedIndexPaths.last {
          tableView.scrollToRow(at: lastIndexPath, at: .none, animated: true)
        }
      }
      deselectDatePickerCell()
    case .participants:
      if let (_, affectedIndexPaths) = viewModel.selectParticipant(at: indexPath) {
        tableView.insertRows(at: affectedIndexPaths, with: .fade)
        if let lastIndexPath = affectedIndexPaths.last {
          tableView.scrollToRow(at: lastIndexPath, at: .none, animated: true)
        }
      }
      deselectDatePickerCell()
    default:
      deselectDatePickerCell()
      return
    }
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    guard let section = Section(rawValue: indexPath.section) else {
      return
    }
    
    switch section {
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
  
  fileprivate func refreshDateCells() {
    let fromData = viewModel.dateInfo(for: .from)
    let toData = viewModel.dateInfo(for: .to)
    fromDateCell.set(date: fromData.date)
    fromDateCell.set(minimumDate: fromData.minimumDate)
    fromDateCell.set(maximumDate: fromData.maximumDate)
    toDateCell.set(date: toData.date)
    toDateCell.set(minimumDate: toData.minimumDate)
    toDateCell.set(maximumDate: toData.maximumDate)
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    deselectDatePickerCell()
  }
  
  /// If the passed parameter was nil then both date picker cells are deselected
  func deselectDatePickerCell(except datePickerCell: DatePickerCell? = nil) {
    var indexPaths = [IndexPath]()
    if datePickerCell !== fromDateCell && fromDateCell.isSelected {
      indexPaths.append(IndexPath(row: DateRow.from.rawValue, section: Section.dates.rawValue))
    }
    if datePickerCell !== toDateCell && toDateCell.isSelected {
      indexPaths.append(IndexPath(row: DateRow.to.rawValue, section: Section.dates.rawValue))
    }
    indexPaths.forEach { (indexPath) in
      tableView.deselectRow(at: indexPath, animated: true)
    }
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
  
  enum DateRow: Int {
    case from = 0
    case to
    
    static var numberOfRows: Int {
      return 2
    }
  }
}

//MARK: - Date Picker Cell Delegate
extension FiltersViewController: DatePickerCellDelegate {
  func datePickerCellDidSelectDate(_ cell: DatePickerCell, date: Date) {
    if cell === fromDateCell {
      viewModel.setFrom(date: date)
    } else {
      viewModel.setTo(date: date)
    }
    refreshDateCells()
  }

  func datePickerCellDidUpdatePickerVisibility(_ cell: DatePickerCell, isVisible: Bool) {
    updateTableView()
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
    case .withinDistance:
      let displayValues = viewModel.setWithinDistance(for: index)
      cell.setLabel(with: displayValues.selectedValue, unit: displayValues.unit)
    default:
      return
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
