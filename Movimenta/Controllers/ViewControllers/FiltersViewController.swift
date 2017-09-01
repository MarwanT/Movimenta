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
    default:
      return UITableViewCell()
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
      return nil
    }
    
    switch section {
    case .dates:
      let cell = tableView.cellForRow(at: indexPath)
      if (cell?.isSelected ?? false) {
        tableView.deselectRow(at: indexPath, animated: true)
        return nil
      } else {
        return indexPath
      }
    default:
      return indexPath
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let section = Section(rawValue: indexPath.section) else {
      return
    }
    
    switch section {
    case .types:
      if let (_, affectedIndexPaths) = viewModel.selectCategory(at: indexPath) {
        tableView.insertRows(at: affectedIndexPaths, with: .fade)
      }
    default:
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

