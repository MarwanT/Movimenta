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

  // TODO: Recheck logic, and import logic from bookwitty app
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
      }
    }
    return ranges
  }

  func isValidEmail() -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: self)
  }

  func base64Decoded() -> String? {
    if let data = Data(base64Encoded: self) {
      return String(data: data, encoding: .utf8)
    }
    return nil
  }
}
