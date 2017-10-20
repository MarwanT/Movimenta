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
  case tabLabel
  case tabLabelSelected
}

extension FontBook {
  var font: UIFont {
    let contentSize = UIApplication.shared.preferredContentSizeCategory
    let selectedSize = pointSize(forContentSize: contentSize)
    return font(for: self, size: selectedSize)
  }
  
  private func pointSize(forContentSize contentSize: UIContentSizeCategory) -> CGFloat {
    return FontBook.fontSizeTable[self.rawValue]![contentSize]!
  }
  
  private func font(for fontBook: FontBook, size: CGFloat) -> UIFont {
    var selectedFont = Font.nexaRegular
    
    switch fontBook {
    case .title1:
      selectedFont = Font.nexaBlack
    case .title2:
      selectedFont = Font.nexaBlack
    case .title3:
      selectedFont = Font.nexaRegular
    case .title4:
      selectedFont = Font.nexaBlack
    case .title5:
      selectedFont = Font.nexaBlack
    case .body1:
      selectedFont = Font.nexaRegular
    case .header1:
      selectedFont = Font.nexaBlack
    case .listTitle:
      selectedFont = Font.nexaBold
    case .listBody:
      selectedFont = Font.nexaRegular
    case .action1:
      selectedFont = Font.nexaBold
    case .action2:
      selectedFont = Font.nexaRegular
    case .label1:
      selectedFont = Font.nexaBlack
    case .label2:
      selectedFont = Font.nexaRegular
    case .label3:
      selectedFont = Font.nexaBlack
    case .filter:
      selectedFont = Font.nexaRegular
    case .menu1:
      selectedFont = Font.nexaBold
    case .menu2:
      selectedFont = Font.nexaRegular
    case .tabLabel:
      selectedFont = Font.nexaRegular
    case .tabLabelSelected:
      selectedFont = Font.nexaBold
    }
    
    return UIFont(name: selectedFont.rawValue, size: size)!
  }
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
    ],
    FontBook.tabLabel.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 9,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 9,
      UIContentSizeCategory.accessibilityExtraLarge: 9,
      UIContentSizeCategory.accessibilityLarge: 9,
      UIContentSizeCategory.accessibilityMedium: 9,
      UIContentSizeCategory.extraExtraExtraLarge: 9,
      UIContentSizeCategory.extraExtraLarge: 9,
      UIContentSizeCategory.extraLarge: 9,
      UIContentSizeCategory.large: 9,
      UIContentSizeCategory.medium: 9,
      UIContentSizeCategory.small: 9,
      UIContentSizeCategory.extraSmall: 9
    ],
    FontBook.tabLabelSelected.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 9,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 9,
      UIContentSizeCategory.accessibilityExtraLarge: 9,
      UIContentSizeCategory.accessibilityLarge: 9,
      UIContentSizeCategory.accessibilityMedium: 9,
      UIContentSizeCategory.extraExtraExtraLarge: 9,
      UIContentSizeCategory.extraExtraLarge: 9,
      UIContentSizeCategory.extraLarge: 9,
      UIContentSizeCategory.large: 9,
      UIContentSizeCategory.medium: 9,
      UIContentSizeCategory.small: 9,
      UIContentSizeCategory.extraSmall: 9
    ]
  ]
}


extension FontBook {
  var lineHeight: CGFloat? {
    let contentSize = UIApplication.shared.preferredContentSizeCategory
    return FontBook.fontLineHeightTable[self.rawValue]?[contentSize]
  }
}

