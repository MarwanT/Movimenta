//
//  String+Utils.swift
//  Movimenta
//
//  Created by Marwan  on 8/9/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation

extension String {
  func trimed() -> String {
    return self.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  var capitalizeFirst: String {
    let firstIndex = self.index(startIndex, offsetBy: 1)
    return self.substring(to: firstIndex).capitalized + self.substring(from: firstIndex).lowercased()
  }
}
