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

// 컬렉션뷰의 셀에 전달할 데이터 타입 (막차경로, 해당경로의실시간도착정보)
typealias MakchaCellData = (makchaPath: MakchaPath, arrival: RealtimeArrivalTuple)

final class MakchaInfoUseCase {
    private let transPathRepository: TransPathRepositoryProtocol
    private let endPointRepository: EndPointRepositoryProtocol
    
    // MakchaInfoUseCase 내부에서만 관찰하는 스트림 (테스트 코드 때문에 private은 적용 x, 나중에 모듈 분리하면 접근제어자 설정)
    let makchaInfo = PublishSubject<MakchaInfo>() // 막차 정보
    let realtimeArrivals = PublishSubject<[RealtimeArrivalTuple]>() // 막차 경로 별 실시간 도착 정보
    private let timerEvent = PublishRelay<Void>() // 실시간 도착 정보 타이머 이벤트
    
    let makchaSectionModel = PublishSubject<(startTimeStr: String, makchaCellData: [MakchaCellData])>() // 컬렉션뷰 바인딩을 위한 SectionModel에 전달할 데이터
    let startPoint = PublishSubject<EndPoint>() // 출발지 정보
    let destinationPoint: BehaviorSubject<EndPoint> // 도착지 정보
    let searchedEndPoints = BehaviorSubject<[EndPoint]>(value: []) // 검색 결과로 불러온 주소들
    
    private let disposeBag = DisposeBag()
    private var timerDisposable: Disposable? // 타이머 구독을 제어하기 위한 Disposable
    
    init(_ transPathRepository: TransPathRepositoryProtocol, _ endPointRepository: EndPointRepositoryProtocol) {
        self.transPathRepository = transPathRepository
        self.endPointRepository = endPointRepository
        
        // TODO: 사용자가 설정한 기본 목적지로 초기화하기
        let destionationCoordinate = EndPoint.mockDestinationPoint
        destinationPoint = BehaviorSubject<EndPoint>(value: destionationCoordinate)
        
        subscribeTimer()
        subscribeMakchaSectionModel()
    }
    
    // MARK: - 주소 검색 결과 불러오기
    func searchWithAddressText(searchKeyword: String) {
        print("[MakchaInfoUseCase] - \"\(searchKeyword)\" 키워드에 대한 주소 검색 결과 불러오기")
        endPointRepository.getSearchedAddresses(searchKeyword: searchKeyword)
            .withUnretained(self)
            .subscribe(onNext: { `self`, searchedAddressArr in
                self.searchedEndPoints.onNext(searchedAddressArr)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 출발지를 검색한 주소로 업데이트
    func updateStartPointToSearchedAddress(addressIdx: Int) {
        
    }
    
    // MARK: - 도착지를 검색한 주소로 업데이트
    func updateDestinationPointToSearchedAddress(addressIdx: Int) {
        
    }
    
    // MARK: - 현재 위치 기반으로 막차 경로 불러오기
    func loadMakchaPathWithCurrentLocation() {
        print("[MakchaInfoUseCase] - 현재 위치 기반으로 막차 경로 불러오기")
        endPointRepository.getCurrentLocation()
            .withUnretained(self)
            .subscribe(onNext: { `self`, currentLocation in
                self.startPoint.onNext(currentLocation)
                
                if let destinationCoordinate = try? self.destinationPoint.value().coordinate {
                    self.loadMakchaPath(start: currentLocation.coordinate, end: destinationCoordinate)
                }
            })
            .disposed(by: disposeBag)
    }
    
//    // MARK: - 검색한 위치 기반으로 막차 경로 불러오기
//    func loadMakchaPathWithSearchedLocation() {
//        let start = startPoint.value.coordinate
//        let end = destinationPoint.value.coordinate
//        loadMakchaPath(start: start, end: end)
//    }
    
    // MARK: - 막차 경로 검색
    func loadMakchaPath(start: XYCoordinate, end: XYCoordinate) {
        transPathRepository.getAllMakchaTransPath(start: start, end: end)
            .withUnretained(self)
            .subscribe {
                // 실시간 도착정보 불러오기
                $0.makeRealtimeArrivalTimes(currentTime: $1.startTime, makchaPaths: $1.makchaPaths)
                // 새로운 MakchaInfo로 값을 업데이트
                $0.makchaInfo.onNext($1)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - MakchaPath 배열을 받아와서 각 경로별 실시간 도착정보를 만들어주는 메서드
    private func makeRealtimeArrivalTimes(currentTime: Date, makchaPaths: [MakchaPath]) {
        var realtimeArrivalObservables: [Observable<RealtimeArrivalTuple>] = []
        
        // 각각의 막차경로에 대해 1번째 대중교통 세부경로 타입에 따른 실시간 도착정보 받아오기
        for makchaPath in makchaPaths {
            // 첫번째 대중교통 세부경로가 있을 때만 실시간 도착정보를 받아옴 (0번 인덱스는 항상 도보임)
            if let firstTransSubPath = makchaPath.subPath.first(where: { $0.idx == 1 }) {
                switch firstTransSubPath.subPathType {
                case .subway: // 🚇지하철
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
        
        Observable.combineLatest(realtimeArrivalObservables)
            .withUnretained(self)
            .subscribe(onNext: { _, arrivals in
                self.realtimeArrivals.onNext(arrivals)
                self.startTimer()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 타이머 시작
    // TODO: - 새 타이머가 시작될 때 외에도 동작 중인 타이머를 종료시킬 시점이 더 필요한지 생각해보기
    private func startTimer() {
        print("타이머 시작")
        timerDisposable?.dispose() // 기존 타이머 종료
        timerDisposable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//            .take(몇초까지할지)
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.timerEvent.accept(())
            }, onCompleted: {
                print("타이머 종료")
            })
        
        timerDisposable?.disposed(by: disposeBag)
    }
}

// MARK: - init() 시점에서의 구독

extension MakchaInfoUseCase {
    // 타이머 이벤트 구독
    private func subscribeTimer() {
        timerEvent
            .withUnretained(self)
            .withLatestFrom(realtimeArrivals)
            .map { prevRealtimeArrivals in
                prevRealtimeArrivals.map { arrival in
                    (
                        first: arrival.first.decreaseTimeFromArrivalStatus(),
                        second: arrival.second.decreaseTimeFromArrivalStatus()
                    )
                }
            }
            .bind(to: realtimeArrivals)
            .disposed(by: disposeBag)
    }
    
    // makchaSectionModel 구독 (실제 컬렉션뷰로 넘겨줄 데이터를 만들어주는 스트림)
    private func subscribeMakchaSectionModel() {
        Observable.combineLatest(makchaInfo, realtimeArrivals)
            .subscribe(onNext: { [weak self] makchaInfo, realtimeArrivals in
                var updatedMakchaCell = [MakchaCellData]()
                for makchaIdx in 0..<realtimeArrivals.count {
                    let cellData: MakchaCellData = (makchaInfo.makchaPaths[makchaIdx], realtimeArrivals[makchaIdx])
                    updatedMakchaCell.append(cellData)
                }
                self?.makchaSectionModel.onNext((makchaInfo.startTimeStr, updatedMakchaCell))
            })
            .disposed(by: disposeBag)
    }
}
