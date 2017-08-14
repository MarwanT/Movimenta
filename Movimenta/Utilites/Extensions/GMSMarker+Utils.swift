//
//  GMSMarker+Utils.swift
//  Movimenta
//
//  Created by Marwan  on 8/2/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import GoogleMaps

extension GMSMarker {
  static func movimentaMarker(position: CLLocationCoordinate2D) -> GMSMarker {
    let marker = GMSMarker(position: position)
    marker.iconView = markerIconView()
    marker.tracksViewChanges = true
    return marker
  }
  
  private static func markerIconView() -> UIView {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "pinMapOutlineBlue"), highlightedImage: #imageLiteral(resourceName: "pinMapFilled"))
    imageView.contentMode = UIViewContentMode.scaleAspectFit
    imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    imageView.tintColor = ThemeManager.shared.current.color2
    return imageView
  }
  
  var iconImageView: UIImageView? {
    return iconView as? UIImageView
  }
}
