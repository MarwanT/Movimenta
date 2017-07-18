//
//  FontBook.swift
//  Movimenta
//
//  Created by Marwan  on 7/18/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit

enum FontBook: String {
  case title1
  case title2
  case title3
  case title4
  case title5
  case body1
  case header1
  case listTitle
  case listBody
  case action1
  case action2
  case label1
  case label2
  case label3
  case filter
  case menu1
  case menu2
}

extension FontBook {
  fileprivate static var fontSizeTable: [String: [UIContentSizeCategory:CGFloat]] = [
    FontBook.title1.rawValue : [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 36,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 36,
      UIContentSizeCategory.accessibilityExtraLarge: 36,
      UIContentSizeCategory.accessibilityLarge: 36,
      UIContentSizeCategory.accessibilityMedium: 36,
      UIContentSizeCategory.extraExtraExtraLarge: 36,
      UIContentSizeCategory.extraExtraLarge: 34,
      UIContentSizeCategory.extraLarge: 32,
      UIContentSizeCategory.large: 30,
      UIContentSizeCategory.medium: 29,
      UIContentSizeCategory.small: 28,
      UIContentSizeCategory.extraSmall: 27
    ],
    FontBook.title2.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 30,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 30,
      UIContentSizeCategory.accessibilityExtraLarge: 30,
      UIContentSizeCategory.accessibilityLarge: 30,
      UIContentSizeCategory.accessibilityMedium: 30,
      UIContentSizeCategory.extraExtraExtraLarge: 30,
      UIContentSizeCategory.extraExtraLarge: 28,
      UIContentSizeCategory.extraLarge: 26,
      UIContentSizeCategory.large: 24,
      UIContentSizeCategory.medium: 23,
      UIContentSizeCategory.small: 22,
      UIContentSizeCategory.extraSmall: 21
    ],
    FontBook.title3.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 30,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 30,
      UIContentSizeCategory.accessibilityExtraLarge: 30,
      UIContentSizeCategory.accessibilityLarge: 30,
      UIContentSizeCategory.accessibilityMedium: 30,
      UIContentSizeCategory.extraExtraExtraLarge: 30,
      UIContentSizeCategory.extraExtraLarge: 28,
      UIContentSizeCategory.extraLarge: 26,
      UIContentSizeCategory.large: 24,
      UIContentSizeCategory.medium: 23,
      UIContentSizeCategory.small: 22,
      UIContentSizeCategory.extraSmall: 21
    ],
    FontBook.title4.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 28,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 28,
      UIContentSizeCategory.accessibilityExtraLarge: 28,
      UIContentSizeCategory.accessibilityLarge: 28,
      UIContentSizeCategory.accessibilityMedium: 28,
      UIContentSizeCategory.extraExtraExtraLarge: 28,
      UIContentSizeCategory.extraExtraLarge: 26,
      UIContentSizeCategory.extraLarge: 24,
      UIContentSizeCategory.large: 22,
      UIContentSizeCategory.medium: 21,
      UIContentSizeCategory.small: 20,
      UIContentSizeCategory.extraSmall: 19
    ],
    FontBook.title5.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 24,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 24,
      UIContentSizeCategory.accessibilityExtraLarge: 24,
      UIContentSizeCategory.accessibilityLarge: 24,
      UIContentSizeCategory.accessibilityMedium: 24,
      UIContentSizeCategory.extraExtraExtraLarge: 24,
      UIContentSizeCategory.extraExtraLarge: 22,
      UIContentSizeCategory.extraLarge: 20,
      UIContentSizeCategory.large: 18,
      UIContentSizeCategory.medium: 17,
      UIContentSizeCategory.small: 16,
      UIContentSizeCategory.extraSmall: 15
    ],
    FontBook.body1.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 24,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 24,
      UIContentSizeCategory.accessibilityExtraLarge: 24,
      UIContentSizeCategory.accessibilityLarge: 24,
      UIContentSizeCategory.accessibilityMedium: 24,
      UIContentSizeCategory.extraExtraExtraLarge: 24,
      UIContentSizeCategory.extraExtraLarge: 22,
      UIContentSizeCategory.extraLarge: 20,
      UIContentSizeCategory.large: 18,
      UIContentSizeCategory.medium: 17,
      UIContentSizeCategory.small: 16,
      UIContentSizeCategory.extraSmall: 15
    ],
    FontBook.header1.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 23,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 23,
      UIContentSizeCategory.accessibilityExtraLarge: 23,
      UIContentSizeCategory.accessibilityLarge: 23,
      UIContentSizeCategory.accessibilityMedium: 23,
      UIContentSizeCategory.extraExtraExtraLarge: 23,
      UIContentSizeCategory.extraExtraLarge: 21,
      UIContentSizeCategory.extraLarge: 19,
      UIContentSizeCategory.large: 17,
      UIContentSizeCategory.medium: 16,
      UIContentSizeCategory.small: 15,
      UIContentSizeCategory.extraSmall: 14
    ],
    FontBook.listTitle.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 23,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 23,
      UIContentSizeCategory.accessibilityExtraLarge: 23,
      UIContentSizeCategory.accessibilityLarge: 23,
      UIContentSizeCategory.accessibilityMedium: 23,
      UIContentSizeCategory.extraExtraExtraLarge: 23,
      UIContentSizeCategory.extraExtraLarge: 21,
      UIContentSizeCategory.extraLarge: 19,
      UIContentSizeCategory.large: 17,
      UIContentSizeCategory.medium: 16,
      UIContentSizeCategory.small: 15,
      UIContentSizeCategory.extraSmall: 14
    ],
    FontBook.listBody.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 23,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 23,
      UIContentSizeCategory.accessibilityExtraLarge: 23,
      UIContentSizeCategory.accessibilityLarge: 23,
      UIContentSizeCategory.accessibilityMedium: 23,
      UIContentSizeCategory.extraExtraExtraLarge: 23,
      UIContentSizeCategory.extraExtraLarge: 21,
      UIContentSizeCategory.extraLarge: 19,
      UIContentSizeCategory.large: 17,
      UIContentSizeCategory.medium: 16,
      UIContentSizeCategory.small: 15,
      UIContentSizeCategory.extraSmall: 14
    ],
    FontBook.action1.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 22,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 22,
      UIContentSizeCategory.accessibilityExtraLarge: 22,
      UIContentSizeCategory.accessibilityLarge: 22,
      UIContentSizeCategory.accessibilityMedium: 22,
      UIContentSizeCategory.extraExtraExtraLarge: 22,
      UIContentSizeCategory.extraExtraLarge: 20,
      UIContentSizeCategory.extraLarge: 18,
      UIContentSizeCategory.large: 16,
      UIContentSizeCategory.medium: 15,
      UIContentSizeCategory.small: 14,
      UIContentSizeCategory.extraSmall: 13
    ],
    FontBook.action2.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 22,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 22,
      UIContentSizeCategory.accessibilityExtraLarge: 22,
      UIContentSizeCategory.accessibilityLarge: 22,
      UIContentSizeCategory.accessibilityMedium: 22,
      UIContentSizeCategory.extraExtraExtraLarge: 22,
      UIContentSizeCategory.extraExtraLarge: 20,
      UIContentSizeCategory.extraLarge: 18,
      UIContentSizeCategory.large: 16,
      UIContentSizeCategory.medium: 15,
      UIContentSizeCategory.small: 14,
      UIContentSizeCategory.extraSmall: 13
    ],
    FontBook.label1.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 20,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 20,
      UIContentSizeCategory.accessibilityExtraLarge: 20,
      UIContentSizeCategory.accessibilityLarge: 20,
      UIContentSizeCategory.accessibilityMedium: 20,
      UIContentSizeCategory.extraExtraExtraLarge: 20,
      UIContentSizeCategory.extraExtraLarge: 18,
      UIContentSizeCategory.extraLarge: 16,
      UIContentSizeCategory.large: 14,
      UIContentSizeCategory.medium: 13,
      UIContentSizeCategory.small: 12,
      UIContentSizeCategory.extraSmall: 11
    ],
    FontBook.label2.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 20,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 20,
      UIContentSizeCategory.accessibilityExtraLarge: 20,
      UIContentSizeCategory.accessibilityLarge: 20,
      UIContentSizeCategory.accessibilityMedium: 20,
      UIContentSizeCategory.extraExtraExtraLarge: 20,
      UIContentSizeCategory.extraExtraLarge: 18,
      UIContentSizeCategory.extraLarge: 16,
      UIContentSizeCategory.large: 14,
      UIContentSizeCategory.medium: 13,
      UIContentSizeCategory.small: 12,
      UIContentSizeCategory.extraSmall: 11
    ],
    FontBook.label3.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 19,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 19,
      UIContentSizeCategory.accessibilityExtraLarge: 19,
      UIContentSizeCategory.accessibilityLarge: 19,
      UIContentSizeCategory.accessibilityMedium: 19,
      UIContentSizeCategory.extraExtraExtraLarge: 19,
      UIContentSizeCategory.extraExtraLarge: 17,
      UIContentSizeCategory.extraLarge: 15,
      UIContentSizeCategory.large: 13,
      UIContentSizeCategory.medium: 12,
      UIContentSizeCategory.small: 11,
      UIContentSizeCategory.extraSmall: 10
    ],
    FontBook.filter.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 19,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 19,
      UIContentSizeCategory.accessibilityExtraLarge: 19,
      UIContentSizeCategory.accessibilityLarge: 19,
      UIContentSizeCategory.accessibilityMedium: 19,
      UIContentSizeCategory.extraExtraExtraLarge: 19,
      UIContentSizeCategory.extraExtraLarge: 17,
      UIContentSizeCategory.extraLarge: 15,
      UIContentSizeCategory.large: 13,
      UIContentSizeCategory.medium: 12,
      UIContentSizeCategory.small: 11,
      UIContentSizeCategory.extraSmall: 10
    ],
    FontBook.menu1.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 17,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 17,
      UIContentSizeCategory.accessibilityExtraLarge: 17,
      UIContentSizeCategory.accessibilityLarge: 17,
      UIContentSizeCategory.accessibilityMedium: 17,
      UIContentSizeCategory.extraExtraExtraLarge: 17,
      UIContentSizeCategory.extraExtraLarge: 15,
      UIContentSizeCategory.extraLarge: 13,
      UIContentSizeCategory.large: 11,
      UIContentSizeCategory.medium: 10,
      UIContentSizeCategory.small: 9,
      UIContentSizeCategory.extraSmall: 8
    ],
    FontBook.menu2.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 17,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 17,
      UIContentSizeCategory.accessibilityExtraLarge: 17,
      UIContentSizeCategory.accessibilityLarge: 17,
      UIContentSizeCategory.accessibilityMedium: 17,
      UIContentSizeCategory.extraExtraExtraLarge: 17,
      UIContentSizeCategory.extraExtraLarge: 15,
      UIContentSizeCategory.extraLarge: 13,
      UIContentSizeCategory.large: 11,
      UIContentSizeCategory.medium: 10,
      UIContentSizeCategory.small: 9,
      UIContentSizeCategory.extraSmall: 8
    ]
  ]
}
