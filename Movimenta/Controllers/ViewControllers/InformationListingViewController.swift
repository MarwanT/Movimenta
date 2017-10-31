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
  
  fileprivate let noInformationView = NoInformationView.instanceFromNib()
  
  let viewModel = InformationListingViewModel()
  
  fileprivate var animationDuration = ThemeManager.shared.current.animationDuration

  func initialize(with mode: InformationListingViewModel.Mode) {
    viewModel.initialize(with: mode)
    noInformationView.initialize(with: mode)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //MARK: [Analytics] Screen Name
    Analytics.shared.send(screenName: screenName)
  }
  
  private var screenName: Analytics.ScreenName {
    switch viewModel.mode {
    case .hotels:
      return Analytics.ScreenNames.Hotels
    case .restaurants:
      return Analytics.ScreenNames.Restaurants
    }
  }

  private func initialize() {
    //All Initializations and Setup
    applyTheme()
    setupView()
    initializeNoInformationView()
  }

  private func applyTheme() {
    //TODO: apply theme
  }

  private func setupView() {
    title = viewModel.vcTitle()
    navigationItem.backBarButtonItem = UIBarButtonItem.back
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
    
    tableView.allowsSelection = false

    tableView.register(InformationCell.nib, forCellReuseIdentifier: InformationCell.identifier)
  }
  
  private func initializeNoInformationView() {
    view.addSubview(noInformationView)
    noInformationView.snp.makeConstraints { (maker) in
      maker.edges.equalTo(tableView)
    }
  }
}

extension InformationListingViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    refreshViewForNumberOfVisibleInformation()
    return viewModel.numberOfRows()
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
    cell.delegate = self

    return cell
  }
  
  fileprivate func refreshViewForNumberOfVisibleInformation() {
    if viewModel.numberOfRows() > 0 {
      hideNoInformationView()
    } else {
      showNoInformationView()
    }
  }
  
  fileprivate func showNoInformationView() {
    noInformationView.isHidden = false
    noInformationView.alpha = 0
    UIView.animate(withDuration: animationDuration, animations: {
      self.noInformationView.alpha = 1
    })
  }
  
  fileprivate func hideNoInformationView() {
    UIView.animate(withDuration: animationDuration, animations: {
      self.noInformationView.alpha = 0
    }, completion: { (finished) in
      self.noInformationView.isHidden = true
    })
  }
}

extension InformationListingViewController: InformationCellDelegate {
  func informationCellDidTapViewButton(_ cell: InformationCell) {
    guard let indexPath = tableView.indexPath(for: cell),
      let item = viewModel.itemAtIndexPath(indexPath: indexPath),
      let url = item.link else {
      return
    }
    
    WebViewController.present(url: url, inViewController: navigationController)
    
    //MARK: [Analytics] Event
    let analyticsAction: Analytics.Action = viewModel.mode == .hotels ? .goToHotel : .goToRestaurant
    let analyticsEvent = Analytics.Event(category: .info, action: analyticsAction, name: item.name ?? "")
    Analytics.shared.send(event: analyticsEvent)
  }
}

extension InformationListingViewController {
  static func instance() -> InformationListingViewController {
    return Storyboard.Information.instantiate(InformationListingViewController.self)
  }
}
