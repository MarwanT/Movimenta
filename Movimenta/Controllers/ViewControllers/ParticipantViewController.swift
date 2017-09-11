//
//  ParticipantViewController.swift
//  Movimenta
//
//  Created by Marwan  on 9/11/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class ParticipantViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  fileprivate var headerView: ParticipantDetailsHeaderView!
  fileprivate var eventDetailsLabel: ParallaxLabel!
  
  var viewModel = ParticipantViewModel()
  
  static func instance() -> ParticipantViewController {
    return Storyboard.Event.instantiate(ParticipantViewController.self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    // #Required for the headerView to take the required size of it's content
    resizeHeaderView()
  }
  
  func initialize(with participant: Participant) {
    viewModel.initialize(with: participant)
  }
  
  private func initialize() {
    initializeTableView()
    loadData()
  }
  
  private func initializeTableView() {
    let theme = ThemeManager.shared.current
    
    initializeTableViewHeader()
    
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    
    tableView.layoutMargins = UIEdgeInsets(
      top: 0, left: CGFloat(theme.space7),
      bottom: 0, right: CGFloat(theme.space7))
    
    tableView.separatorStyle = .singleLine
    tableView.separatorColor = theme.separatorColor
  }
  
  private func initializeTableViewHeader() {
    let theme = ThemeManager.shared.current
    
    headerView = ParticipantDetailsHeaderView.instanceFromNib()
    headerView.delegate = self
    eventDetailsLabel = ParallaxLabel.instanceFromNib()
    eventDetailsLabel.layoutMargins = UIEdgeInsets(
      top: CGFloat(theme.space8), left: CGFloat(theme.space7),
      bottom: CGFloat(theme.space8), right: CGFloat(theme.space7))
    
    let view = UIView(frame: CGRect.zero)
    view.addSubview(headerView)
    view.addSubview(eventDetailsLabel)
    headerView.snp.makeConstraints { (maker) in
      maker.left.top.right.equalTo(view)
      maker.bottom.equalTo(eventDetailsLabel.snp.top)
    }
    eventDetailsLabel.snp.makeConstraints { (maker) in
      maker.left.bottom.right.equalTo(view)
    }
    tableView.tableHeaderView = view
  }
  
  private func loadData() {
    loadHeaderViewData()
  }
  
  private func loadHeaderViewData() {
    headerView.loadView(with:
      (image: viewModel.image,
       name: viewModel.name,
       roles: viewModel.roles,
       description: viewModel.description))
    eventDetailsLabel.set(text: Strings.related_events())
    resizeHeaderView()
  }
  
  fileprivate func resizeHeaderView(size: CGSize? = nil) {
    let chosenSize: CGSize = size != nil ? size! : tableHeaderPreferredSize
    tableView.tableHeaderView?.frame.size = chosenSize
    tableView.reloadData()
  }
  
  fileprivate var tableHeaderPreferredSize: CGSize {
    return CGSize(
      width: view.frame.width,
      height: headerView.preferredSize().height + eventDetailsLabel.preferredSize().height)
  }
}

//MARK: Actions
extension ParticipantViewController {
  private func shareParticipant(info: [Any]) {
    presentShareSheet(with: info)
  }
}

//MARK: Header View Delegates
extension ParticipantViewController: ParticipantDetailsHeaderViewDelegate {
  func participantDetailsHeaderDidChangeSize(_ headerView: ParticipantDetailsHeaderView, size: CGSize) {
    resizeHeaderView()
  }
}

//MARK: Table View Delegates
extension ParticipantViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
}
