//
//  TransPathRepositoryTests.swift
//  MakchaTests
//
//  Created by 김영빈 on 5/7/24.
//

import XCTest
@testable import Makcha

import RxCocoa
import RxSwift
import RxTest

// Mock APIService
struct MockAPIService: APIServiceInterface {
    var mockTransPathResult: Result<TransPathDTO, APIServiceError>?
    var mockSeoulRealtimeSubwayResult: Result<SeoulRealtimeSubwayDTO, APIServiceError>?
    var mockSeoulRealtimeBusStationResult: Result<SeoulRealtimeBusStationDTO, APIServiceError>?
    var mockKakaoAddressSearchResult: Result<KakaoAddressSearchResultDTO, APIServiceError>?
    
    func fetchTransPathData(
        start: Makcha.XYCoordinate,
        end: Makcha.XYCoordinate,
        completion: @escaping (Result<TransPathDTO, APIServiceError>) -> Void
    ) {
        completion(mockTransPathResult!)
    }
    
    func fetchSeoulRealtimeSubwayArrival(
        stationName: String,
        completion: @escaping (Result<SeoulRealtimeSubwayDTO, APIServiceError>) -> Void
    ) {
        completion(mockSeoulRealtimeSubwayResult!)
    }
    
    func fetchSeoulRealtimeBusStationInfo(
        arsID: String,
        completion: @escaping (Result<SeoulRealtimeBusStationDTO, APIServiceError>) -> Void
    ) {
        completion(mockSeoulRealtimeBusStationResult!)
    }
    
    func fetchKakaoAddressSearchResult(
        address: String,
        completion: @escaping (Result<KakaoAddressSearchResultDTO, APIServiceError>) -> Void
    ) {
        completion(mockKakaoAddressSearchResult!)
    }
}

