//
//  InformationListingViewController.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/17/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

class InformationListingViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  let viewModel = InformationListingViewModel()

  func initialize(with mode: InformationListingViewModel.Mode) {
    viewModel.initialize(with: mode)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }

  private func initialize() {
    //All Initializations and Setup
    applyTheme()
    setupView()
  }

  private func applyTheme() {
    //TODO: apply theme
  }

  private func setupView() {
    title = viewModel.vcTitle()
    //Additional: setup view
    setupTable()
  }

  private func setupTable() {
    let theme = ThemeManager.shared.current

    tableView.tableFooterView = UIView(frame: CGRect.zero)

    tableView.delegate = self
    tableView.dataSource = self

    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 220

    tableView.separatorStyle = .singleLine
    tableView.separatorColor = theme.separatorColor

    tableView.register(InformationCell.nib, forCellReuseIdentifier: InformationCell.identifier)
  }
}

extension InformationListingViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRowForSection(section: section)
  }

  public func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: InformationCell.identifier, for: indexPath) as? InformationCell else {
      return UITableViewCell()
    }
    let item = viewModel.itemAtIndexPath(indexPath: indexPath)
    cell.set(imageURL: item?.image, title: item?.name)

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let item = viewModel.itemAtIndexPath(indexPath: indexPath)
    guard let url = item?.link else {
      return
    }

    WebViewController.present(url: url, inViewController: navigationController)
  }
}

extension InformationListingViewController {
  static func instance() -> InformationListingViewController {
    return Storyboard.Information.instantiate(InformationListingViewController.self)
  }
}
