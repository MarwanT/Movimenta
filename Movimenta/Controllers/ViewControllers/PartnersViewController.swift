//
//  PartnersViewController.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

class PartnersViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  let viewModel: PartnersViewModel = PartnersViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }

  private func initialize() {
    //All Initializations and Setup
    tableView.delegate = self
    tableView.dataSource = self
    applyTheme()
    setupView()
  }

  private func setupView() {
    let theme = ThemeManager.shared.current

    //Addtional needed setup
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    tableView.separatorStyle = .singleLine
    tableView.separatorColor = theme.separatorColor
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 220
    tableView.sectionHeaderHeight = UITableViewAutomaticDimension
    tableView.estimatedSectionHeaderHeight = 40

    tableView.register(PartnerCell.nib, forCellReuseIdentifier: PartnerCell.identifier)
  }

  private func applyTheme() {
    //TODO: Apply style
  }
}

extension PartnersViewController: UITableViewDataSource, UITableViewDelegate {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRowForSection(section: section)
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PartnerCell.identifier, for: indexPath) as? PartnerCell else {
      return UITableViewCell()
    }
    guard let item = viewModel.itemAtIndexPath(indexPath: indexPath) else {
      return cell
    }
    cell.setup(title: item.name, description: item.description, imageURL: item.image)
    return cell
  }
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections()
  }

  public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return viewModel.itemForSection(section: section)?.title ?? "No Title"
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    //TODO: action
  }
}

extension PartnersViewController {
  static func instance() -> PartnersViewController {
    return Storyboard.Information.instantiate(PartnersViewController.self)
  }
}
