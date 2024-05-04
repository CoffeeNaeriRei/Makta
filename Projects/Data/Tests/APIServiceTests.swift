//
//  APIServiceTests.swift
//  Data
//
//  Created by 김영빈 on 5/3/24.
//

import XCTest
@testable import Data

final class APIServiceTests: XCTestCase {
    
    override func setUpWithError() throws {
        super.setUp()
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
    }
    
    func test_fetchTransPathData가_정상적으로_API를_호출하는지_확인() {
        // Given
        var isSuccess: Bool = false
        let completionExpectation = expectation(description: "feetchTransPathData completion expectation")
        
        // When
        APIService.fetchTransPathData(
            start: ("126.926493082645", "37.6134436427887"),
            end: ("127.126936754911", "37.5004198786564")) { result in
                switch result {
                case .success:
                    isSuccess = true
                case .failure:
                    isSuccess = false
                }
                completionExpectation.fulfill()
            }
        wait(for: [completionExpectation], timeout: 5)
        
        // Then
        XCTAssertTrue(isSuccess)
    }
}
