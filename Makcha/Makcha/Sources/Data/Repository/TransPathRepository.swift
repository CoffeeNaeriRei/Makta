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
    private let locationService: LocationServiceInterface
    
    init(_ apiService: APIServiceInterface, _ locationService: LocationServiceInterface) {
        self.apiService = apiService
        self.locationService = locationService
    }
    
    // 대중교통 환승경로 정보를 받아와서 Domain 계층의 UseCase에 전달
    func getAllMakchaTransPath(
        start: XYCoordinate,
        end: XYCoordinate
    ) -> Observable<MakchaInfo> {
        return Observable.create { emitter in
            self.apiService.fetchTransPathData(start: start, end: end) { result in
                switch result {
                case .success(let transPathDTO):
                    print("[APIService] - ✅ fetchTransPathData() 호출 성공!!")
                    guard let makchaInfo = self.convertTransPathDTOToMakchaInfo(transPathDTO: transPathDTO) else {
                        print("[APIService] - ❌ DTO → Entity 변환 실패")
                        emitter.onError(APIServiceError.entityConvertError)
                        return
                    }
                    emitter.onNext(makchaInfo)
                    emitter.onCompleted()
                case .failure(let error):
                    print("[APIService] - ❌ fetchTransPathData() 호출 실패")
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    // 현재 위치의 좌표를 불러와서 반환
    func getCurrentLocation() -> Observable<EndPoint> {
        return Observable.create { emitter in
            self.locationService.fetchCurrentLocation { (clLocation, error) in
                if let error = error {
                    print("[LocationService - ❌ 위치 불러오기 실패]")
                    emitter.onError(error)
                }
                guard let location = clLocation else {
                    print("[LocationService - ❌ 위치 데이터가 없음]")
                    emitter.onError(LocationServiceError.noLocationData)
                    return
                }
                let endPoint = EndPoint(
                    coordinate: (location.coordinate.longitude.description, location.coordinate.latitude.description)
                )
                emitter.onNext(endPoint)
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
}

extension TransPathRepository {
    
    // TransPathDTO -> MakchaInfo 변환 메서드
    func convertTransPathDTOToMakchaInfo(transPathDTO: TransPathDTO) -> MakchaInfo? {
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
                totalTime: totalTime,
                subPath: makchaSubPathArr
            )
            makchaPathArr.append(makchaPath)
        }
        
        let makchaInfo = MakchaInfo(
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
                subPathType: subPathType,
                distance: subPathArr[subPathIdx].distance,
                time: subPathArr[subPathIdx].sectionTime,
                stationCount: subPathArr[subPathIdx].stationCount,
                lane: laneInfoArr.isEmpty ? nil : laneInfoArr,
                startName: subPathArr[subPathIdx].startName,
                endName: subPathArr[subPathIdx].endName,
                stations: passStationArr.isEmpty ? nil : passStationArr
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
                if let subwayLine = eachLane.name {
                    laneInfo = LaneInfo(name: subwayLine)
                    laneInfoArr.append(laneInfo)
                    continue
                }
                if let busNo = eachLane.busNo {
                    laneInfo = LaneInfo(name: busNo)
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
