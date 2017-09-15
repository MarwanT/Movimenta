//
//  ScheduleViewController.swift
//  Movimenta
//
//  Created by Marwan  on 9/13/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
  @IBOutlet weak var datesCollectionView: UICollectionView!
  
  var viewModel = ScheduleViewModel()
  
  static func instance() -> ScheduleViewController {
    return Storyboard.Event.instantiate(ScheduleViewController.self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initializeCollectionView()
  }
  
  private func initializeCollectionView() {
    // Featured Content View
    let interItemSpacing: CGFloat = 10
    let contentInset = UIEdgeInsets(
      top: 0, left: CGFloat(ThemeManager.shared.current.space7),
      bottom: 0, right: CGFloat(ThemeManager.shared.current.space7))
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
    flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
    flowLayout.minimumInteritemSpacing = interItemSpacing
    datesCollectionView.collectionViewLayout = flowLayout
    datesCollectionView.register(ScheduleCell.self, forCellWithReuseIdentifier: ScheduleCell.identifier)
    datesCollectionView.backgroundColor = ThemeManager.shared.current.color2
    datesCollectionView.contentInset = contentInset
    datesCollectionView.showsHorizontalScrollIndicator = false
  }
}