final class TransPathRepositoryTests: XCTestCase {
    private var sut: TransPathRepository!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = TransPathRepository(MockAPIService())
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
    }
    
    func test_getAllMakchaTransPath이_정상적으로_이벤트를_방출하는지_확인() {
        // Given
        let mockApiSuccess: Result<TransPathDTO, APIServiceError>? = .success(mockTransPathDTO)
        sut = TransPathRepository(MockAPIService(mockTransPathResult: mockApiSuccess))
        let makchaInfoObserver = scheduler.createObserver(MakchaInfo.self) // 결과값을 관찰하기 위한 Observer
        
        // When
        sut.getAllMakchaTransPath(start: ("10.0", "10.0"), end: ("10.0", "10.0"))
            .bind(to: makchaInfoObserver)
            .disposed(by: disposeBag)
        
        // Then
        XCTAssertEqual(makchaInfoObserver.events.count, 2) // 이벤트 2개(onNext,onCompleted)가 호출되는지 확인
    }
    
    func test_실제지하철도착시간이_이미_지났을때_실제도착까지남은시간이_음수Int로나오는지_확인() {
        // Given
        // 데이터 생성시간: "2024-05-15 17:49:27" | 남은시간(초) : 129 👉 실제도착시간 : "2024-05-15 17:51:36"
        let mockArrival = try! JSONDecoder().decode(SeoulRealtimeSubwayDTO.self, from: SeoulRealtimeSubwayDTO.mockData).realtimeArrivalList[1]
        let mockCurrentTime = "2024-05-15 17:52:00".toDate()! // mockArrival로 계산한 실제 도착시간을 지난 시간
        var result: Int
        let expectedResult = -24
        
        // When
        result = sut.getRealRemainingTimeFromSeoulSubway(arrival: mockArrival, currentTime: mockCurrentTime)
        
        // Then
        XCTAssertTrue(result < 0)
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_실제지하철도착시간이_현재시간보다_이후일때_실제도착까지남은시간이_양수Int로나오는지_확인() {
        // Given
        // 데이터 생성시간: "2024-05-15 17:49:27" | 남은시간(초) : 129 👉 실제도착시간 : "2024-05-15 17:51:36"
        let mockArrival = try! JSONDecoder().decode(SeoulRealtimeSubwayDTO.self, from: SeoulRealtimeSubwayDTO.mockData).realtimeArrivalList[1]
        let mockCurrentTime = "2024-05-15 17:51:00".toDate()! // mockArrival로 계산한 실제 도착시간을 지난 시간
        var result: Int
        let expectedResult = 36
        
        // When
        result = sut.getRealRemainingTimeFromSeoulSubway(arrival: mockArrival, currentTime: mockCurrentTime)
        
        // Then
        XCTAssertTrue(result > 0)
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_API응답으로받은_서울시실시간도착정보_배열에서_호선과방면이일치하는_1번째도착열차를_제대로필터링하는지_확인() {
        // Given
        let mockData = try! JSONDecoder().decode(SeoulRealtimeSubwayDTO.self, from: SeoulRealtimeSubwayDTO.mockData).realtimeArrivalList
        let filteringCondition = (
            subwayLine: "1003", // 호선 코드 (서울 실시간 지하철 API)
            wayCode: "0", // 방면 코드 (서울 실시간 지하철 API)
            isFirst: true // 1번째 도착열차 찾기
        )
        var result: [SeoulRealtimeSubwayArrival]
        let expectedResult = SeoulRealtimeSubwayArrival.mock3호선상행1번째Data
        
        // When
        result = sut.filteringSeoulArrivalSubway(
            from: mockData,
            subwayLine: filteringCondition.subwayLine,
            wayCode: filteringCondition.wayCode,
            isFirst: filteringCondition.isFirst
        )
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_서울시실시간도착정보_배열에서_호선과방면이일치하는열차들이_필터링된_배열의길이가_1일때_남은시간값을_제대로반환하는지_확인() {
        // Given
        // 데이터 생성시간: "2024-05-15 17:49:30" | 남은시간(초) : 180 👉 실제도착시간 : "2024-05-15 17:52:30"
        let mockData = try! JSONDecoder().decode(SeoulRealtimeSubwayDTO.self, from: SeoulRealtimeSubwayDTO.mockData).realtimeArrivalList
        let mockCurrentTime = "2024-05-15 17:51:40".toDate()! // 현재 시간 가정 (도착 50초 전)
        let filteringCondition = ( // mock 데이터에서 필터링하면 1개만 나오는 조건
            subwayLine: "1006", // 6호선
            wayCode: "1", // 하행
            isFirst: true // 1번째 도착열차
        )
        var result: Int
        let expectedResult = 50
        
        // When
        let filteredArr = sut.filteringSeoulArrivalSubway(
            from: mockData,
            subwayLine: filteringCondition.subwayLine,
            wayCode: filteringCondition.wayCode,
            isFirst: filteringCondition.isFirst
        )
        result = sut.extractRealRemainingFromArrivals(from: filteredArr, currentTime: mockCurrentTime)
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_서울시실시간도착정보_배열에서_호선과방면이일치하는열차들이_필터링된_배열의길이가_2일때_남은시간값을_제대로반환하는지_확인() {
        // Given
        /*
         1. 데이터 생성시간: "2024-05-15 17:49:27" | 남은시간(초) : 513 👉 실제도착시간 : "2024-05-15 17:58:00"
         2. 데이터 생성시간: "2024-05-15 17:49:30" | 남은시간(초) : 0 👉 실제도착시간 : "2024-05-15 17:49:30"
         */
        guard let mockData = try? JSONDecoder().decode(SeoulRealtimeSubwayDTO.self, from: SeoulRealtimeSubwayDTO.mockData).realtimeArrivalList else { return }
        let mockCurrentTime = "2024-05-15 17:54:00".toDate()! // 현재 시간 가정
        let filteringCondition = ( // mock 데이터에서 필터링하면 2개가 나오는 조건
            subwayLine: "1003", // 3호선
            wayCode: "0", // 상행
            isFirst: false // 2번째 도착열차
        )
        var result: Int
        let expectedResult = 240
        
        // When
        let filteredArr = sut.filteringSeoulArrivalSubway(
            from: mockData,
            subwayLine: filteringCondition.subwayLine,
            wayCode: filteringCondition.wayCode,
            isFirst: filteringCondition.isFirst
        )
        result = sut.extractRealRemainingFromArrivals(from: filteredArr, currentTime: mockCurrentTime)
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
}
