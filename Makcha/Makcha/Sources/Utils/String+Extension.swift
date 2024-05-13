//
//  String+Extension.swift
//  Makcha
//
//  Created by 김영빈 on 5/13/24.
//

extension String {
    
    subscript(idx: Int) -> String? {
        guard (0..<count).contains(idx) else {
            return nil
        }
        let target = index(startIndex, offsetBy: idx)
        return String(self[target])
    }
}
