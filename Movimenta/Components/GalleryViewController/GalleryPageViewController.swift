//
//  GalleryPageViewController.swift
//  Movimenta
//
//  Created by Marwan  on 9/22/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

protocol GalleryPageViewControllerDelegate: class {
  func galleryPage(_ controller: GalleryPageViewController, didTap image: UIImage?, with url: URL?)
  func galleryPage(_ controller: GalleryPageViewController, didLoad image: UIImage)
}

class GalleryPageViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  
  fileprivate var imageURL: URL?
  
  fileprivate var imagePlaceholder: UIImage?
  
  weak var delegate: GalleryPageViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
    fillContent()
  }
  
  private func initialize() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage(_:)))
    imageView.addGestureRecognizer(tapGesture)
    imageView.isUserInteractionEnabled = true
  }
  
  func initialize(with imageURL: URL?, imagePlaceholder: UIImage?) {
    self.imagePlaceholder = imagePlaceholder
    self.imageURL = imageURL
  }
  
  private func fillContent() {
    imageView.sd_setImage(with: self.imageURL, placeholderImage: #imageLiteral(resourceName: "imagePlaceholderLarge"), options: []) { (image, _, _, _) in
      guard let image = image else {
        return
      }
      self.delegate?.galleryPage(self, didLoad: image)
    }
  }
  
  func didTapImage(_ sender: UITapGestureRecognizer) {
    delegate?.galleryPage(self, didTap: imageView.image, with: imageURL)
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
