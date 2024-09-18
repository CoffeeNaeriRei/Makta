//
//  TransPathDTO.swift
//  Makcha
//
//  Created by 김영빈 on 5/5/24.
//

// MARK: - ODSay 대중교통 환승경로 API의 응답 결과 DTO
/// https://lab.odsay.com/guide/guide#guideWeb_2

struct TransPathDTO: TransPathDTOResponsable, Codable {
    var type: ResponseType? = .success
    
    let result: TransPathResult
}

struct TransPathResult: Codable {
    let searchType: Int // 결과 구분 (0-도시내 | 1-도시간 직통 | 2-도시간 환승)
    let outTrafficCheck: Int // 도시간 직통 탐색 결과 유무(환승X) (0-False, 1-True)
    let busCount: Int // 버스 결과 개수
    let subwayCount: Int // 지하철 결과 개수
    let subwayBusCount: Int // 버스+지하철 결과 개수
    let pointDistance: Int // 출발지(SX, SY)와 도착지(EX, EY)의 직선 거리 (미터)
    let startRadius: Int // 출발지 반경
    let endRadius: Int // 도착지 반경
    let path: [Path] // 결과 경로 리스트
}

// 응답 결과에 들어 있는 각각의 경로
struct Path: Codable {
    let pathType: Int // // 결과 종류 (1-지하철, 2-버스, 3-버스+지하철)
    let info: Info // 해당 경로의 요약 정보
    let subPath: [SubPath] // 이용 교통 수단 별 세부경로
}

// 경로의 요약 정보
struct Info: Codable {
    let trafficDistance: Double // 도보를 제외한 총 이동 거리
    let totalWalk: Int // 총 도보 이동 거리
    let totalTime: Int // 총 소요시간
    let payment: Int // 총 요금
    let busTransitCount: Int // 버스 환승 카운트
    let subwayTransitCount: Int // 지하철 환승 카운트
    let mapObj: String // 보간점 API를 호출하기 위한 파라미터 값
    let firstStartStation: String // 최초 출발역/정류장
    let lastEndStation: String // 최종 도착역/정류장
    let totalStationCount: Int // 총 정류장 합
    let busStationCount: Int // 버스 정류장 합
    let subwayStationCount: Int // 지하철 정류장 합
    let totalDistance: Double // 총 거리
//    let totalWalkTime: Int
    let checkIntervalTime: Int // 배차간격 체크 기준 시간(분)
    let checkIntervalTimeOverYn: String // 배차간격 체크 기준시간을 초과하는 노선이 존재하는지 여부(Y/N)
    let totalIntervalTime: Int // 전체 배차간격 시간(분)
}

// 이용 교통 수단 별 세부경로
struct SubPath: Codable {
    // 도보🚶‍♂️ | 지하철🚇 | 버스🚌  공통
    let trafficType: Int // 이동 수단 종류 (1-지하철 | 2-버스 | 3-도보)
    let distance: Int // 이동 거리
    let sectionTime: Int // 이동 소요시간
    
    // 지하철🚇 | 버스🚌  공통
    let stationCount: Int? // 이동하여 정차하는 정거장 수(지하철, 버스 경우만 필수)
    let lane: [Lane]? // 교통 수단 정보 리스트
    let intervalTime: Int? // 평균 배차간격(분)
    let startName: String? // 승차 정류장/역명
    let startX: Double? // 승차 정류장/역 X 좌표
    let startY: Double? // 승차 정류장/역 Y 좌표
    let endName: String? // 하차 정류장/역명
    let endX: Double? // 하차 정류장/역 X 좌표
    let endY: Double? // 하차 정류장/역 Y 좌표
    let startID: Int? // 출발 정류장/역 코드
    let endID: Int? // 도착 정류장/역 코드
//    let startExitNo: String? // 지하철 들어가는 출구 번호 (지하철인 경우에만 사용되지만 해당 태그가 없을 수도 있다.)
//    let startExitX: Double? // 지하철 들어가는 출구 X좌표(지하철인 경우에 만 사용되지만 해당 태그가 없을 수도 있다.)
//    let startExitY: Double? // 지하철 들어가는 출구 Y좌표(지하철인 경우에 만 사용되지만 해당 태그가 없을 수도 있다.)
//    let endExitNo: String?
//    let endExitX: Double?
//    let endExitY: Double?
    let passStopList: PassStopList? // 지나는 역(정거장)
    
