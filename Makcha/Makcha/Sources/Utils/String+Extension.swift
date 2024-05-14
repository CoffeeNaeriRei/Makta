//
//  String+Extension.swift
//  Makcha
//
//  Created by 김영빈 on 5/13/24.
//

import Foundation

extension String {
    
    subscript(idx: Int) -> String? {
        guard (0..<count).contains(idx) else {
            return nil
        }
        let target = index(startIndex, offsetBy: idx)
        return String(self[target])
    }
    
    // "2024-05-13 11:17:28" 형식 String을 Date로 변환
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // 한국의 TimeZone(KST)이 UTC+9시간이기 때문에 "KST"로 하면 9시간이 줄어듦
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
