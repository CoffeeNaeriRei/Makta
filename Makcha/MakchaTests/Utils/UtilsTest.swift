//
//  UtilsTest.swift
//  MakchaTests
//
//  Created by 김영빈 on 5/11/24.
//

import XCTest
@testable import Makcha

final class UtilsTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_오늘에_해당하는_Date를_endPointTimeString문자열로_잘_변환하는지_확인() {
        // Given
        let calendar = Calendar.current
        let today = Date()
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        let day = calendar.component(.day, from: today)
        let dateComponents = DateComponents(year: year, month: month, day: day, hour: 23, minute: 30)
        let mockDate = calendar.date(from: dateComponents)!
        let expectedResult = "오늘 오후 23:30"
        var result: String

        // When
        result = mockDate.endPointTimeString

        // Then
        XCTAssertEqual(expectedResult, result)
    }

    func test_60분이_지났을때_내일시간으로_되는_Date를_endPointTimeString문자열로_잘_변환하는지_확인() {
        // Given
        let calendar = Calendar.current
        let today = Date()
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        let day = calendar.component(.day, from: today)
        let dateComponents = DateComponents(year: year, month: month, day: day, hour: 23, minute: 30)
        let mockDate = calendar.date(from: dateComponents)!
        let expectedResult = "다음날 오전 00:30"
        var result: String

        // When
        result = mockDate.timeAfterMinute(after: 60).endPointTimeString

        // Then
        XCTAssertEqual(expectedResult, result)
    }
}
