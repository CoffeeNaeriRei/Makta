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

// 컬렉션뷰의 셀로 전달하기 위한 데이터 타입 (막차경로, 해당경로의실시간도착정보)
typealias MakchaCellData = (makchaPath: MakchaPath, arrival: RealtimeArrivalTuple)

final class MakchaInfoUseCase {
    private let transPathRepository: TransPathRepositoryProtocol
    private let endPointRepository: EndPointRepositoryProtocol
    
    // MakchaInfoUseCase 내부에서만 관찰하는 스트림 (테스트 코드 때문에 private은 적용 x, 나중에 모듈 분리하면 접근제어자 설정)
    let makchaInfo = PublishSubject<MakchaInfo>() // 막차 정보
    let realtimeArrivals = PublishSubject<[RealtimeArrivalTuple]>() // 막차 경로 별 실시간 도착 정보
    private let timerEvent = PublishRelay<Void>() // 실시간 도착 정보 타이머 이벤트
    
    let makchaSectionOfMainCard = PublishSubject<SectionOfMainCard>() // 컬렉션뷰 바인딩을 위한 SectionModel에 전달할 데이터
    let startPoint = PublishSubject<EndPoint>() // 출발지 정보
    let destinationPoint = PublishSubject<EndPoint>() // 도착지 정보
    let searchedStartPoints = BehaviorSubject<[EndPoint]>(value: []) // 검색 결과로 불러온 출발지 주소들
    let searchedDestinationPoints = BehaviorSubject<[EndPoint]>(value: []) // 검색 결과로 불러온 도착지 주소들
    
    private let disposeBag = DisposeBag()
    private var timerDisposable: Disposable? // 타이머 구독을 제어하기 위한 Disposable
    
    private var isStartPointSearch: Bool = true // 출발지/도착지 중 어느 곳에 대한 검색인지 여부를 체크
    private var startPointValue = EndPoint.mockStartPoint
    private var destinationPointValue = EndPoint.mockDestinationPoint
    
    private var isSheetOpened = false // 검색 시트가 열려 있는지 여부를 체크하는 값
    
    init(_ transPathRepository: TransPathRepositoryProtocol, _ endPointRepository: EndPointRepositoryProtocol) {
        self.transPathRepository = transPathRepository
        self.endPointRepository = endPointRepository
        
        // 기본 도착지로 초기화 세팅
        let defaultDestination = EndPoint.loadFromUserDefaults(key: .defaultDestination) ?? EndPoint.mockDestinationPoint
        defaultDestination.saveAsUserDefaults(key: .tempDestination)
        destinationPointValue = defaultDestination
        destinationPoint.onNext(destinationPointValue)
        
        subscribeTimer()
        subscribeMakchaSectionModel()
    }
    
