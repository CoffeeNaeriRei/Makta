//
//  TransPathRepository.swift
//  Makcha
//
//  Created by 김영빈 on 5/7/24.
//

import Foundation

import RxSwift

// MARK: - TransPathRepository 정의
// DTO -> Entity 변환 후 Domain 계층(UseCase)에 전달

final class TransPathRepository: TransPathRepositoryProtocol {
    private let apiService: APIServiceInterface
    
    init(_ apiService: APIServiceInterface) {
        self.apiService = apiService
    }
    
    /// 대중교통 환승경로 정보를 받아와서 Domain 계층의 UseCase에 전달
    func getAllMakchaTransPath(
        start: XYCoordinate,
        destination: XYCoordinate
    ) -> Observable<MakchaInfo> {
        return Observable.create { emitter in
            self.apiService.fetchTransPathData(start: start, destination: destination) { result in
                switch result {
                case .success(let transPathDTOResponse):
                    guard let responseType = transPathDTOResponse.type else {
                        emitter.onError(APIServiceError.noData)
                        return
                    }
                    
                    switch responseType {
                    case .success: // TransPathDTO
                        guard let transPathDTO = transPathDTOResponse as? TransPathDTO,
                              let makchaInfo = self.convertTransPathDTOToMakchaInfo(transPathDTO: transPathDTO) else {
                            print("[APIService] - ❌ DTO → Entity 변환 실패")
                            emitter.onError(APIServiceError.entityConvertError)
                            return
                        }
                        emitter.onNext(makchaInfo)
                        emitter.onCompleted()
                    case .error: // TransPathErrorDTO
                        guard let transPathErrorDTO = transPathDTOResponse as? TransPathErrorDTO else {
                            emitter.onError(APIServiceError.entityConvertError)
                            return
                        }
                        emitter.onError(transPathErrorDTO.error.errorType)
                    }
                    
                case .failure(let error):
                    print("[APIService] - ❌ fetchTransPathData() 호출 실패 \(error.localizedDescription)")
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    /// 지하철역 이름 + 호선 정보 + 방면 정보를 기반으로 서울시 지하철역의 실시간 도착정보를 2개 받아와서 전달
    func getSeoulRealtimeSubwayArrival(
        stationName: String,
        subwayLineCodeInt: Int,
        wayCodeInt: Int,
        currentTime: Date // 현재 시간 (남은 시간 계산 시 필요)
    ) -> Observable<RealtimeArrivalTuple> {
        return Observable.create { emitter in
            // 서울시 실시간 지하철 도착정보 API에 필요한 [호선ID]와 [방면코드] 추출
            guard let subwayLineCode = SubwayCode(rawValue: subwayLineCodeInt)?.seoulRealtimeSubwayID,
                  let wayCode = SubwayWay(rawValue: wayCodeInt)?.seoulRealtimeSubwayWayCode else {
                let realtimeArrivalTuple: RealtimeArrivalTuple = (RealtimeArrivalInfo.emptyValue, RealtimeArrivalInfo.emptyValue)
                emitter.onNext(realtimeArrivalTuple)
                emitter.onCompleted()
                return Disposables.create()
            }
            // 서울시 실시간 지하철 도착정보 API 호출
            self.apiService.fetchSeoulRealtimeSubwayArrival(stationName: stationName) { result in
                switch result {
                case .success(let seoulRealtimeSubwayDTO):
                    // 호선+상하행 정보가 일치하는 데이터만 필터링
                    let arrivals = seoulRealtimeSubwayDTO.realtimeArrivalList
                    let filteredArrivals = self.filteringSeoulArrivalSubway(from: arrivals, subwayLine: subwayLineCode, wayCode: wayCode)
                    
                    // 실제 도착까지 남은 시간 구해서 도착정보 데이터 생성
                    // TODO: - 지하철 도착 메세지 등 정보도 확인해서 적절한 ArrivalStatus로 반환할 수 있도록 수정하기
                    let realtimeArrival = self.makeRealtimeArrivalFromSeoulSubway(from: filteredArrivals, currentTime: currentTime)
                    emitter.onNext(realtimeArrival)
                    emitter.onCompleted()
                case .failure(let error):
                    print("[APIService] - ❌ fetchSeoulRealtimeSubwayArrival() 호출 실패 \(error.localizedDescription)")
                    // 실시간 정보를 불러오지 못해도 기본값으로 전달
                    let emptyRealtimeArrival = (RealtimeArrivalInfo.emptyValue, RealtimeArrivalInfo.emptyValue)
                    emitter.onNext(emptyRealtimeArrival)
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    // 노선ID + 노선명 + 버스정류장 ID를 기반으로 해당하는 서울시 버스 정류장에서 해당 노선의 실시간 도착정보를 2개 받아와서 전달
    func getSeoulRealtimeBusArrival(
        routeIDs: [String], // 노선ID
        routeNames: [String], // 노선명(버스번호)
        arsID: String // 정류장ID
    ) -> Observable<RealtimeArrivalTuple> {
        return Observable.create { emitter in
            // 서울시 정류소정보조회 API 호출
            self.apiService.fetchSeoulRealtimeBusStationInfo(arsID: arsID) { result in
                switch result {
                case .success(let seoulRealtimeBusStationDTO):
                    // 노선ID+노선명이 매칭되는 도착 정보들만 필터링
                    let filteredArrivals = seoulRealtimeBusStationDTO.arrivals.itemList.filter {
                        (routeIDs.contains($0.busRouteID)) && (routeNames.contains($0.busRouteName))
                    }
                    // 각 노선들에 대한 도착 정보에서 첫번째, 두번째 도착 메시지를 추출하고, ArrivalStatus의 우선순위가 높은(작은값) 순서대로 정렬
                    let firstArrivals = filteredArrivals.map { self.getBusArrivalStatusFromSeoulBusStation(arrivalMessage: $0.arrivalMessage1) }.sorted(by: <)
                    let secondArrivals = filteredArrivals.map { self.getBusArrivalStatusFromSeoulBusStation(arrivalMessage: $0.arrivalMessage2) }.sorted(by: <)
                    
                    // 가장 가까운 도착 정보를 튜플에 반영
                    let first = RealtimeArrivalInfo(status: firstArrivals.first ?? .unknown)
                    let second = RealtimeArrivalInfo(status: secondArrivals.first ?? .unknown)
                    let realtimeArrival = (first, second)
                    
                    // TODO: - 몇번(노선) 버스인지도 알 수 있도록 처리가 필요함
                    
                    emitter.onNext(realtimeArrival)
                    emitter.onCompleted()
                    
                case .failure(let error):
                    print("[APIService] - ❌ fetchSeoulRealtimeBusStationInfo() 호출 실패 \(error.localizedDescription)")
                    let emptyRealtimeArrival = (RealtimeArrivalInfo.emptyValue, RealtimeArrivalInfo.emptyValue)
                    emitter.onNext(emptyRealtimeArrival)
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

// MARK: - 대중교통 환승정보 불러오기 관련 유틸리티 메서드

private extension TransPathRepository {
    // TransPathDTO -> MakchaInfo 변환 메서드
    func convertTransPathDTOToMakchaInfo(transPathDTO: TransPathDTO) -> MakchaInfo? {
        let startTime = Date() // 출발시간(현재시간)
        let pathArr: [Path] = transPathDTO.result.path
        
        var makchaPathArr = [MakchaPath]()
        for pathIdx in 0..<pathArr.count {
            // 경로 유형 구하기
            guard let makchaPathType: MakchaPathType = convertIntToMakchaPathType(makchaPathTypeInt: pathArr[pathIdx].pathType) else {
                return nil
            }
            // 총 소요시간 구하기
            let totalTime = pathArr[pathIdx].info.totalTime
            
            // 세부경로 구하기
            guard let makchaSubPathArr = makeSubPathArr(subPathArr: pathArr[pathIdx].subPath) else {
                return nil
            }
            
            let makchaPath = MakchaPath(
                fastest: pathIdx == 0 ? true : false, // 1번째 경로가 가장 빠른 경로
                makchaPathType: makchaPathType,
                arrivalTime: startTime.timeAfterMinute(after: totalTime),
                totalTime: totalTime,
                subPath: makchaSubPathArr
            )
            makchaPathArr.append(makchaPath)
        }
        
        let makchaInfo = MakchaInfo(
            startTime: startTime,
            makchaPaths: makchaPathArr
        )
        
        return makchaInfo
    }
    
    func convertIntToMakchaPathType(makchaPathTypeInt: Int) -> MakchaPathType? {
        switch makchaPathTypeInt {
        case 1:
            return .subway
        case 2:
            return .bus
        case 3:
            return .both
        default:
            return nil
        }
    }
    
    func makeSubPathArr(subPathArr: [SubPath]) -> [MakchaSubPath]? {
        var makchaSubPathArr = [MakchaSubPath]()
        for subPathIdx in 0..<subPathArr.count {
            // 세부경로 [유형] 구하기
            guard let subPathType: SubPathType = convertIntToSubPathType(subPathTypeInt: subPathArr[subPathIdx].trafficType) else {
                return nil
            }
            // 세부경로 [교통수단 정보] 구하기
            let laneInfoArr: [LaneInfo] = makeLaneInfoArr(lane: subPathArr[subPathIdx].lane)
            // 세부경로 [지나는 역] 구하기
            let passStationArr: [PassStation] = makePassStaionArr(passStopList: subPathArr[subPathIdx].passStopList)
            
            let makchaSubPath = MakchaSubPath(
                idx: subPathIdx,
                subPathType: subPathType,
                distance: subPathArr[subPathIdx].distance,
                time: (subPathArr[subPathIdx].sectionTime == 0) ? 1 : subPathArr[subPathIdx].sectionTime, // 소요시간이 0분으로 오는 데이터는 1분으로
                stationCount: subPathArr[subPathIdx].stationCount,
                lane: laneInfoArr.isEmpty ? nil : laneInfoArr,
                startName: subPathArr[subPathIdx].startName,
                endName: subPathArr[subPathIdx].endName,
                stations: passStationArr.isEmpty ? nil : passStationArr,
                way: subPathArr[subPathIdx].way,
                wayCode: subPathArr[subPathIdx].wayCode,
                startArsID: subPathArr[subPathIdx].startArsID
            )
            
            makchaSubPathArr.append(makchaSubPath)
        }
        return makchaSubPathArr
    }
    
    func convertIntToSubPathType(subPathTypeInt: Int) -> SubPathType? {
        switch subPathTypeInt {
        case 1:
            return .subway // 지하철
        case 2:
            return .bus // 버스
        case 3:
            return .walk // 도보
        default:
            return nil
        }
    }
    
    func makeLaneInfoArr(lane: [Lane]?) -> [LaneInfo] {
        if let laneArr = lane {
            var laneInfoArr = [LaneInfo]()
            for eachLane in laneArr {
                let laneInfo: LaneInfo
                if let subwayLine = eachLane.name,
                let subwayCode = eachLane.subwayCode { // 지하철 노선 정보
                    laneInfo = LaneInfo(
                        name: subwayLine,
                        subwayCode: SubwayCode(rawValue: subwayCode)
                    )
                    laneInfoArr.append(laneInfo)
                    continue
                }
                if let busRouteName = eachLane.busNo,
                   let busRouteID = eachLane.busLocalBlID,
                   let busRouteType = eachLane.type { // 버스 노선 정보
                    laneInfo = LaneInfo(
                        name: busRouteName,
                        busRouteID: busRouteID,
                        busRouteType: BusRouteType(rawValue: busRouteType)
                    )
                    laneInfoArr.append(laneInfo)
                    continue
                }
            }
            return laneInfoArr
        } else {
            return []
        }
    }
    
    func makePassStaionArr(passStopList: PassStopList?) -> [PassStation] {
        if let stationArr = passStopList?.stations {
            var passStationArr = [PassStation]()
            for station in stationArr {
                let passStation = PassStation(index: station.index, name: station.stationName)
                passStationArr.append(passStation)
            }
            return passStationArr
        } else {
            return []
        }
    }
}

// MARK: - 서울시 실시간 지하철 도착정보 불러오기 관련 유틸리티 메서드

private extension TransPathRepository {
    /// 서울시 실시간 지하철 도착정보 배열에서 호선+방면이 일치하는 도착정보를 필터링해서 반환
    func filteringSeoulArrivalSubway(
        from arrivals: [SeoulRealtimeSubwayArrival],
        subwayLine: String,
        wayCode: String
    ) -> [SeoulRealtimeSubwayArrival] {
        let filteredArival = arrivals.filter {
            // 각각의 도착정보에 대해서 호선+방면이 일치하는 정보들만 필터링
            guard let arrivalWayCode = $0.ordkey[0] else { return false } // 방면코드(상하행코드)
            return ($0.subwayId == subwayLine) && (wayCode == arrivalWayCode)
        }
        return filteredArival
    }
    
    /**
     서울시 실시간 지하철 도착 정보 배열에서 1번째, 2번째 지하철 도착 정보를 반환
     - 실제 도착까지 남은 시간이 0 이상인 값 중 가장 금방 도착하는 2개 값을 사용
     - 없을 경우에는 빈 값
     */
    func makeRealtimeArrivalFromSeoulSubway(from arrivalArr: [SeoulRealtimeSubwayArrival], currentTime: Date) -> RealtimeArrivalTuple {
        var arrivalInfos = arrivalArr.filter {
            // 유효한(실제 도착까지 남은 시간이 0 이상인) 도착정보 필터링
            getRealRemainingTimeFromSeoulSubway(arrival: $0, currentTime: currentTime) >= 0
        }.sorted {
            // 도착까지 남은 시간을 기준으로 오름차순 정렬
            let compA = getRealRemainingTimeFromSeoulSubway(arrival: $0, currentTime: currentTime)
            let compB = getRealRemainingTimeFromSeoulSubway(arrival: $1, currentTime: currentTime)
            return compA <= compB
        }.map {
            // RealtimeArrivalInfo로 변환
            makeRealtimeArrivalInfo(from: $0, currentTime: currentTime)
        }
        
        // 유효한 도착 정보가 1개 이하인 경우 나머지는 빈 값 처리
        if arrivalInfos.count == 0 {
            arrivalInfos.append(RealtimeArrivalInfo.emptyValue)
            arrivalInfos.append(RealtimeArrivalInfo.emptyValue)
        } else if arrivalInfos.count == 1 {
            arrivalInfos.append(RealtimeArrivalInfo.emptyValue)
        }
        
        return (arrivalInfos[0], arrivalInfos[1])
    }
    
    /**
     서울시 실시간 지하철 도착정보의 SeoulRealtimeSubwayArrival 데이터를 RealtimeArrivalInfo 데이터로 변환
     - 해당 도착정보로부터 아래 3가지 정보를 추출
        - 도착까지 남은 시간
        - ~행 정보 (way)
        - ~방면 정보 (nextSt)
     */
    func makeRealtimeArrivalInfo(from seoulRealtimeSubwayArrival: SeoulRealtimeSubwayArrival, currentTime: Date) -> RealtimeArrivalInfo {
        let realRemainingTime = getRealRemainingTimeFromSeoulSubway(arrival: seoulRealtimeSubwayArrival, currentTime: currentTime)
        let status: ArrivalStatus = .coming(remainingSecond: realRemainingTime)
        var way: String?
        var nextSt: String?
        let wayAndNextSt = seoulRealtimeSubwayArrival.trainLineNm.components(separatedBy: " - ")
        if wayAndNextSt.count >= 2 {
            way = wayAndNextSt[0]
            nextSt = wayAndNextSt[1]
        }
        return RealtimeArrivalInfo(status: status, way: way, nextSt: nextSt)
    }
    
    /**
     서울시 지하철 도착정보로부터 실제 도착까지 남은 시간을 구해서 초 단위 값(Int)으로 반환
     - 데이터 생성 시간값을 활용해 실제 도착시간을 구해준다.
     - 실제 도착시간을 현재 시간과 비교하여 실제 도착까지 남은 시간을 구해줌
     */
    func getRealRemainingTimeFromSeoulSubway(arrival: SeoulRealtimeSubwayArrival, currentTime: Date) -> Int {
        if let generateTime = arrival.recptnDt.toDate(),
           let remainingTime = Int(arrival.barvlDt) {
            let realArrivalTime = generateTime.timeAfterSecond(after: remainingTime) // 실제 도착시간
            let realRemainingTime = Int(realArrivalTime.timeIntervalSince(currentTime)) // 실제 도착까지 남은시간
            return realRemainingTime
        } else {
            return -1
        }
    }
}

// MARK: - 서울시 실시간 버스 도착정보 불러오기 관련 유틸리티 메서드

private extension TransPathRepository {
    /// 버스의 도착 상태를 구해서 BusArrivalStatus 타입 값을 반환하는 메서드
    func getBusArrivalStatusFromSeoulBusStation(arrivalMessage: String) -> ArrivalStatus {
        if arrivalMessage.contains("출발대기") {
            return .waiting
        } else if arrivalMessage.contains("운행종료") {
            return .finished
        } else if arrivalMessage.contains("곧 도착") {
            return .arriveSoon
        } else if arrivalMessage.isContainsNumber() {
            return .coming(remainingSecond: arrivalMessage.getSeoulBusRemainingSecond())
        } else {
            return .unknown
        }
    }
}
