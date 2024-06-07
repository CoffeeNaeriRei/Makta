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
            latitude: CLLocationDegrees(mockEndPoint!.coordinate.latY)!,
            longitude: CLLocationDegrees(mockEndPoint!.coordinate.lonX)!
        )
        completion(mockCLLocation, mockError)
    }
}

final class EndPointRepositoryTests: XCTestCase {
    private var sut: EndPointRepository!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        super.setUp()
        sut = EndPointRepository(MockLocationService(), MockAPIService())
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
        let mockCurrentLocation = mockStartPoint
        let mockApiSuccess: Result<KakaoReverseGeocodingResultDTO, APIServiceError>? = .success(KakaoReverseGeocodingResultDTO.mockStartPointReverseGeocodedData)
        sut = EndPointRepository(MockLocationService(mockEndPoint: mockCurrentLocation), MockAPIService(mockKakaoReverseGeocodingResult: mockApiSuccess))
        let endPointObserver = scheduler.createObserver(EndPoint.self)

        // When
        sut.getCurrentLocation()
            .bind(to: endPointObserver)
            .disposed(by: disposeBag)

        // Then
        XCTAssertEqual(endPointObserver.events.count, 2) // 이벤트 2개(onNext,onCompleted)가 호출되는지 확인
    }
}