extension FontBook {
  fileprivate static var fontLineHeightTable: [String: [UIContentSizeCategory:CGFloat]] = [
    FontBook.title1.rawValue : [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 47,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 47,
      UIContentSizeCategory.accessibilityExtraLarge: 47,
      UIContentSizeCategory.accessibilityLarge: 47,
      UIContentSizeCategory.accessibilityMedium: 47,
      UIContentSizeCategory.extraExtraExtraLarge: 40,
      UIContentSizeCategory.extraExtraLarge: 38,
      UIContentSizeCategory.extraLarge: 36,
      UIContentSizeCategory.large: 34,
      UIContentSizeCategory.medium: 33,
      UIContentSizeCategory.small: 32,
      UIContentSizeCategory.extraSmall: 31,
    ],
    FontBook.title2.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 39,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 39,
      UIContentSizeCategory.accessibilityExtraLarge: 39,
      UIContentSizeCategory.accessibilityLarge: 39,
      UIContentSizeCategory.accessibilityMedium: 39,
      UIContentSizeCategory.extraExtraExtraLarge: 39,
      UIContentSizeCategory.extraExtraLarge: 37,
      UIContentSizeCategory.extraLarge: 35,
      UIContentSizeCategory.large: 33,
      UIContentSizeCategory.medium: 32,
      UIContentSizeCategory.small: 31,
      UIContentSizeCategory.extraSmall: 30,
    ],
    FontBook.title3.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 39,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 39,
      UIContentSizeCategory.accessibilityExtraLarge: 39,
      UIContentSizeCategory.accessibilityLarge: 39,
      UIContentSizeCategory.accessibilityMedium: 39,
      UIContentSizeCategory.extraExtraExtraLarge: 39,
      UIContentSizeCategory.extraExtraLarge: 37,
      UIContentSizeCategory.extraLarge: 35,
      UIContentSizeCategory.large: 33,
      UIContentSizeCategory.medium: 32,
      UIContentSizeCategory.small: 31,
      UIContentSizeCategory.extraSmall: 30,
    ],
    FontBook.title4.rawValue: [
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
      UIContentSizeCategory.extraSmall: 27,
    ],
    FontBook.title5.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 30,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 30,
      UIContentSizeCategory.accessibilityExtraLarge: 30,
      UIContentSizeCategory.accessibilityLarge: 30,
      UIContentSizeCategory.accessibilityMedium: 30,
      UIContentSizeCategory.extraExtraExtraLarge: 30,
      UIContentSizeCategory.extraExtraLarge: 28,
      UIContentSizeCategory.extraLarge: 28,
      UIContentSizeCategory.large: 26,
      UIContentSizeCategory.medium: 25,
      UIContentSizeCategory.small: 24,
      UIContentSizeCategory.extraSmall: 23,
    ],
    FontBook.body1.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 30,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 30,
      UIContentSizeCategory.accessibilityExtraLarge: 30,
      UIContentSizeCategory.accessibilityLarge: 30,
      UIContentSizeCategory.accessibilityMedium: 30,
      UIContentSizeCategory.extraExtraExtraLarge: 30,
      UIContentSizeCategory.extraExtraLarge: 28,
      UIContentSizeCategory.extraLarge: 28,
      UIContentSizeCategory.large: 26,
      UIContentSizeCategory.medium: 25,
      UIContentSizeCategory.small: 24,
      UIContentSizeCategory.extraSmall: 23,
    ],
    FontBook.header1.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 31,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 31,
      UIContentSizeCategory.accessibilityExtraLarge: 31,
      UIContentSizeCategory.accessibilityLarge: 31,
      UIContentSizeCategory.accessibilityMedium: 31,
      UIContentSizeCategory.extraExtraExtraLarge: 31,
      UIContentSizeCategory.extraExtraLarge: 29,
      UIContentSizeCategory.extraLarge: 27,
      UIContentSizeCategory.large: 25,
      UIContentSizeCategory.medium: 24,
      UIContentSizeCategory.small: 23,
      UIContentSizeCategory.extraSmall: 22,
    ],
    FontBook.listTitle.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 31,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 31,
      UIContentSizeCategory.accessibilityExtraLarge: 31,
      UIContentSizeCategory.accessibilityLarge: 31,
      UIContentSizeCategory.accessibilityMedium: 31,
      UIContentSizeCategory.extraExtraExtraLarge: 31,
      UIContentSizeCategory.extraExtraLarge: 29,
      UIContentSizeCategory.extraLarge: 27,
      UIContentSizeCategory.large: 25,
      UIContentSizeCategory.medium: 24,
      UIContentSizeCategory.small: 23,
      UIContentSizeCategory.extraSmall: 22,
    ],
    FontBook.listBody.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 31,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 31,
      UIContentSizeCategory.accessibilityExtraLarge: 31,
      UIContentSizeCategory.accessibilityLarge: 31,
      UIContentSizeCategory.accessibilityMedium: 31,
      UIContentSizeCategory.extraExtraExtraLarge: 31,
      UIContentSizeCategory.extraExtraLarge: 29,
      UIContentSizeCategory.extraLarge: 27,
      UIContentSizeCategory.large: 25,
      UIContentSizeCategory.medium: 24,
      UIContentSizeCategory.small: 23,
      UIContentSizeCategory.extraSmall: 22,
    ],
    FontBook.action1.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 29,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 29,
      UIContentSizeCategory.accessibilityExtraLarge: 29,
      UIContentSizeCategory.accessibilityLarge: 29,
      UIContentSizeCategory.accessibilityMedium: 29,
      UIContentSizeCategory.extraExtraExtraLarge: 29,
      UIContentSizeCategory.extraExtraLarge: 27,
      UIContentSizeCategory.extraLarge: 25,
      UIContentSizeCategory.large: 23,
      UIContentSizeCategory.medium: 22,
      UIContentSizeCategory.small: 21,
      UIContentSizeCategory.extraSmall: 20,
    ],
    FontBook.action2.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 29,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 29,
      UIContentSizeCategory.accessibilityExtraLarge: 29,
      UIContentSizeCategory.accessibilityLarge: 29,
      UIContentSizeCategory.accessibilityMedium: 29,
      UIContentSizeCategory.extraExtraExtraLarge: 29,
      UIContentSizeCategory.extraExtraLarge: 27,
      UIContentSizeCategory.extraLarge: 25,
      UIContentSizeCategory.large: 23,
      UIContentSizeCategory.medium: 22,
      UIContentSizeCategory.small: 21,
      UIContentSizeCategory.extraSmall: 20,
    ],
    FontBook.label1.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 27,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 27,
      UIContentSizeCategory.accessibilityExtraLarge: 27,
      UIContentSizeCategory.accessibilityLarge: 27,
      UIContentSizeCategory.accessibilityMedium: 27,
      UIContentSizeCategory.extraExtraExtraLarge: 27,
      UIContentSizeCategory.extraExtraLarge: 25,
      UIContentSizeCategory.extraLarge: 23,
      UIContentSizeCategory.large: 21,
      UIContentSizeCategory.medium: 20,
      UIContentSizeCategory.small: 19,
      UIContentSizeCategory.extraSmall: 18,
    ],
    FontBook.label2.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 27,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 27,
      UIContentSizeCategory.accessibilityExtraLarge: 27,
      UIContentSizeCategory.accessibilityLarge: 27,
      UIContentSizeCategory.accessibilityMedium: 27,
      UIContentSizeCategory.extraExtraExtraLarge: 27,
      UIContentSizeCategory.extraExtraLarge: 25,
      UIContentSizeCategory.extraLarge: 23,
      UIContentSizeCategory.large: 21,
      UIContentSizeCategory.medium: 20,
      UIContentSizeCategory.small: 19,
      UIContentSizeCategory.extraSmall: 18,
    ],
    FontBook.label3.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 26,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 26,
      UIContentSizeCategory.accessibilityExtraLarge: 26,
      UIContentSizeCategory.accessibilityLarge: 26,
      UIContentSizeCategory.accessibilityMedium: 26,
      UIContentSizeCategory.extraExtraExtraLarge: 26,
      UIContentSizeCategory.extraExtraLarge: 24,
      UIContentSizeCategory.extraLarge: 22,
      UIContentSizeCategory.large: 20,
      UIContentSizeCategory.medium: 19,
      UIContentSizeCategory.small: 18,
      UIContentSizeCategory.extraSmall: 17,
    ],
    FontBook.filter.rawValue: [
      UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 26,
      UIContentSizeCategory.accessibilityExtraExtraLarge: 26,
      UIContentSizeCategory.accessibilityExtraLarge: 26,
      UIContentSizeCategory.accessibilityLarge: 26,
      UIContentSizeCategory.accessibilityMedium: 26,
      UIContentSizeCategory.extraExtraExtraLarge: 26,
      UIContentSizeCategory.extraExtraLarge: 24,
      UIContentSizeCategory.extraLarge: 22,
      UIContentSizeCategory.large: 20,
      UIContentSizeCategory.medium: 19,
      UIContentSizeCategory.small: 18,
      UIContentSizeCategory.extraSmall: 17,
    ],
    FontBook.menu1.rawValue: [
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
      UIContentSizeCategory.extraSmall: 15,
    ],
    FontBook.menu2.rawValue: [
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
      UIContentSizeCategory.extraSmall: 15,
    ],
    FontBook.tabLabel.rawValue: [
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
      UIContentSizeCategory.extraSmall: 13,
    ],
    FontBook.tabLabelSelected.rawValue: [
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
      UIContentSizeCategory.extraSmall: 13,
    ]
  ]
}
