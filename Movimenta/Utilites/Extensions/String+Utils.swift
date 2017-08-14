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
}
