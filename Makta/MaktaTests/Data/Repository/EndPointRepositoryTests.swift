//
//  EndPointRepositoryTests.swift
//  MakchaTests
//
//  Created by 김영빈 on 5/10/24.
//

import XCTest
import CoreLocation
@testable import Makcha

import RxCocoa
import RxSwift
import RxTest

// Mock LocationService
struct MockLocationService: LocationServiceInterface {
    var mockEndPoint: EndPoint?
    var mockError: Error?
    
    func fetchCurrentLocation(completion: @escaping LocationCallback) {
        let mockCLLocation = CLLocation(
            latitude: CLLocationDegrees(mockEndPoint!.latY)!,
            longitude: CLLocationDegrees(mockEndPoint!.lonX)!
        )
        completion(mockCLLocation, mockError)
    }
}

final class EndPointRepositoryTests: XCTestCase {
    private var sut: EndPointRepository!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    private var mockLocationService = MockLocationService()
    private var mockAPIService = MockAPIService()

    override func setUpWithError() throws {
        super.setUp()
        
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        super.tearDown()
        sut = nil
        scheduler = nil
        disposeBag = nil
    }
    
    func test_위치데이터를_정상적으로_받아왔을때_getCurrentLocation이_정상적으로_이벤트를_방출하는지_확인() {
        // Given
        let mockReverseGeocodingSuccess: Result<KakaoReverseGeocodingResultDTO, APIServiceError>? = .success(KakaoReverseGeocodingResultDTO.mockStartPointReverseGeocodedData)
        mockLocationService.mockEndPoint = EndPoint.mockStartPoint
        mockAPIService.mockKakaoReverseGeocodingResult = mockReverseGeocodingSuccess
        sut = EndPointRepository(mockLocationService, mockAPIService)
        let endPointObserver = scheduler.createObserver(EndPoint.self)

        // When
        sut.getCurrentLocation()
            .bind(to: endPointObserver)
            .disposed(by: disposeBag)

        // Then
        XCTAssertEqual(endPointObserver.events.count, 2) // 이벤트 2개(onNext,onCompleted)가 호출되는지 확인
    }
    
    // TODO: - 리버스 지오코딩 관련 예외처리하기
    /// ex) 도로명 주소가 없는 경우  => KakaoReverseGeocodingResultDTO.mockDestinationPointReverseGeocodedData 활용
    
    func test_검색결과를_정상적으로_받아왔을때_getSearchedAddresses가_정상적으로_이벤트를_방출하는지_확인() {
        // Given
        let mockPlaceSearchSuccess: Result<KakaoPlaceSearchResultDTO, APIServiceError> = .success(KakaoPlaceSearchResultDTO.mockData)
        mockAPIService.mockKakaoPlaceSearchResult = mockPlaceSearchSuccess
        sut = EndPointRepository(mockLocationService, mockAPIService)
        let endPointArrObserver = scheduler.createObserver([EndPoint].self)
        
        // When
        sut.getSearchedAddresses(searchKeyword: "") // 이 테스트에서는 키워드 상관 없음
            .bind(to: endPointArrObserver)
            .disposed(by: disposeBag)
        
        // Then
        XCTAssertEqual(endPointArrObserver.events.count, 2)
    }
}
