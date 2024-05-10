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
    
    var mockCLLocation: CLLocation?
    var mockError: Error?
    
    func fetchCurrentLocation(completion: @escaping LocationCallback) {
        completion(mockCLLocation, mockError)
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
        let lat = CLLocationDegrees(mockStartPoint.coordinate.latY)
        let lon = CLLocationDegrees(mockStartPoint.coordinate.lonX)
        let mockCLLocation: CLLocation = CLLocation(latitude: lat!, longitude: lon!)
        let expectedEndPoint: EndPoint = EndPoint(
            coordinate: (mockCLLocation.coordinate.longitude.description, mockCLLocation.coordinate.latitude.description)
        )
        var resultEndPoint: EndPoint
        sut = EndPointRepository(MockLocationService(mockCLLocation: mockCLLocation))
        let endPointObserver = scheduler.createObserver(EndPoint.self)

        // When
        sut.getCurrentLocation()
            .bind(to: endPointObserver)
            .disposed(by: disposeBag)

        // Then
        XCTAssertEqual(endPointObserver.events.count, 2) // 이벤트 2개(onNext,onCompleted)가 호출되는지 확인
        resultEndPoint = endPointObserver.events.first!.value.element!
        XCTAssertEqual(expectedEndPoint, resultEndPoint)
    }
}
