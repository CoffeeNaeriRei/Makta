//
//  APIServiceTests.swift
//  MakchaTests
//
//  Created by 김영빈 on 5/5/24.
//

import XCTest
@testable import Makcha

final class APIServiceTests: XCTestCase {
    private var sut: APIService!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = APIService()
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
    }
    
    func test_fetchTransPathData가_정상적으로_API를_호출하는지_확인() {
        // Given
        var isSuccess: Bool = false
        let completionExpectation = expectation(description: "feetchTransPathData completion expectation")
        
        // When
        sut.fetchTransPathData(
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
