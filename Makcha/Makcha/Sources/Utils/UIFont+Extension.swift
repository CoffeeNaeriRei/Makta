//
//  UIFont+Extension.swift
//  Makcha
//
//  Created by yuncoffee on 5/5/24.
//

import Foundation
import UIKit

func setLineSpacing(_ spacing: CGFloat, text: String) -> NSAttributedString {
  let paragraphStyle = NSMutableParagraphStyle()
  paragraphStyle.lineSpacing = spacing
    
  return NSAttributedString(
    string: text,
    attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
  )
}
