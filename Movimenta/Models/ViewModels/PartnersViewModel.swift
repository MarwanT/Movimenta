//
//  PartnersViewModel.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

class PartnersViewModel {
  fileprivate var data: [PartnerGroup] = []

  init() {
    self.data = DataManager.shared.partnerGroups
  }
  
  var viewControllerTitle: String {
    return Strings.partners()
  }

  func itemForSection(section: Int) -> PartnerGroup? {
    guard data.count > section else {
      return nil
    }
    let item = data[section]
    return item
  }

  fileprivate func itemFor(row: Int, section: Int) -> Partner? {
    let section = itemForSection(section: section)
    guard let partners = section?.partners, partners.count > row else {
      return nil
    }
    let item = partners[row]
    return item
  }
}

//MARK: Table view helpers
extension PartnersViewModel {
  func numberOfSections() -> Int {
    return data.count
  }

  func numberOfRowForSection(section: Int) -> Int {
    return data[section].partners?.count ?? 0
  }

  func itemAtIndexPath(indexPath: IndexPath) -> Partner? {
    return itemFor(row: indexPath.row, section: indexPath.section)
  }
}
