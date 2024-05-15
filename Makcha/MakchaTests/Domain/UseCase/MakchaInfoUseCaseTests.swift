//
//  MakchaInfoUseCaseTests.swift
//  MakchaTests
//
//  Created by 김영빈 on 5/9/24.
//

import XCTest
@testable import Makcha

import RxSwift
import RxTest

// Testable Mock Data
let MOCK_MAKCHAINFO = mockMakchaInfo
let MOCK_CURRENT_LOCATION = mockStartPoint
let MOCK_START = mockStartPoint.coordinate
let MOCK_END = mockDestinationPoint.coordinate

// Mock TransPathRepository
struct MockTransPathRepository: TransPathRepositoryProtocol {
    
    var isMakchaInfo: Bool = false
    var mockAPIServiceError = APIServiceError.requestFail
    
    func getAllMakchaTransPath(start: XYCoordinate, end: XYCoordinate) -> Observable<MakchaInfo> {
        return Observable.create { emitter in
            if isMakchaInfo {
                emitter.onNext(MOCK_MAKCHAINFO)
                emitter.onCompleted()
            } else {
                emitter.onError(mockAPIServiceError)
            }
            return Disposables.create()
        }
    }
    
    func getSeoulRealtimeSubwayArrival(stationName: String, subwayLineCodeInt: Int, wayCodeInt: Int, currentTime: Date) -> Observable<RealtimeArrivalTuple> {
        return Observable<RealtimeArrivalTuple>.just((nil, nil))
    }
}

// Mock EndPointRepository
struct MockEndPointRepository: EndPointRepositoryProtocol {
    
    var isCurrentLocation: Bool?
    var mockLocationServiceError = LocationServiceError.fetchFailed
    
    func getCurrentLocation() -> Observable<EndPoint> {
        return Observable.create { emitter in
            guard let isCurrentLocation = isCurrentLocation else { return Disposables.create() }
            if isCurrentLocation {
                emitter.onNext(MOCK_CURRENT_LOCATION)
                emitter.onCompleted()
            } else {
                emitter.onError(mockLocationServiceError)
            }
            return Disposables.create()
        }
    }
}

final class MakchaInfoUseCaseTests: XCTestCase {
    
    private var sut: MakchaInfoUseCase!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        super.setUp()
        sut = MakchaInfoUseCase(MockTransPathRepository(), MockEndPointRepository())
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        super.tearDown()
        sut = nil
        scheduler = nil
        disposeBag = nil
    }

    func test_transPathRepository가_정상적인_MakchaInfo를_넘겼을때_제대로_바인딩되는지_확인() {
        // Given
        sut = MakchaInfoUseCase(MockTransPathRepository(isMakchaInfo: true), MockEndPointRepository())
        let makchaInfoObserver = scheduler.createObserver(MakchaInfo.self)
        let mockStart = MOCK_START
        let mockEnd = MOCK_END
        let expectedMakchaInfo = MOCK_MAKCHAINFO // 결과로 예상되는 makchaInfo 값
        
        sut.makchaInfo
            .bind(to: makchaInfoObserver)
            .disposed(by: disposeBag)
        
        // When
        sut.loadMakchaPath(start: mockStart, end: mockEnd)
        
        // Then
        XCTAssertEqual(makchaInfoObserver.events.count, 2)
        XCTAssertEqual(makchaInfoObserver.events.first!.value.element, expectedMakchaInfo)
        // MockTransPathRepository의 메서드는 비동기적으로 동작하지 않기 때문에 스케줄러를 동작시키지 않아도 테스트가 통과 가능한 것 같음
    }
    
    func test_transPathRepository가_현재위치를_불러왔을때_현재위치와_막차경로가_제대로_바인딩되는지_확인() {
        // Given
        sut = MakchaInfoUseCase(MockTransPathRepository(isMakchaInfo: true), MockEndPointRepository(isCurrentLocation: true))
        let startPointObserver = scheduler.createObserver(EndPoint.self)
        let makchaInfoObserver = scheduler.createObserver(MakchaInfo.self)
        let expectedStartPoint = MOCK_CURRENT_LOCATION // 결과로 예상되는 startPoint 값
        let expectedMakchaInfo = MOCK_MAKCHAINFO // 결과로 예상되는 makchaInfo 값
        
        sut.startPoint
            .bind(to: startPointObserver)
            .disposed(by: disposeBag)
        sut.makchaInfo
            .bind(to: makchaInfoObserver)
            .disposed(by: disposeBag)
        
        // When
        sut.loadMakchaPathWithCurrentLocation()
        
        // Then
        XCTAssertEqual(startPointObserver.events.count, 2)
        XCTAssertEqual(makchaInfoObserver.events.count, 2)
        XCTAssertEqual(startPointObserver.events.first!.value.element, expectedStartPoint)
        XCTAssertEqual(makchaInfoObserver.events.first!.value.element, expectedMakchaInfo)
    }
}
