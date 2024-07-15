//
//  Flex+Extension.swift
//  Makcha
//
//  Created by yuncoffee on 6/23/24.
//

import Foundation
import FlexLayout

extension Flex {
    @discardableResult
    func configurePathIconStyle() -> Flex {
        self.width(24).height(24).cornerRadius(12)
        
        return self
    }
}
