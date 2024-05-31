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
    
    // String에서 하이픈(-)을 제거해주는 메서드
    /// 정류소고유번호 ardID를 "12-022" 👉 "12022" 형식으로 변환할 때 사용
    func removeHyphen() -> Self {
        return self.replacingOccurrences(of: "-", with: "")
    }
    
    // String이 숫자를 포함하는지 여부를 반환하는 메서드
    func isContainsNumber() -> Bool {
        return self.rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    // 서울시 버스 도착 정보의 BusArrival에 있는 arrivalMessage로부터 남은 시간을 구해서 Int타입의 초 값으로 반환하는 메서드
    func getSeoulBusRemainingSecond() -> Int {
        let minutePattern = "(\\d+)분"
        let secondPattern = "(\\d+)초"
        
        guard let minuteRegex = try? NSRegularExpression(pattern: minutePattern) else { return 0 }
        guard let secondRegex = try? NSRegularExpression(pattern: secondPattern) else { return 0 }
        
        let nsString = self as NSString
        var minutes = 0
        var seconds = 0
        
        // 분 추출
        if let minuteMatch = minuteRegex.firstMatch(in: self, range: NSRange(location: 0, length: nsString.length)) {
            if let range = Range(minuteMatch.range(at: 1), in: self) {
                minutes = Int(self[range]) ?? 0
            }
        }
        
        // 초 추출
        if let secondMatch = secondRegex.firstMatch(in: self, range: NSRange(location: 0, length: nsString.length)) {
            if let range = Range(secondMatch.range(at: 1), in: self) {
                seconds = Int(self[range]) ?? 0
            }
        }
        
        return (minutes * 60) + seconds
    }
}
