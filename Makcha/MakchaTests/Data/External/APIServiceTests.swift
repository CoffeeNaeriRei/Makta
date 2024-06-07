//
//  APIServiceTests.swift
//  MakchaTests
//
//  Created by 김영빈 on 5/5/24.
//

import XCTest
@testable import Makcha

final class APIServiceTests: XCTestCase {
    private var sut: APIServiceInterface!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = APIService()
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
        sut = nil
    }
    
    func test_fetchTransPathData가_정상적으로_API를_호출하는지_확인() {
        // Given
        let start = mockStartPoint.coordinate
        let end = mockDestinationPoint.coordinate
        var isSuccess: Bool = false
        let completionExpectation = expectation(description: "fetchTransPathData completion expectation")
        
        // When
        sut.fetchTransPathData(start: start, end: end) { result in
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
    
    func test_fetchSeoulRealtimeSubwayArrival가_정상적으로_API를_호출하는지_확인() {
        // Given
        let stationName = "연신내"
        var isSuccess: Bool = false
        var resultDTO: SeoulRealtimeSubwayDTO?
        let completionExpectation = expectation(description: "fetchSeoulRealtimeSubwayArrival completion expectation")
        
        // When
        sut.fetchSeoulRealtimeSubwayArrival(stationName: stationName) { result in
            switch result {
            case .success(let seoulRealtimeSubwayDTO):
                isSuccess = true
                resultDTO = seoulRealtimeSubwayDTO
            case .failure:
                isSuccess = false
            }
            completionExpectation.fulfill()
        }
        wait(for: [completionExpectation], timeout: 5)
        
        // Then
        XCTAssertTrue(isSuccess)
        XCTAssertNotNil(resultDTO)
    }
    
    func test_fetchSeoulRealtimeBusStationInfo가_정상적으로_API를_호출하는지_확인() {
        // Given
        let arsID = "12-022"
        var isSuccess: Bool = false
        var resultDTO: SeoulRealtimeBusStationDTO?
        let completionExpectation = expectation(description: "fetchSeoulRealtimeBusStationInfo completion expectation")
        
        // When
        sut.fetchSeoulRealtimeBusStationInfo(arsID: arsID) { result in
            switch result {
            case .success(let seoulRealtimeBusStationDTO):
                isSuccess = true
                resultDTO = seoulRealtimeBusStationDTO
            case .failure:
                isSuccess = false
            }
            completionExpectation.fulfill()
        }
        wait(for: [completionExpectation], timeout: 5)
        
        // Then
        XCTAssertTrue(isSuccess)
        XCTAssertNotNil(resultDTO)
    }
    
    func test_fetchKakaoAddressSearchResult가_정상적으로_API를_호출하는지_확인() {
        // Given
        let addressQuery = "서울 은평구 대조동 2-44"
        var isSuccess: Bool = false
        var resultDTO: KakaoAddressSearchResultDTO?
        let completionExpectation = expectation(description: "fetchKakaoAddressSearchResult completion expectation")
        
        // When
        sut.fetchKakaoAddressSearchResult(address: addressQuery) { result in
            switch result {
            case .success(let kakaoAddressSearchResultDTO):
                isSuccess = true
                resultDTO = kakaoAddressSearchResultDTO
            case .failure:
                isSuccess = false
            }
            completionExpectation.fulfill()
        }
        wait(for: [completionExpectation], timeout: 5)
        
        // Then
        XCTAssertTrue(isSuccess)
        XCTAssertNotNil(resultDTO)
    }
}
