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
        // 한국의 TimeZone(KST)은 UTC+9시간
        // 이후 Date()와 비교하기 위해 TimeZone 건들지 않고 그대로 사용
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