    // 지하철🚇 만 해당
    let way: String? // 방면 정보 (지하철인 경우에만 필수)
    let wayCode: Int? // 방면 정보 코드(지하철의 첫번째 경로에만 필수)
    let door: String? // 지하철 빠른 환승 위치 (지하철인 경우에만 필수)
    
    // 버스🚌  만 해당
    let startStationCityCode: Int? // 출발 정류장 도시코드 (버스인 경우에만 필수)
    let startStationProviderCode: Int? // 출발 정류장 BIS 코드 (BIS 제공지역인 경우에만 필수)
    let startLocalStationID: String? // 각 지역 출발 정류장 ID (BIS 제공지역인 경우에만 필수)
    let startArsID: String? // 각 지역 출발 정류장 고유번호 (BIS 제공지역인 경우에만 필수)
    let endStationCityCode: Int? // 도착 정류장 도시코드 (버스인 경우에만 필수)
    let endStationProviderCode: Int? // 도착 정류장 BIS 코드 (BIS 제공지역인 경우에만 필수)
    let endLocalStationID: String? // 각 지역 도착 정류장 ID (BIS 제공지역인 경우에만 필수)
    let endArsID: String? // 각 지역 도착 정류장 고유번호 (BIS 제공지역인 경우에만 필수)
    
    init(
        trafficType: Int,
        distance: Int,
        sectionTime: Int,
        stationCount: Int? = nil,
        lane: [Lane]? = nil,
        intervalTime: Int? = nil,
        startName: String? = nil,
        startX: Double? = nil,
        startY: Double? = nil,
        endName: String? = nil,
        endX: Double? = nil,
        endY: Double? = nil,
        startID: Int? = nil,
        endID: Int? = nil,
        passStopList: PassStopList? = nil,
        way: String? = nil,
        wayCode: Int? = nil,
        door: String? = nil,
        startStationCityCode: Int? = nil,
        startStationProviderCode: Int? = nil,
        startLocalStationID: String? = nil,
        startArsID: String? = nil,
        endStationCityCode: Int? = nil,
        endStationProviderCode: Int? = nil,
        endLocalStationID: String? = nil,
        endArsID: String? = nil
    ) {
        self.trafficType = trafficType
        self.distance = distance
        self.sectionTime = sectionTime
        self.stationCount = stationCount
        self.lane = lane
        self.intervalTime = intervalTime
        self.startName = startName
        self.startX = startX
        self.startY = startY
        self.endName = endName
        self.endX = endX
        self.endY = endY
        self.startID = startID
        self.endID = endID
        self.passStopList = passStopList
        self.way = way
        self.wayCode = wayCode
        self.door = door
        self.startStationCityCode = startStationCityCode
        self.startStationProviderCode = startStationProviderCode
        self.startLocalStationID = startLocalStationID
        self.startArsID = startArsID
        self.endStationCityCode = endStationCityCode
        self.endStationProviderCode = endStationProviderCode
        self.endLocalStationID = endLocalStationID
        self.endArsID = endArsID
    }
}

// 교통 수단 정보
struct Lane: Codable {
    // 지하철🚇 만 해당
    let name: String? // 지하철 노선명 (지하철인 경우에만 필수)
    let subwayCode: Int? // 지하철 노선 번호 (지하철인 경우에만 필수)
    let subwayCityCode: Int? // 지하철 도시코드 (지하철인 경우에만 필수)
    
    // 버스🚌  만 해당
    let busNo: String? // 버스 노선 번호 (버스인 경우에만 필수)
    let type: Int? // 버스 타입 (버스인 경우에만 필수)
    let busID: Int? // 버스 코드 (버스인 경우에만 필수)
    let busLocalBlID: String? // 각 지역 버스노선 ID (BIS 제공지역인 경우에만 필수)
    let busCityCode: Int? // 운수회사 승인 도시코드 (버스인 경우에만 필수)
    let busProviderCode: Int? // BIS 코드 (BIS 제공지역인 경우에만 필수)
    
