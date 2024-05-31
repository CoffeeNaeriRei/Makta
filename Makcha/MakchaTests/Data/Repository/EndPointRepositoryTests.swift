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
    var isConvertSuccess: Bool = true
    var mockError: Error?
    
    func fetchCurrentLocation(completion: @escaping LocationCallback) {
        let mockCLLocation = CLLocation(
            latitude: CLLocationDegrees(mockEndPoint!.coordinate.latY)!,
            longitude: CLLocationDegrees(mockEndPoint!.coordinate.lonX)!
        )
        completion(mockCLLocation, mockError)
    }
    
    func convertCoordinateToAddress(
        lon: CLLocationDegrees,
        lat: CLLocationDegrees,
        completion: @escaping ((String?) -> Void)
    ) {
        if isConvertSuccess {
            completion(mockEndPoint?.name)
        } else {
            completion(nil)
        }
    }
}

final class EndPointRepositoryTests: XCTestCase {
    private var sut: EndPointRepository!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        super.setUp()
        sut = EndPointRepository(MockLocationService())
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
        let expectedName = mockStartPoint.name
        let expectedEndPoint = mockStartPoint
        var resultEndPoint: EndPoint
        sut = EndPointRepository(MockLocationService(mockEndPoint: mockCurrentLocation, isConvertSuccess: true))
        let endPointObserver = scheduler.createObserver(EndPoint.self)

        // When
        sut.getCurrentLocation()
            .bind(to: endPointObserver)
            .disposed(by: disposeBag)

        // Then
        XCTAssertEqual(endPointObserver.events.count, 2) // 이벤트 2개(onNext,onCompleted)가 호출되는지 확인
        resultEndPoint = endPointObserver.events.first!.value.element!
        XCTAssertEqual(expectedEndPoint, resultEndPoint)
        XCTAssertEqual(resultEndPoint.name, expectedName)
    }
    
    func test_받아온_위치데이터의_리버스지오코딩이_실패했을때_getCurrentLocation_예외처리를_제대로하는지_확인() {
        // Given
        let mockCurrentLocation = mockStartPoint
        let mockLatStr = mockCurrentLocation.coordinate.latY.description
        let mockLonStr = mockCurrentLocation.coordinate.lonX.description
        let expectedName = "\(mockLatStr),\(mockLonStr) (좌표변환 실패)"
        let expectedEndPoint = EndPoint(
            name: expectedName,
            coordinate: (mockLonStr, mockLatStr)
        )
        var resultEndPoint: EndPoint
        sut = EndPointRepository(MockLocationService(mockEndPoint: mockCurrentLocation, isConvertSuccess: false))
        let endPointObserver = scheduler.createObserver(EndPoint.self)

        // When
        sut.getCurrentLocation()
            .bind(to: endPointObserver)
            .disposed(by: disposeBag)

        // Then
        XCTAssertEqual(endPointObserver.events.count, 2) // 이벤트 2개(onNext,onCompleted)가 호출되는지 확인
        resultEndPoint = endPointObserver.events.first!.value.element!
        XCTAssertEqual(expectedName, resultEndPoint.name)
        XCTAssertEqual(expectedEndPoint, resultEndPoint)
    }
}
