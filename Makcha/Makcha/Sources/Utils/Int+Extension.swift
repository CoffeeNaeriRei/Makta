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
        guard self >= 0 else { return "도착 정보 없음" }
        var minuteStr = String(self / 60)
        var secondStr = String(self % 60)
        var result = ""
        
        if minuteStr.count == 1 {
            minuteStr = "0\(minuteStr)"
        }
        result += "\(minuteStr)분 "
        
        if secondStr.count == 1 {
            secondStr = "0\(secondStr)"
        }
        result += "\(secondStr)초"
        
        return result
    }
    
    // Int 단위의 분 값을 0시간0분 형식의 String으로 변환하는 프로퍼티
    // TODO: - AttributedText로 수정 필요
    var convertToHourMinuteString: String {
        guard self >= 0 else { return "정보 없음" }
        var hourStr = String(self / 60)
        var minuteStr = String(self % 60)
        return "\(hourStr)시간 \(minuteStr)분"
    }
}
