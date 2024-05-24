//
//  MakchaInfoUseCase.swift
//  Makcha
//
//  Created by 김영빈 on 5/9/24.
//

import Foundation

import RxCocoa
import RxRelay
import RxSwift

// MARK: - 막차 정보 관련 유즈케이스

final class MakchaInfoUseCase {
    
    private let transPathRepository: TransPathRepositoryProtocol
    private let endPointRepository: EndPointRepositoryProtocol
    
    let makchaInfo = PublishSubject<MakchaInfo>() // 막차 정보
    var realtimeArrivals = PublishSubject<[RealtimeArrivalTuple]>() // 막차 경로 별 실시간 도착 정보
    let startPoint = BehaviorRelay<EndPoint>(value: mockStartPoint) // 출발지 정보 // TODO: - 기본값 지정하기
    let destinationPoint: BehaviorRelay<EndPoint> // 도착지 정보
    
    private let disposeBag = DisposeBag()
    
    init(_ transPathRepository: TransPathRepositoryProtocol, _ endPointRepository: EndPointRepositoryProtocol) {
        self.transPathRepository = transPathRepository
        self.endPointRepository = endPointRepository
        
        // TODO: 사용자가 설정한 기본 목적지로 초기화하기
        let destionationCoordinate = mockDestinationPoint
        destinationPoint = BehaviorRelay<EndPoint>(value: destionationCoordinate)
    }
    
    func updateStartPointToSearchedLocation() {
        
    }
    
    func updateDestinationPointToSearchedLocation() {
        
    }
    
    // 막차 경로 검색
    func loadMakchaPath(start: XYCoordinate, end: XYCoordinate) {
        transPathRepository.getAllMakchaTransPath(start: start, end: end)
            .do(
                onNext: { makchaInfo in
                    // 실시간 도착정보 불러오기
                    self.makeRealtimeArrivalTimes(
                        currentTime: makchaInfo.startTime,
                        makchaPaths: makchaInfo.makchaPaths
                    )
                }
            )
            .bind(to: makchaInfo)
            .disposed(by: disposeBag)
    }
    
    // 현재 위치 기반으로 막차 경로 불러오기
    func loadMakchaPathWithCurrentLocation() {
        print("[MakchaInfoUseCase] - 현재 위치 기반으로 막차 경로 불러오기")
        endPointRepository.getCurrentLocation()
            .do(
                onNext: { [weak self] currentLocation in
                    guard let destinationCoordinate = self?.destinationPoint.value.coordinate else { return }
                    self?.loadMakchaPath(start: currentLocation.coordinate, end: destinationCoordinate)
                }
            )
            .bind(to: startPoint)
            .disposed(by: disposeBag)
    }
    
    // 검색한 위치 기반으로 막차 경로 불러오기
    func loadMakchaPathWithSearchedLocation() {
        let start = startPoint.value.coordinate
        let end = destinationPoint.value.coordinate
        loadMakchaPath(start: start, end: end)
    }
    
    // MakchaPath 배열을 받아와서 각 경로별 실시간 도착정보를 만들어주는 메서드
    func makeRealtimeArrivalTimes(currentTime: Date, makchaPaths: [MakchaPath]) {
        var realtimeArrivalObservables: [Observable<RealtimeArrivalTuple>] = []
        
        // 각각의 막차경로에 대해 1번째 대중교통 세부경로 타입에 따른 실시간 도착정보 받아오기
        for makchaPath in makchaPaths {
            // 첫번째 대중교통 세부경로가 있을 때만 실시간 도착정보를 받아옴 (0번 인덱스는 항상 도보임)
            if let firstTransSubPath = makchaPath.subPath.first(where: { $0.idx == 1 }) {
                switch firstTransSubPath.subPathType {
                case .subway: // 🚇지하철
                    print("실시간 지하철 도착정보 API 호출")
                    if let stationName = firstTransSubPath.startName,
                       let subwayLine = firstTransSubPath.lane?.first?.subwayCode,
                       let wayCode = firstTransSubPath.wayCode {
                        let observable = transPathRepository.getSeoulRealtimeSubwayArrival(
                            stationName: stationName,
                            subwayLineCodeInt: subwayLine,
                            wayCodeInt: wayCode,
                            currentTime: currentTime
                        )
                        realtimeArrivalObservables.append(observable)
                    }
                    
                case .bus: // 🚌버스
                    // 노선ID, 노선명, arsID 구해서 전달
                    if let lanes = firstTransSubPath.lane,
                       let arsID = firstTransSubPath.startArsID {
                        
                        let routeIDs = lanes.compactMap { $0.busRouteID }
                        let routeNames = lanes.map { $0.name }
                        print("실시간 버스 도착정보 API 호출")
                        let observable = transPathRepository.getSeoulRealtimeBusArrival(
                            routeIDs: routeIDs,
                            routeNames: routeNames,
                            arsID: arsID
                        )
                        realtimeArrivalObservables.append(observable)
                    }
                    
                default:
                    break
                }
            }
        }
        
        // TODO: - combineLatest 동작 원리 제대로 모름. 다른 방법도 있는지 생각해보기
        Observable.combineLatest(realtimeArrivalObservables)
            .debug()
            .subscribe(onNext: { [weak self] arrivals in
                self?.realtimeArrivals.onNext(arrivals)
            })
            .disposed(by: disposeBag)
    }
}
