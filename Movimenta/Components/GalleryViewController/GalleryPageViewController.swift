//
//  GalleryPageViewController.swift
//  Movimenta
//
//  Created by Marwan  on 9/22/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

class GalleryPageViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  
  fileprivate var imageURL: URL?
  
  fileprivate var imagePlaceholder: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fillContent()
  }
  
  func initialize(with imageURL: URL?, imagePlaceholder: UIImage?) {
    self.imagePlaceholder = imagePlaceholder
    self.imageURL = imageURL
  }
  
  private func fillContent() {
    imageView.sd_setImage(with: self.imageURL, placeholderImage: imagePlaceholder)
  }
}

//MARK: Instance
extension GalleryPageViewController {
  class var identifier: String {
    return "GalleryPageViewController"
  }
  
  class func instance() -> GalleryPageViewController {
    guard let vc = UIStoryboard(name: "Gallery", bundle: nil).instantiateViewController(withIdentifier: identifier) as? GalleryPageViewController else {
      fatalError("Couldn't instantiate \(GalleryPageViewController.identifier)")
    }
    return vc
  }
}