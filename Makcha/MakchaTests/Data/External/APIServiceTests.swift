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
    
    func test_fetchKakaoPlaceSearchResult가_정상적으로_API를_호출하는지_확인() {
        // Given
        let placeKeyword = "홍익대학교"
        var isSuccess: Bool = false
        var resultDTO: KakaoPlaceSearchResultDTO?
        let completionExpectation = expectation(description: "fetchKakaoPlaceSearchResult completion expectation")
        
        // When
        sut.fetchKakaoPlaceSearchResult(placeKeyword: placeKeyword) { result in
            switch result {
            case .success(let kakaoPlaceSearchResultDTO):
                isSuccess = true
                resultDTO = kakaoPlaceSearchResultDTO
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
    
    func test_fetchKakaoReverseGeocodingResult가_정상적으로_API를_호출하는지_확인() {
        // Given
        let mockCoordinate: XYCoordinate = (mockStartPoint.coordinate.lonX, mockStartPoint.coordinate.latY)
        var isSuccess: Bool = false
        var resultDTO: KakaoReverseGeocodingResultDTO?
        let completionExpectation = expectation(description: "fetchKakaoReverseGeocodingResult completion expectation")
        
        // When
        sut.fetchKakaoReverseGeocodingResult(lonX: mockCoordinate.lonX, latY: mockCoordinate.latY) { result in
            switch result {
            case .success(let kakaoReverseGeocodingResultDTO):
                isSuccess = true
                resultDTO = kakaoReverseGeocodingResultDTO
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
