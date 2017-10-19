//
//  View+Utils.swift
//  Movimenta
//
//  Created by Marwan  on 8/7/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension UIView {
  func manipulateLabelsSubviewsTopMarginsIfNeeded(exceptions: [UILabel] = []) {
    var didUpdateLayout = false
    let labelsArray: [UILabel] = self.subviews.flatMap({ ($0 as? UILabel) }).filter({ !exceptions.contains($0) })
    for label in labelsArray {
      if label.text == nil || (label.text?.isEmpty ?? true) {
        guard let topConstraint = self.constraints.topConstraints(item: label).first else {
          continue
        }
        topConstraint.constant = 0
        didUpdateLayout = true
      }
    }
    
    if didUpdateLayout {
      self.setNeedsLayout()
    }
  }
  
  private func randomize(interval: TimeInterval, withVariance variance: Double) -> Double{
    let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
    return interval + variance * random
  }
  
  func shake() {
    let transformAnim  = CAKeyframeAnimation(keyPath:"transform")
    transformAnim.values  = [
      NSValue(caTransform3D: CATransform3DMakeRotation(0.04, 0.0, 0.0, 1.0)),
      NSValue(caTransform3D: CATransform3DMakeRotation(-0.04 , 0, 0, 1))
    ]
  
    transformAnim.autoreverses = true
    transformAnim.duration = randomize(interval: 0.1, withVariance: 0.25)
    transformAnim.repeatCount = Float.infinity
    layer.add(transformAnim, forKey: "transform")
  }
  
  func stopShaking() {
    layer.removeAllAnimations()
  }
}

extension UIView {
  public static var defaultNibName: String {
    return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
  }
  
  public static func loadFromView<V: UIView>(_ view: V.Type, owner: Any?) -> V {
    let defaultNib = view.defaultNibName
    guard let viewInstance = Bundle.main.loadNibNamed(
      defaultNib,
      owner: owner,
      options: nil)?[0] as? V else {
        fatalError("Couldn't load view with nibName '\(defaultNib)'")
    }
    return viewInstance
  }
  
  /**
   This method is to be called from
   
   `func awakeAfter(using aDecoder: NSCoder) -> Any?`
   
   Load a view from its relative nib file in case the view was
   integrated in the storyboard. Otherwise the view will be blank.
   */
  func viewForNibNameIfNeeded(nibName: String) -> Any? {
    let isJustAPlaceholder = self.subviews.count == 0
    
    guard isJustAPlaceholder else {
      return self
    }
    
    guard let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?[0] as? UIView else {
      fatalError("Couldn't load view with nibName '\(nibName)'")
    }
    
    view.autoresizingMask = self.autoresizingMask
    view.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints
    
    for constraint in self.constraints {
      var firstItem = constraint.firstItem as? NSObject
      if firstItem == self {
        firstItem = view
      }
      
      var secondItem = constraint.secondItem as? NSObject
      if secondItem == self {
        secondItem = view
      }
      
      let newConstraint = NSLayoutConstraint(
        item: firstItem!,
        attribute: constraint.firstAttribute,
        relatedBy: constraint.relation,
        toItem: secondItem,
        attribute: constraint.secondAttribute,
        multiplier: constraint.multiplier,
        constant: constraint.constant)
      
      view.addConstraint(newConstraint)
    }
    
    self.removeConstraints(self.constraints)
    
    return view
  }
}
