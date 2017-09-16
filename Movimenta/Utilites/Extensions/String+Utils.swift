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

  func rangesOfStringSurrounded(by delimiter: String) -> [NSRange] {
    //The Regex that Looks for delimiter followed by any character until it find the delimited 
    //again. 
    //The Resulting range does include the delimited locations.
    //If we want the Resulting range to not include the delimited locations, then
    //we should use position lookahead and lookbehind.
    //with the following Regex: "(?<=(\(delimiter))).*(?=(\(delimiter)))"
    let pat = "\(delimiter).*\(delimiter)"

    let regex = try! NSRegularExpression(pattern: pat, options: [])
    let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.characters.count))
    var ranges: [NSRange] = []

    for match in matches {
      for n in 0..<match.numberOfRanges {
        let range = match.rangeAt(n)
        ranges.append(range)
        let t = (self as NSString).substring(with: range)
      }
    }
    return ranges
  }
}
