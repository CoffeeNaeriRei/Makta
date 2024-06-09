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

// Mock TransPathRepository
struct MockTransPathRepository: TransPathRepositoryProtocol {
    var isMakchaInfo: Bool = false
    var mockAPIServiceError = APIServiceError.requestFail
    
    func getAllMakchaTransPath(start: XYCoordinate, end: XYCoordinate) -> Observable<MakchaInfo> {
        return Observable.create { emitter in
            if isMakchaInfo {
                emitter.onNext(MakchaInfo.mockMakchaInfo)
                emitter.onCompleted()
            } else {
                emitter.onError(mockAPIServiceError)
            }
            return Disposables.create()
        }
    }
    
    func getSeoulRealtimeSubwayArrival(
        stationName: String,
        subwayLineCodeInt: Int,
        wayCodeInt: Int,
        currentTime: Date
    ) -> Observable<RealtimeArrivalTuple> {
        return Observable<RealtimeArrivalTuple>.just((.unknown, .unknown))
    }
    
    func getSeoulRealtimeBusArrival(
        routeIDs: [String],
        routeNames: [String],
        arsID: String
    ) -> Observable<RealtimeArrivalTuple> {
        return Observable<RealtimeArrivalTuple>.just((.unknown, .unknown))
    }
}

// Mock EndPointRepository
struct MockEndPointRepository: EndPointRepositoryProtocol {
    var isCurrentLocation: Bool? // mock EndpointRepository의 현재 위치 불러오기 성공 여부 제어
    var isAddressSearchSuccess: Bool? // mock EndpointRepository의 주소 검색 성공 여부 제어
    
    func getCurrentLocation() -> Observable<EndPoint> {
        return Observable.create { emitter in
            guard let isCurrentLocation = isCurrentLocation else { return Disposables.create() }
            if isCurrentLocation {
                emitter.onNext(EndPoint.mockStartPoint)
                emitter.onCompleted()
            } else {
                emitter.onError(LocationServiceError.fetchFailed)
            }
            return Disposables.create()
        }
    }
    
    func getSearchedAddresses(searchKeyword: String) -> Observable<[EndPoint]> {
        return Observable.create { emitter in
            guard let isAddressSearchSuccess = isAddressSearchSuccess else { return Disposables.create() }
            if isAddressSearchSuccess {
                emitter.onNext(EndPoint.mockSearchedEndpoints)
                emitter.onCompleted()
            } else {
                emitter.onError(APIServiceError.requestFail)
            }
            return Disposables.create()
        }
    }
}

final class MakchaInfoUseCaseTests: XCTestCase {
    
    private var sut: MakchaInfoUseCase!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    private var mockTransPathRepository = MockTransPathRepository()
    private var mockEndPointRepository = MockEndPointRepository()
    
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

    func test_transPathRepository가_정상적인_MakchaInfo를_넘겼을때_제대로_바인딩되는지_확인() {
        // Given
        mockTransPathRepository.isMakchaInfo = true
        sut = MakchaInfoUseCase(mockTransPathRepository, mockEndPointRepository)
        let makchaInfoObserver = scheduler.createObserver(MakchaInfo.self)
        let mockStart = EndPoint.mockStartPoint.coordinate
        let mockEnd = EndPoint.mockDestinationPoint.coordinate
        let expectedMakchaInfo = MakchaInfo.mockMakchaInfo // 결과로 예상되는 makchaInfo 값

        sut.makchaInfo
            .bind(to: makchaInfoObserver)
            .disposed(by: disposeBag)
        
        // When
        sut.loadMakchaPath(start: mockStart, end: mockEnd)
        
        // Then
        XCTAssertEqual(makchaInfoObserver.events.count, 1)
        XCTAssertEqual(makchaInfoObserver.events.first!.value.element, expectedMakchaInfo)
        // MockTransPathRepository의 메서드는 비동기적으로 동작하지 않기 때문에 스케줄러를 동작시키지 않아도 테스트가 통과 가능한 것 같음
    }
    
    func test_transPathRepository가_현재위치를_불러왔을때_현재위치와_막차경로가_제대로_바인딩되는지_확인() {
        // Given
        mockTransPathRepository.isMakchaInfo = true
        mockEndPointRepository.isCurrentLocation = true
        sut = MakchaInfoUseCase(mockTransPathRepository, mockEndPointRepository)
        let startPointObserver = scheduler.createObserver(EndPoint.self)
        let makchaInfoObserver = scheduler.createObserver(MakchaInfo.self)
        let expectedStartPoint = EndPoint.mockStartPoint // 결과로 예상되는 startPoint 값
        let expectedMakchaInfo = MakchaInfo.mockMakchaInfo // 결과로 예상되는 makchaInfo 값
        
        sut.startPoint
            .bind(to: startPointObserver)
            .disposed(by: disposeBag)
        sut.makchaInfo
            .bind(to: makchaInfoObserver)
            .disposed(by: disposeBag)
        
        // When
        sut.loadMakchaPathWithCurrentLocation()
        
        // Then
        XCTAssertEqual(startPointObserver.events.count, 1)
        XCTAssertEqual(makchaInfoObserver.events.count, 1)
        XCTAssertEqual(startPointObserver.events.first!.value.element, expectedStartPoint)
        XCTAssertEqual(makchaInfoObserver.events.first!.value.element, expectedMakchaInfo)
    }
    
    func test_searchWithAddressText가_검색결과를_불러왔을때_EndPoint배열이_제대로_바인딩되는지_확인() {
        // Given
        mockEndPointRepository.isAddressSearchSuccess = true
        sut = MakchaInfoUseCase(mockTransPathRepository, mockEndPointRepository)
        let searchedEndPointsObserver = scheduler.createObserver([EndPoint].self)
        let expectedSearchedEndPoints = EndPoint.mockSearchedEndpoints
        
        sut.searchedEndPoints
            .bind(to: searchedEndPointsObserver)
            .disposed(by: disposeBag)
        
        // When
        sut.searchWithAddressText(searchKeyword: "") // 해당 테스트에서는 키워드 상관 x
        
        // Then
        // searchedEndPoints는 초기 이벤트로 빈 배열이 한번 방출되기 때문에 2번째 이벤트를 테스트
        XCTAssertEqual(searchedEndPointsObserver.events.count, 2)
        XCTAssertEqual(searchedEndPointsObserver.events[1].value.element, expectedSearchedEndPoints)
    }
}
