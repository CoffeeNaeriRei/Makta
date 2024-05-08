//
//  TransPathRepository.swift
//  Makcha
//
//  Created by 김영빈 on 5/7/24.
//

// MARK: - TransPathRepository 정의
// DTO -> Entity 변환 후 Domain 계층(UseCase)에 전달

import Foundation

import RxSwift

final class TransPathRepository: TransPathRepositoryProtocol {
    
    private let apiService: APIServiceInterface
    
    init(apiService: APIServiceInterface) {
        self.apiService = apiService
    }
    
    // 대중교통 환승경로 정보를 받아와서 Domain 계층의 UseCase에 전달
    func getAllMakchaTransPath(
        start: XYCoordinate,
        end: XYCoordinate
    ) -> Observable<MakchaInfo> {
        return Observable.create {emitter in
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
}

extension TransPathRepository {
    
    // TransPathDTO -> MakchaInfo 변환 메서드
    func convertTransPathDTOToMakchaInfo(transPathDTO: TransPathDTO) -> MakchaInfo? {
        let pathArr: [Path] = transPathDTO.result.path
        
        var makchaPathArr = [MakchaPath]()
        for i in 0..<pathArr.count {
            // 경로 유형 구하기
            guard let makchaPathType: MakchaPathType = convertIntToMakchaPathType(makchaPathTypeInt: pathArr[i].pathType) else {
                return nil
            }
            // 총 소요시간 구하기
            let totalTime = pathArr[i].info.totalTime
            
            // 세부경로 구하기
            guard let makchaSubPathArr = makeSubPathArr(subPathArr: pathArr[i].subPath) else {
                return nil
            }
            
            let makchaPath = MakchaPath(
                fastest: i == 0 ? true : false, // 1번째 경로가 가장 빠른 경로
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
        for j in 0..<subPathArr.count {
            // 세부경로 [유형] 구하기
            guard let subPathType: SubPathType = convertIntToSubPathType(subPathTypeInt: subPathArr[j].trafficType) else {
                return nil
            }
            // 세부경로 [교통수단 정보] 구하기
            let laneInfoArr: [LaneInfo] = makeLaneInfoArr(lane: subPathArr[j].lane)
            // 세부경로 [지나는 역] 구하기
            let passStationArr: [PassStation] = makePassStaionArr(passStopList: subPathArr[j].passStopList)
            
            let makchaSubPath = MakchaSubPath(
                subPathType: subPathType,
                distance: subPathArr[j].distance,
                time: subPathArr[j].sectionTime,
                stationCount: subPathArr[j].stationCount,
                lane: laneInfoArr.isEmpty ? nil : laneInfoArr,
                startName: subPathArr[j].startName,
                endName: subPathArr[j].endName,
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