    init(
        name: String? = nil,
        subwayCode: Int? = nil,
        subwayCityCode: Int? = nil,
        busNo: String? = nil,
        type: Int? = nil,
        busID: Int? = nil,
        busLocalBlID: String? = nil,
        busCityCode: Int? = nil,
        busProviderCode: Int? = nil
    ) {
        self.name = name
        self.subwayCode = subwayCode
        self.subwayCityCode = subwayCityCode
        self.busNo = busNo
        self.type = type
        self.busID = busID
        self.busLocalBlID = busLocalBlID
        self.busCityCode = busCityCode
        self.busProviderCode = busProviderCode
    }
}

// 정거장 정보
struct PassStopList: Codable {
    let stations: [Station]
}

struct Station: Codable {
    // 지하철🚇 | 버스🚌  공통
    let index: Int // 정류장 순서 (0부터 시작)
    let stationID: Int // 정류장 ID
    let stationName: String // 정류장 이름
    let x: String // 정류장 X좌표
    let y: String // 정류장 Y좌표
    
    // 버스🚌  만 해당
    let stationCityCode: Int? // 정류장 도시코드 (버스인 경우에만 필수)
    let stationProviderCode: Int? // BIS 코드 (BIS 제공지역인 경우에만 필수)
    let localStationID: String? // 각 지역 정류장 ID (BIS 제공지역인 경우에만 필수)
    let arsID: String? // 각 지역 정류장 고유번호 (BIS 제공지역인 경우에만 필수)
    let isNonStop: String? // 미정차 정류장 여부 Y/N(버스인 경우에만 필수)
    
    init(
        index: Int,
        stationID: Int,
        stationName: String,
        x: String,
        y: String,
        stationCityCode: Int? = nil,
        stationProviderCode: Int? = nil,
        localStationID: String? = nil,
        arsID: String? = nil,
        isNonStop: String? = nil
    ) {
        self.index = index
        self.stationID = stationID
        self.stationName = stationName
        self.x = x
        self.y = y
        self.stationCityCode = stationCityCode
        self.stationProviderCode = stationProviderCode
        self.localStationID = localStationID
        self.arsID = arsID
        self.isNonStop = isNonStop
    }
}

