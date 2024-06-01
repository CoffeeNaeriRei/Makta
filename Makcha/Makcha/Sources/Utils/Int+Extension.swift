//
//  Int+Extension.swift
//  Makcha
//
//  Created by 김영빈 on 5/16/24.
//

import Foundation

extension Int {
    // Int 단위의 초 값을 00분00초 형식의 String으로 변환하는 프로퍼티
    var convertToMinuteSecondString: String {
        var minuteStr = String(self / 60)
        var secondStr = String(self % 60)
        var result = ""
        
        if minuteStr.count == 1 {
            minuteStr = "0\(minuteStr)"
        }
        result += "\(minuteStr)분 "
        
        if secondStr.count == 1 {
            secondStr = "0\(minuteStr)"
        }
        result += "\(secondStr)초"
        
        return result
    }
}
