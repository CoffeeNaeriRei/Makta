//
//  Print.swift
//  Makcha
//
//  Created by 김영빈 on 7/8/24.
//

/**
 Swift의 print() 함수 오버라이드
 - DEBUG 환경에서만 print 출력
 */
public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        Swift.print(items, separator: separator, terminator: terminator)
    #endif
}
