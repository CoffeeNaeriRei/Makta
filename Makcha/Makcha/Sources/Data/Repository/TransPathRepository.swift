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
    
    // 대중교통 환승경로 정보를 받아와서 Domain 계층의 UseCase에 전달
    func getAllMakchaTransPath(start: XYCoordinate, end: XYCoordinate) -> Observable<MakchaInfo> {
        return Observable.create() { emitter in
            APIService.fetchTransPathData(start: start, end: end) { [weak self] result in
                switch result {
                case .success(let data):
                    print("[APIService] - ✅ fetchTransPathData() 호출 성공!!")
                    guard let transPathDTO = try? JSONDecoder().decode(TransPathDTO.self, from: data) else {
                        print("[APIService] - ❌ DTO 디코딩 실패")
                        emitter.onError(APIServiceError.decodingError)
                        return
                    }
                    guard let makchaInfo = self?.convertTransPathDTOToMakchaInfo(transPathDTO: transPathDTO) else {
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
        let pathArr = transPathDTO.path
        guard let firstPath = pathArr.first else { return nil }
        let startStation = firstPath.info.firstStartStation // 전체 경로 중 출발역
        let endStation = firstPath.info.lastEndStation // 전체 경로 중 도착역
        
        var makchaPathArr = [MakchaPath]()
        for i in 0..<pathArr.count {
            // 경로 유형 구하기
            var makchaPathType: MakchaPathType
            switch pathArr[i].pathType {
            case 1:
                makchaPathType = .subway // 지하철
            case 2:
                makchaPathType = .bus // 버스
            case 3:
                makchaPathType = .both // 버스+지하철
            default:
                return nil
            }
            
            // 총 소요시간 구하기
            let totalTime = pathArr[i].info.totalTime
            
            // 세부경로 구하기
            let subPathArr = pathArr[i].subPath
            var makchaSubPathArr = [MakchaSubPath]()
            for j in 0..<subPathArr.count {
                // 세부경로 유형 구하기
                var subPathType: SubPathType
                switch subPathArr[j].trafficType {
                case 1:
                    subPathType = .subway // 지하철
                case 2:
                    subPathType = .bus // 버스
                case 3:
                    subPathType = .walk // 도보
                default:
                    return nil
                }
                
                // 세부경로 교통수단 정보
                var laneInfoArr = [LaneInfo]()
                if let laneArr = subPathArr[j].lane {
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
                }
                
                // 지나는 역
                var passStationArr = [PassStation]()
                if let stationArr = subPathArr[j].passStopList?.stations {
                    for station in stationArr {
                        let passStation = PassStation(index: station.index, name: station.stationName)
                        passStationArr.append(passStation)
                    }
                }
                
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
            
            let makchaPath = MakchaPath(
                fastest: i == 0 ? true : false, // 1번째 경로가 가장 빠른 경로
                makchaPathType: makchaPathType,
                totalTime: totalTime,
                subPath: makchaSubPathArr
            )
            makchaPathArr.append(makchaPath)
        }
        
        let makchaInfo = MakchaInfo(
            start: startStation,
            end: endStation,
            makchaPaths: makchaPathArr
        )
        
        return makchaInfo
    }
}
