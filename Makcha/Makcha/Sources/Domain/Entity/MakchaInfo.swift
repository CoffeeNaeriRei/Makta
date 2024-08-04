//
//  MakchaInfo.swift
//  Makcha
//
//  Created by 김영빈 on 5/7/24.
//

import Foundation

// MARK: - MakchaInfo
// 불러온 막차 경로 정보를 담을 Entity 모델

struct MakchaInfo: Equatable {
    let startTime: Date // 출발시간(현재시간)
    let makchaPaths: [MakchaPath] // 각각의 막차 경로 정보
    
    // 출발시간을 메인 화면의 시간 형식으로 표현한 String
    var startTimeStr: String {
        startTime.endPointTimeString
    }
}

// 막차 경로 정보
struct MakchaPath: Equatable {
    let fastest: Bool // 가장 빠른 경로 여부
    let makchaPathType: MakchaPathType // 경로 유형
    let arrivalTime: Date // 도착시간
    let totalTime: Int // 총 소요시간 (단위: 분)
    let subPath: [MakchaSubPath] // 세부경로들
    
    /// 1번째 대중교통 세부경로에 ~행/~방면 정보를 반영한 MakchaPath를 새로 리턴
    func assignWayAndNextStToFirstSubPath(way: String?, nextSt: String?) -> Self {
        if subPath.count > 1 {
            var newSubPath = subPath
            newSubPath[1].way = way
            newSubPath[1].nextSt = nextSt
            return MakchaPath(
                fastest: fastest,
                makchaPathType: makchaPathType,
                arrivalTime: arrivalTime,
                totalTime: totalTime,
                subPath: newSubPath
            )
        } else {
            return self
        }
    }
}

enum MakchaPathType: String {
    case subway = "지하철"
    case bus = "버스"
    case both = "지하철+버스"
}

// 세부경로
struct MakchaSubPath: Equatable {
    let idx: Int // 세부경로 순서(인덱스)
    let subPathType: SubPathType // 세부경로 타입 (도보-버스-지하철)
    let distance: Int // 이동거리
    let time: Int // 소요시간
//    let subPathStartTime: Date // 세부경로 시작시간 // TODO: - 배차시간표 활용해서 계산하기
    
    // 지하철🚇 | 버스🚌  일 경우에만
    let stationCount: Int? // 거치는 정거장(역)의 수
    let lane: [LaneInfo]? // 교통수단 정보 (버스일 경우 여러개)
    let startName: String? // 승차 정류장
    let endName: String? // 하차 정류장
    let stations: [PassStation]? // 거치는 정거장(역)들
    
    // 지하철🚇일 경우에만
    var way: String? // ~행 정보 ex) "신내행"
    let wayCode: Int? // 상행/하행 정보 코드 (1:상행, 2:하행)
    var nextSt: String? // 방면(다음역) 정보 ex) "구산 방면"
    
    // 버스🚌일 경우에만
    let startArsID: String? // 출발 정류장 고유번호(arsID)
    
    init(
        idx: Int,
        subPathType: SubPathType,
        distance: Int,
        time: Int,
//        subPathStartTime: Date,
        stationCount: Int? = nil,
        lane: [LaneInfo]? = nil,
        startName: String? = nil,
        endName: String? = nil,
        stations: [PassStation]? = nil,
        way: String? = nil,
        wayCode: Int? = nil,
        nextSt: String? = nil,
        startArsID: String? = nil
    ) {
        self.idx = idx
        self.subPathType = subPathType
        self.distance = distance
        self.time = time
//        self.subPathStartTime = subPathStartTime
        self.stationCount = stationCount
        self.lane = lane
        self.startName = startName
        self.endName = endName
        self.stations = stations
        self.way = way
        self.wayCode = wayCode
        self.nextSt = nextSt
        self.startArsID = startArsID
    }
}

enum SubPathType: String {
    case walk = "도보"
    case bus = "버스"
    case subway = "지하철"
    