    // MARK: - 주소 검색 결과 불러오기
    func searchWithAddressText(isStartPoint: Bool, searchKeyword: String) {
        print("[MakchaInfoUseCase] - \"\(searchKeyword)\" 키워드에 대한 주소 검색 결과 불러오기")
        endPointRepository.getSearchedAddresses(searchKeyword: searchKeyword)
            .withUnretained(self)
            .subscribe(onNext: { `self`, searchedAddressArr in
                if isStartPoint {
                    self.isStartPointSearch = true
                    self.searchedStartPoints.onNext(searchedAddressArr)
                } else {
                    self.isStartPointSearch = false
                    self.searchedDestinationPoints.onNext(searchedAddressArr)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 검색 결과에서 선택한 주소로 출발지/도착지를 업데이트
    func updatePointToSearchedAddress(idx: Int) {
        if isStartPointSearch {
            // 출발지 업데이트
            guard let selectedEndPoint = try? searchedStartPoints.value()[idx] else { return }
            startPointValue = selectedEndPoint
            startPoint.onNext(startPointValue)
        } else {
            // 도착지 업데이트
            guard let selectedEndPoint = try? searchedDestinationPoints.value()[idx] else { return }
            destinationPointValue = selectedEndPoint
            destinationPoint.onNext(destinationPointValue)
            selectedEndPoint.saveAsUserDefaults(key: .tempDestination)
            
        }
    }
    
    // MARK: - 출발지 리셋
    /**
     - Core Location을 통해 불러온 현재 위치로 갱신
     - searchedDestinationPoints 배열 초기화
     -
     */
    func resetStartPoint() {
        endPointRepository.getCurrentLocation()
            .withUnretained(self)
            .subscribe(onNext: { `self`, currentLocation in
                self.startPointValue = currentLocation
                self.startPoint.onNext(self.startPointValue)
                self.searchedStartPoints.onNext([])
                // 검색 시트가 닫혀 있다면 막차 경로도 다시 검색
                if !self.isSheetOpened {
                    self.loadMakchaPathWithSearchedLocation()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 도착지 리셋
    /**
     - 기본 설정된 도착지로 destinationPoint를 갱신
     - UserDefaults의 "tempDestination"도 기본 도착지로 갱신
     - searchedDestinationPoints 배열 초기화
     -
     */
    func resetDestinationPoint() {
        guard let defaultDestination = EndPoint.loadFromUserDefaults(key: .defaultDestination) else { return }
        defaultDestination.saveAsUserDefaults(key: .tempDestination)
        destinationPointValue = defaultDestination
        destinationPoint.onNext(destinationPointValue)
        searchedDestinationPoints.onNext([])
        // 검색 시트가 닫혀 있다면 막차 경로도 다시 검색
        if !self.isSheetOpened {
            self.loadMakchaPathWithSearchedLocation()
        }
    }
    
    // MARK: - 현재 위치 기반으로 막차 경로 불러오기
    func loadMakchaPathWithCurrentLocation() {
        print("[MakchaInfoUseCase] - 현재 위치 기반으로 막차 경로 불러오기")
        endPointRepository.getCurrentLocation()
            .withUnretained(self)
            .subscribe(onNext: { `self`, currentLocation in
                self.startPointValue = currentLocation
                self.startPoint.onNext(self.startPointValue)
                self.destinationPoint.onNext(self.destinationPointValue)
                
                let currentLocationCoordinate = (self.startPointValue.lonX, self.startPointValue.latY)
                let destinationLocationCoordinate = (self.destinationPointValue.lonX, self.destinationPointValue.latY)
                self.loadMakchaPath(start: currentLocationCoordinate, destination: destinationLocationCoordinate)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 검색한 위치 기반으로 막차 경로 불러오기
    func loadMakchaPathWithSearchedLocation() {
        let startCoord = (startPointValue.lonX, startPointValue.latY)
        let destinationCoord = (destinationPointValue.lonX, destinationPointValue.latY)
        loadMakchaPath(start: startCoord, destination: destinationCoord)
    }
    
    // MARK: - 막차 경로 검색
    func loadMakchaPath(start: XYCoordinate, destination: XYCoordinate) {
        transPathRepository.getAllMakchaTransPath(start: start, destination: destination)
            .withUnretained(self)
            .subscribe {
                // 실시간 도착정보 불러오기
                $0.makeRealtimeArrivalTimes(currentTime: $1.startTime, makchaPaths: $1.makchaPaths)
                // 새로운 MakchaInfo로 값을 업데이트
                $0.makchaInfo.onNext($1)
            }
            .disposed(by: disposeBag)
    }
    
    /// 검색 시트 열림 여부를 갱신하는 메서드
    func updateIsSheetOpened(_ isOpened: Bool) {
        isSheetOpened = isOpened
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
                            // MARK: 타입 변경 확인필요
                            subwayLineCodeInt: subwayLine.rawValue,
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
                prevRealtimeArrivals.map { arrivalTuple in
                    (
                        arrivalTuple.first.decreaseRemainingTime(),
                        arrivalTuple.second.decreaseRemainingTime()
                    )
                }
            }
            .bind(to: realtimeArrivals)
            .disposed(by: disposeBag)
    }
    
    /**
     ### [ makchaSectionModel 구독 (실제 컬렉션뷰로 넘겨줄 데이터를 만들어주는 스트림) ]
     makchaInfo와 realtimeArrivals가 동시에 갱신되는 것이 아니기 때문에 한쪽의 개수가 달라지는 순간 인덱스가 맞지 않음.
     그래서 각각의 배열의 길이가 같을 때 이벤트를 전달
     */
    private func subscribeMakchaSectionModel() {
        Observable.combineLatest(makchaInfo, realtimeArrivals)
            .subscribe(onNext: { [weak self] makchaInfo, realtimeArrivals in
                var updatedMakchaCell = [MakchaCellData]()
                if makchaInfo.makchaPaths.count == realtimeArrivals.count {
                    for makchaIdx in 0..<realtimeArrivals.count {
                        let realtimeArrival = realtimeArrivals[makchaIdx]
                        
                        // makchaPath의 첫번째 대중교통 SubPath에 ~행/~방면 정보를 반영
                        let wayOfFirstSubPath = realtimeArrival.first.way
                        let nextStOfFirstSubPath = realtimeArrival.first.nextSt
                        let makchaPath = makchaInfo.makchaPaths[makchaIdx].assignWayAndNextStToFirstSubPath(
                            way: wayOfFirstSubPath,
                            nextSt: nextStOfFirstSubPath
                        )
                        
                        let cellData: MakchaCellData = (makchaPath, realtimeArrival)
                        updatedMakchaCell.append(cellData)
                    }
                    self?.makchaSectionOfMainCard.onNext(
                        SectionOfMainCard(
                            model: makchaInfo.startTimeStr,
                            items: updatedMakchaCell
                        )
                    )
                }
            })
            .disposed(by: disposeBag)
    }
}
