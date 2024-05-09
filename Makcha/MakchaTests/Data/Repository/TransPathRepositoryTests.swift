//
//  TransPathRepositoryTests.swift
//  MakchaTests
//
//  Created by 김영빈 on 5/7/24.
//

import XCTest
import CoreLocation
@testable import Makcha

import RxCocoa
import RxSwift
import RxTest

// Mock APIService
struct MockAPIService: APIServiceInterface {
    
    var mockResult: Result<TransPathDTO, APIServiceError>?
    
    func fetchTransPathData(
        start: Makcha.XYCoordinate,
        end: Makcha.XYCoordinate,
        completion: @escaping (Result<TransPathDTO, APIServiceError>) -> Void
    ) {
        completion(mockResult!)
    }
}

// Mock LocationService
struct MockLocationService: LocationServiceInterface {
    
    var mockCLLocation: CLLocation?
    var mockError: Error?
    
    func fetchCurrentLocation(completion: @escaping LocationCallback) {
        completion(mockCLLocation, mockError)
    }
}

final class TransPathRepositoryTests: XCTestCase {
    
    private var sut: TransPathRepository!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = TransPathRepository(MockAPIService(), LocationService())
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
        sut = nil
        scheduler = nil
        disposeBag = nil
    }
    
    func test_정상적인_TransPathDTO_객체를_받았을때_convertTransPathDTOToMakchaInfo가_제대로_변환을_수행하는지_확인() {
        // Given
        let givenTransPathDTO = mockTransPathDTO
        var result: MakchaInfo?
        
        // When
        result = sut.convertTransPathDTOToMakchaInfo(transPathDTO: givenTransPathDTO)
        
        // Then
        XCTAssertNotNil(result)
//        XCTAssertEqual(result, mockMakchaInfo) // TODO: - 결과값도 확인하기
    }
    
    func test_getAllMakchaTransPath이_정상적으로_이벤트를_방출하는지_확인() {
        // Given
        let mockApiSuccess: Result<TransPathDTO, APIServiceError>? = .success(mockTransPathDTO)
        sut = TransPathRepository(MockAPIService(mockResult: mockApiSuccess), MockLocationService())
        let makchaInfoObserver = scheduler.createObserver(MakchaInfo.self) // 결과값을 관찰하기 위한 Observer
//        var resultMakchaInfo: MakchaInfo
        
        // When
        sut.getAllMakchaTransPath(start: ("10.0", "10.0"), end: ("10.0", "10.0"))
            .bind(to: makchaInfoObserver)
            .disposed(by: disposeBag)
        
//        scheduler.start()
        
        // Then
        XCTAssertEqual(makchaInfoObserver.events.count, 2) // 이벤트 2개(onNext,onCompleted)가 호출되는지 확인
//        resultMakchaInfo = makchaInfoObserver.events.first!.value.element!
//        XCTAssertEqual(resultMakchaInfo, mockMakchaInfo) // TODO: - 결과값도 확인하기
    }
    
    func test_위치데이터를_정상적으로_받아왔을때_getCurrentLocation이_정상적으로_이벤트를_방출하는지_확인() {
        // Given
        let lat = CLLocationDegrees(mockStartPoint.coordinate.latY)
        let lon = CLLocationDegrees(mockStartPoint.coordinate.lonX)
        let mockCLLocation: CLLocation = CLLocation(latitude: lat!, longitude: lon!)
        var expectedEndPoint: EndPoint = EndPoint(
            coordinate: (mockCLLocation.coordinate.longitude.description, mockCLLocation.coordinate.latitude.description)
        )
        var resultEndPoint: EndPoint
        sut = TransPathRepository(MockAPIService(), MockLocationService(mockCLLocation: mockCLLocation))
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