    var iconName: String {
        switch self {
        case .walk:
            "figure.walk"
        case .bus:
            "bus.fill"
        case .subway:
            "tram.fill"
        }
    }
}

// 세부경로의 교통수단 정보
struct LaneInfo: Equatable {
    let name: String // 지하철 노선명 or 버스 번호
    
    let subwayCode: SubwayCode? // 지하철 노선 번호
    
    let busRouteID: String? // 버스 노선 ID
    let busRouteType: BusRouteType? // 버스 노선 타입
    // 필요시 지하철 노선 번호, 버스 코드 등 추가 가능
    init(
        name: String,
        subwayCode: SubwayCode? = nil,
        busRouteID: String? = nil,
        busRouteType: BusRouteType? = nil
    ) {
        self.name = name
        self.subwayCode = subwayCode
        self.busRouteID = busRouteID
        self.busRouteType = busRouteType
    }
}

// 세부경로에서 거치는 정거장(역) 정보 (Station 이름이 DTO 모델과 겹쳐서 PassStation으로 함)
struct PassStation: Equatable {
    let index: Int // 순서
    let name: String // 이름
}

#if DEBUG
// MARK: - Mock
extension MakchaInfo {
    static let mockMakchaInfo = MakchaInfo(
        startTime: Date(),
        makchaPaths: [
            MakchaPath(
                fastest: true,
                makchaPathType: .subway,
                arrivalTime: Date().timeAfterMinute(after: 62),
                totalTime: 62,
                subPath: [
                    MakchaSubPath(
                        idx: 0,
                        subPathType: .walk,
                        distance: 498,
                        time: 7
                    ),
                    MakchaSubPath(
                        idx: 1,
                        subPathType: .subway,
                        distance: 8400,
                        time: 15,
                        stationCount: 7,
                        lane: [
                            LaneInfo(name: "수도권 3호선", subwayCode: .수도권3호선)
                        ],
                        startName: "불광",
                        endName: "종로3가",
                        stations: [
                            PassStation(index: 0,name: "불광"),
                            PassStation(index: 1,name: "녹번"),
                            PassStation(index: 2,name: "홍제"),
                            PassStation(index: 3,name: "무악재"),
                            PassStation(index: 4,name: "독립문"),
                            PassStation(index: 5,name: "경복궁"),
                            PassStation(index: 6,name: "안국"),
                            PassStation(index: 7,name: "종로3가")
                        ],
                        way: "종로3가",
                        wayCode: 2
                    ),
                    MakchaSubPath(
                        idx: 2,
                        subPathType: .walk,
                        distance: 0,
                        time: 0
                    ),
                    MakchaSubPath(
                        idx: 3,
                        subPathType: .subway,
                        distance: 19500,
                        time: 37,
                        stationCount: 18,
                        lane: [
                            LaneInfo(name: "수도권 5호선", subwayCode: .수도권5호선)
                        ],
                        startName: "종로3가",
                        endName: "오금",
                        stations: [
                            PassStation(index: 0, name: "종로3가"),
                            PassStation(index: 1, name: "을지로4가"),
                            PassStation(index: 2, name: "동대문역사문화공원"),
                            PassStation(index: 3, name: "청구"),
                            PassStation(index: 4, name: "신금호"),
                            PassStation(index: 5, name: "행당"),
                            PassStation(index: 6, name: "왕십리"),
                            PassStation(index: 7, name: "마장"),
                            PassStation(index: 8, name: "답십리"),
                            PassStation(index: 9, name: "장한평"),
                            PassStation(index: 10, name: "군자"),
                            PassStation(index: 11, name: "아차산"),
                            PassStation(index: 12, name: "광나루"),
                            PassStation(index: 13, name: "천호"),
                            PassStation(index: 14, name: "강동"),
                            PassStation(index: 15, name: "둔촌동"),
                            PassStation(index: 16, name: "올림픽공원"),
                            PassStation(index: 17, name: "방이"),
                            PassStation(index: 18, name: "오금")
                        ],
                        way: "오금",
                        wayCode: 2
                    ),
                    MakchaSubPath(
                        idx: 4,
                        subPathType: .walk,
                        distance: 221,
                        time: 3
                    )
                ]
            ),
            MakchaPath(
                fastest: false,
                makchaPathType: .both,
                arrivalTime: Date().timeAfterMinute(after: 71),
                totalTime: 71,
                subPath: [
                    MakchaSubPath(
                        idx: 0,
                        subPathType: .walk,
                        distance: 191,
                        time: 3
                    ),
                    MakchaSubPath(
                        idx: 1,
                        subPathType: .bus,
                        distance: 6461,
                        time: 23,
                        stationCount: 12,
                        lane: [
                            LaneInfo(
                                name: "720",
                                busRouteID: "100100111",
                                busRouteType: .간선
                            ),
                            LaneInfo(
                                name: "741",
                                busRouteID: "123000010",
                                busRouteType: .간선
                            ),
                            LaneInfo(
                                name: "705",
                                busRouteID: "100100587",
                                busRouteType: .간선
                            )
                        ],
                        startName: "불광역3.6호선",
                        endName: "서대문역사거리.농협중앙회",
                        stations: [
                            PassStation(index: 0, name: "불광역3.6호선"),
                            PassStation(index: 1, name: "불광역3호선.서울혁신파크"),
                            PassStation(index: 2, name: "한전성서지사.북한산푸르지오"),
                            PassStation(index: 3, name: "녹번역"),
                            PassStation(index: 4, name: "산골고개"),
                            PassStation(index: 5, name: "홍제역.서대문세무서"),
                            PassStation(index: 6, name: "홍제삼거리.인왕산한신휴플러스"),
                            PassStation(index: 7, name: "무악재역"),
                            PassStation(index: 8, name: "안산초등학교"),
                            PassStation(index: 9, name: "독립문역.한성과학고"),
                            PassStation(index: 10, name: "영천시장"),
                            PassStation(index: 11, name: "금화초등학교.서울시교육청"),
                            PassStation(index: 12, name: "서대문역사거리.농협중앙회")
                        ],
                        startArsID: "12-022"
                    ),
                    MakchaSubPath(
                        idx: 2,
                        subPathType: .walk,
                        distance: 155,
                        time: 2
                    ),
                    MakchaSubPath(
                        idx: 3,
                        subPathType: .subway,
                        distance: 21800,
                        time: 40,
                        stationCount: 20,
                        lane: [
                            LaneInfo(name: "수도권 5호선", subwayCode: .수도권5호선)
                        ],
                        startName: "서대문",
                        endName: "오금",
                        stations: [
                            PassStation(index: 0, name: "서대문"),
                            PassStation(index: 1, name: "광화문"),
                            PassStation(index: 2, name: "종로3가"),
                            PassStation(index: 3, name: "을지로4가"),
                            PassStation(index: 4, name: "동대문역사문화공원"),
                            PassStation(index: 5, name: "청구"),
                            PassStation(index: 6, name: "신금호"),
                            PassStation(index: 7, name: "행당"),
                            PassStation(index: 8, name: "왕십리"),
                            PassStation(index: 9, name: "마장"),
                            PassStation(index: 10, name: "답십리"),
                            PassStation(index: 11, name: "장한평"),
                            PassStation(index: 12, name: "군자"),
                            PassStation(index: 13, name: "아차산"),
                            PassStation(index: 14, name: "광나루"),
                            PassStation(index: 15, name: "천호"),
                            PassStation(index: 16, name: "강동"),
                            PassStation(index: 17, name: "둔촌동"),
                            PassStation(index: 18, name: "올림픽공원"),
                            PassStation(index: 19, name: "방이"),
                            PassStation(index: 20, name: "오금")
                        ],
                        way: "오금",
                        wayCode: 2
                    ),
                    MakchaSubPath(
                        idx: 4,
                        subPathType: .walk,
                        distance: 221,
                        time: 3
                    )
                ]
            )
        ]
    )
}
#endif
