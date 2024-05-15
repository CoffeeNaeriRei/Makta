//
//  Date+Extension.swift
//  Makcha
//
//  Created by 김영빈 on 5/11/24.
//

import Foundation

extension Date {
    
    // 해당 날짜가 오늘인지 확인
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    // 해당 날짜가 내일인지 확인
    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }
    
    // 시간 데이터를 String 형식으로 변환 👉 오늘 오후 22:38 | 다음날 오전 01:23
    var endPointTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a HH:mm"
        var timeString = dateFormatter.string(from: self)
        if isToday {
            timeString = "오늘 " + timeString
        } else if isTomorrow {
            timeString = "다음날 " + timeString
        }
        print("시간 문자열 => \(timeString)")
        return timeString
    }
    
    // Date로부터 minute분 만큼 지난 시간
    func timeAfterMinute(after minute: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minute, to: self) ?? self
    }
    
    // Date로부터 second초 만큼 지난 시간
    func timeAfterSecond(after second: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: second, to: self) ?? self
    }
}