#if DEBUG
// MARK: - Mock
extension TransPathDTO {
    static let mockDTO: Self = TransPathDTO(
        result: TransPathResult(
            searchType: 0,
            outTrafficCheck: 0,
            busCount: 10,
            subwayCount: 2,
            subwayBusCount: 5,
            pointDistance: 21703,
            startRadius: 700,
            endRadius: 700,
            path: [
                Path(
                    pathType: 1,
                    info: Info(
                        trafficDistance: 27900.0,
                        totalWalk: 719,
                        totalTime: 62,
                        payment: 1800,
                        busTransitCount: 0,
                        subwayTransitCount: 2,
                        mapObj: "3:2:322:329@17:2:534:572",
                        firstStartStation: "불광",
                        lastEndStation: "오금",
                        totalStationCount: 25,
                        busStationCount: 0,
                        subwayStationCount: 25,
                        totalDistance: 28619.0,
                        checkIntervalTime: 100,
                        checkIntervalTimeOverYn: "N",
                        totalIntervalTime: 16
                    ),
                    subPath: [
                        SubPath(
                            trafficType: 3,
                            distance: 498,
                            sectionTime: 7
                        ),
                        SubPath(
                            trafficType: 1,
                            distance: 8400,
                            sectionTime: 15,
                            stationCount: 7,
                            lane: [
                                Lane(
                                    name: "수도권 3호선",
                                    subwayCode: 3,
                                    subwayCityCode: 1000
                                )
                            ],
                            intervalTime: 6,
                            startName: "불광",
                            startX: 126.93023,
                            startY: 37.610072,
                            endName: "종로3가",
                            endX: 126.991841,
                            endY: 37.571653,
                            startID: 322,
                            endID: 329,
                            passStopList: PassStopList(
                                stations: [
                                    Station(
                                        index: 0,
                                        stationID: 322,
                                        stationName: "불광",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 1,
                                        stationID: 323,
                                        stationName: "녹번",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 2,
                                        stationID: 324,
                                        stationName: "홍제",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 3,
                                        stationID: 325,
                                        stationName: "무악재",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 4,
                                        stationID: 326,
                                        stationName: "독립문",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 5,
                                        stationID: 327,
                                        stationName: "경복궁",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 6,
                                        stationID: 328,
                                        stationName: "안국",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 7,
                                        stationID: 329,
                                        stationName: "종로3가",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                ]
                            ),
                            way: "종로3가",
                            wayCode: 2,
                            door: "7-2"
                        ),
                        SubPath(
                            trafficType: 3,
                            distance: 0,
                            sectionTime: 0
                        ),
                        SubPath(
                            trafficType: 1,
                            distance: 19500,
                            sectionTime: 37,
                            stationCount: 18,
                            lane: [
                                Lane(
                                    name: "수도권 5호선",
                                    subwayCode: 5,
                                    subwayCityCode: 1000
                                )
                            ],
                            intervalTime: 10,
                            startName: "종로3가",
                            startX: 126.990311,
                            startY: 37.572577,
                            endName: "오금",
                            endX: 127.12761,
                            endY: 37.502333,
                            startID: 534,
                            endID: 572,
                            passStopList: PassStopList(
                                stations: [
                                    Station(
                                        index: 0,
                                        stationID: 534,
                                        stationName: "종로3가",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 1,
                                        stationID: 535,
                                        stationName: "을지로4가",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 2,
                                        stationID: 536,
                                        stationName: "동대문역사문화공원",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 3,
                                        stationID: 537,
                                        stationName: "청구",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 4,
                                        stationID: 538,
                                        stationName: "신금호",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 5,
                                        stationID: 539,
                                        stationName: "행당",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 6,
                                        stationID: 540,
                                        stationName: "왕십리",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 7,
                                        stationID: 541,
                                        stationName: "마장",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 8,
                                        stationID: 542,
                                        stationName: "답십리",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 9,
                                        stationID: 543,
                                        stationName: "장한평",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 10,
                                        stationID: 544,
                                        stationName: "군자",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 11,
                                        stationID: 545,
                                        stationName: "아차산",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 12,
                                        stationID: 546,
                                        stationName: "광나루",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 13,
                                        stationID: 547,
                                        stationName: "천호",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 14,
                                        stationID: 548,
                                        stationName: "강동",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 15,
                                        stationID: 569,
                                        stationName: "둔촌동",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 16,
                                        stationID: 570,
                                        stationName: "올림픽공원",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 17,
                                        stationID: 571,
                                        stationName: "방이",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                    Station(
                                        index: 18,
                                        stationID: 572,
                                        stationName: "오금",
                                        x: "126.930237",
                                        y: "37.610076"
                                    ),
                                ]
                            ),
                            way: "오금",
                            wayCode: 2,
                            door: "null"
                        ),
                        SubPath(
                            trafficType: 3,
                            distance: 221,
                            sectionTime: 3
                        )
                    ]
                ),
                Path(
                    pathType: 3,
                    info: Info(
                        trafficDistance: 28251.0,
                        totalWalk: 567,
                        totalTime: 71,
                        payment: 1900,
                        busTransitCount: 1,
                        subwayTransitCount: 1,
                        mapObj: "1270:1:17:29@17:2:532:572",
                        firstStartStation: "불광역3.6호선",
                        lastEndStation: "오금",
                        totalStationCount: 32,
                        busStationCount: 12,
                        subwayStationCount: 20,
                        totalDistance: 28818.0,
                        checkIntervalTime: 100,
                        checkIntervalTimeOverYn: "N",
                        totalIntervalTime: 19
                    ),
                    subPath: [
                        SubPath(
                            trafficType: 3,
                            distance: 191,
                            sectionTime: 3
                        ),
                        SubPath(
                            trafficType: 2,
                            distance: 6451,
                            sectionTime: 23,
                            stationCount: 12,
                            lane: [
                                Lane(
                                    busNo: "720",
                                    type: 11,
                                    busID: 1270,
                                    busLocalBlID: "100100111",
                                    busCityCode: 1000,
                                    busProviderCode: 4
                                ),
                                Lane(
                                    busNo: "741",
                                    type: 11,
                                    busID: 1072,
                                    busLocalBlID: "123000010",
                                    busCityCode: 1000,
                                    busProviderCode: 4
                                ),
                                Lane(
                                    busNo: "705",
                                    type: 11,
                                    busID: 1374,
                                    busLocalBlID: "100100587",
                                    busCityCode: 1000,
                                    busProviderCode: 4
                                )
                            ],
                            intervalTime: 9,
                            startName: "불광역3.6호선",
                            startX: 126.928214,
                            startY: 37.612397,
                            endName: "서대문역사거리.농협중앙회",
                            endX: 126.967919,
                            endY: 37.566815,
                            startID: 195026,
                            passStopList: PassStopList(
                                stations: [
                                    Station(
                                        index: 0,
                                        stationID: 195026,
                                        stationName: "불광역3.6호선",
                                        x: "126.928214",
                                        y: "37.612397",
                                        stationCityCode: 1000,
                                        stationProviderCode: 4,
                                        localStationID: "111000931",
                                        arsID: "12-022",
                                        isNonStop: "N"
                                    ),
                                    Station(
                                        index: 1,
                                        stationID: 195027,
                                        stationName: "불광역3호선.서울혁신파크",
                                        x: "126.931081",
                                        y: "37.60917",
                                        stationCityCode: 1000,
                                        stationProviderCode: 4,
                                        localStationID: "111000933",
                                        arsID: "12-024",
                                        isNonStop: "N"
                                    ),
                                    Station(
                                        index: 2,
                                        stationID: 195029,
                                        stationName: "한전성서지사.북한산푸르지오",
                                        x: "126.933865",
                                        y: "37.606113",
                                        stationCityCode: 1000,
                                        stationProviderCode: 4,
                                        localStationID: "111000935",
                                        arsID: "12-026",
                                        isNonStop: "N"
                                    ),
                                    Station(
                                        index: 3,
                                        stationID: 195032,
                                        stationName: "녹번역",
                                        x: "126.935059",
                                        y: "37.602619",
                                        stationCityCode: 1000,
                                        stationProviderCode: 4,
                                        localStationID: "111000937",
                                        arsID: "12-028",
                                        isNonStop: "N"
                                    ),
                                    Station(
                                        index: 4,
                                        stationID: 80501,
                                        stationName: "산골고개",
                                        x: "126.935059",
                                        y: "37.602619",
                                        stationCityCode: 1000,
                                        stationProviderCode: 4,
                                        localStationID:"112000405",
                                        arsID: "12-028",
                                        isNonStop: "N"
                                    ),
                                    Station(
                                        index: 5,
                                        stationID: 80504,
                                        stationName: "홍제역.서대문세무서",
                                        x: "126.935059",
                                        y: "37.602619",
                                        stationCityCode: 1000,
                                        stationProviderCode: 4,
                                        localStationID:"112000407",
                                        arsID: "12-028",
                                        isNonStop: "N"
                                    ),
                                    Station(
                                        index: 6,
                                        stationID: 103999,
                                        stationName: "홍제삼거리.인왕산한신휴플러스",
                                        x: "126.935059",
                                        y: "37.602619",
                                        stationCityCode: 1000,
                                        stationProviderCode: 4,
                                        localStationID:"112000416",
                                        arsID: "12-028",
                                        isNonStop: "N"
                                    ),
                                    Station(
                                        index: 7,
                                        stationID: 80532,
                                        stationName: "무악재역",
                                        x: "126.935059",
                                        y: "37.602619",
                                        stationCityCode: 1000,
                                        stationProviderCode: 4,
                                        localStationID:"112000398",
                                        arsID: "12-028",
                                        isNonStop: "N"
                                    ),
                                    Station(
                                        index: 8,
                                        stationID: 80534,
                                        stationName: "안산초등학교",
                                        x: "126.935059",
                                        y: "37.602619",
                                        stationCityCode: 1000,
                                        stationProviderCode: 4,
                                        localStationID:"112000404",
                                        arsID: "12-028",
                                        isNonStop: "N"
                                    ),
                                    Station(
                                        index: 9,
                                        stationID: 80588,
                                        stationName: "독립문역.한성과학고",
                                        x: "126.935059",
                                        y: "37.602619",
                                        stationCityCode: 1000,
                                        stationProviderCode: 4,
                                        localStationID:"112000402",
                                        arsID: "12-028",
                                        isNonStop: "N"
                                    ),
                                    Station(
                                        index: 10,
                                        stationID: 80589,
                                        stationName: "영천시장",
                                        x: "126.935059",
                                        y: "37.602619",
                                        stationCityCode: 1000,
                                        stationProviderCode: 4,
                                        localStationID:"100000363",
                                        arsID: "12-028",
                                        isNonStop: "N"
                                    ),
                                    Station(
                                        index: 11,
                                        stationID: 104457,
                                        stationName: "금화초등학교.서울시교육청",
                                        x: "126.935059",
                                        y: "37.602619",
                                        stationCityCode: 1000,
                                        stationProviderCode: 4,
                                        localStationID:"112000051",
                                        arsID: "12-028",
                                        isNonStop: "N"
                                    ),
                                    Station(
                                        index: 12,
                                        stationID: 80595,
                                        stationName: "서대문역사거리.농협중앙회",
                                        x: "126.935059",
                                        y: "37.602619",
                                        stationCityCode: 1000,
                                        stationProviderCode: 4,
                                        localStationID:"101000262",
                                        arsID: "12-028",
                                        isNonStop: "N"
                                    )
                                ]
                            ),
                            startStationCityCode: 1000,
                            startStationProviderCode: 4,
                            startLocalStationID: "111000931",
                            startArsID: "12-022",
                            endStationCityCode: 1000,
                            endStationProviderCode: 4,
                            endLocalStationID: "101000262",
                            endArsID: "02-281"
                        ),
                        SubPath(
                            trafficType: 3,
                            distance: 155,
                            sectionTime: 2
                        ),
                        SubPath(
                            trafficType: 1,
                            distance: 21800,
                            sectionTime: 40,
                            stationCount: 20,
                            lane: [
                                Lane(
                                    name: "수도권 5호선",
                                    subwayCode: 5,
                                    subwayCityCode: 1000
                                )
                            ],
                            intervalTime: 10,
                            startName: "서대문",
                            startX: 126.966642,
                            startY: 37.565858,
                            endName: "오금",
                            endX: 127.12761,
                            endY: 37.502333,
                            startID: 532,
                            endID: 572,
                            passStopList: PassStopList(
                                stations: [
                                    Station(
                                        index: 0,
                                        stationID: 532,
                                        stationName: "서대문",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 1,
                                        stationID: 533,
                                        stationName: "광화문",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 2,
                                        stationID: 534,
                                        stationName: "종로3가",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 3,
                                        stationID: 535,
                                        stationName: "을지로4가",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 4,
                                        stationID: 536,
                                        stationName: "동대문역사문화공원",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 5,
                                        stationID: 537,
                                        stationName: "청구",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 6,
                                        stationID: 538,
                                        stationName: "신금호",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 7,
                                        stationID: 539,
                                        stationName: "행당",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 8,
                                        stationID: 540,
                                        stationName: "왕십리",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 9,
                                        stationID: 541,
                                        stationName: "마장",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 10,
                                        stationID: 542,
                                        stationName: "답십리",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 11,
                                        stationID: 543,
                                        stationName: "장한평",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 12,
                                        stationID: 544,
                                        stationName: "군자",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 13,
                                        stationID: 545,
                                        stationName: "아차산",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 14,
                                        stationID: 546,
                                        stationName: "광나루",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 15,
                                        stationID: 547,
                                        stationName: "천호",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 16,
                                        stationID: 548,
                                        stationName: "강동",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 17,
                                        stationID: 569,
                                        stationName: "둔촌동",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 18,
                                        stationID: 570,
                                        stationName: "올림픽공원",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 19,
                                        stationID: 571,
                                        stationName: "방이",
                                        x: "126.966642",
                                        y: "37.565863"
                                    ),
                                    Station(
                                        index: 20,
                                        stationID: 572,
                                        stationName: "오금",
                                        x: "126.966642",
                                        y: "37.565863"
                                    )
                                ]
                            ),
                            way: "오금",
                            wayCode: 2,
                            door: "null"
                        ),
                        SubPath(
                            trafficType: 3,
                            distance: 221,
                            sectionTime: 3
                        )
                    ]
                )
            ]
        )
    )
}
#endif
