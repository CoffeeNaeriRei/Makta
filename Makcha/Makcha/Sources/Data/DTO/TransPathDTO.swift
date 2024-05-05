//
//  TransPathDTO.swift
//  Makcha
//
//  Created by 김영빈 on 5/5/24.
//

// MARK: - ODSay 대중교통 환승경로 API의 응답 결과 DTO
/// https://lab.odsay.com/guide/guide#guideWeb_2

struct TransPathDTO: Codable {
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
    let stationCount: Int // 이동하여 정차하는 정거장 수(지하철, 버스 경우만 필수)
    let lane: [Lane] // 교통 수단 정보 리스트
    let intervalTime: Int // 평균 배차간격(분)
    let startName: String // 승차 정류장/역명
    let startX: Double // 승차 정류장/역 X 좌표
    let startY: Double // 승차 정류장/역 Y 좌표
    let endName: String // 하차 정류장/역명
    let endX: Double // 하차 정류장/역 X 좌표
    let endY: Double // 하차 정류장/역 Y 좌표
    let startID: Int // 출발 정류장/역 코드
    let endID: Int // 도착 정류장/역 코드
//    let startExitNo: String // 지하철 들어가는 출구 번호 (지하철인 경우에만 사용되지만 해당 태그가 없을 수도 있다.)
//    let startExitX: Double // 지하철 들어가는 출구 X좌표(지하철인 경우에 만 사용되지만 해당 태그가 없을 수도 있다.)
//    let startExitY: Double // 지하철 들어가는 출구 Y좌표(지하철인 경우에 만 사용되지만 해당 태그가 없을 수도 있다.)
//    let endExitNo: String
//    let endExitX: Double
//    let endExitY: Double
    let passStopList: PassStopList // 지나는 역(정거장)
    
    // 지하철🚇 만 해당
    let way: String // 방면 정보 (지하철인 경우에만 필수)
    let wayCode: Int // 방면 정보 코드(지하철의 첫번째 경로에만 필수)
    let door: String // 지하철 빠른 환승 위치 (지하철인 경우에만 필수)
    
    // 버스🚌  만 해당
    let startStationCityCode: Int // 출발 정류장 도시코드 (버스인 경우에만 필수)
    let startStationProviderCode: Int // 출발 정류장 BIS 코드 (BIS 제공지역인 경우에만 필수)
    let startLocalStationID: String // 각 지역 출발 정류장 ID (BIS 제공지역인 경우에만 필수)
    let startArsID: String // 각 지역 출발 정류장 고유번호 (BIS 제공지역인 경우에만 필수)
    let endStationCityCode: Int // 도착 정류장 도시코드 (버스인 경우에만 필수)
    let endStationProviderCode: Int // 도착 정류장 BIS 코드 (BIS 제공지역인 경우에만 필수)
    let endLocalStationID: String // 각 지역 도착 정류장 ID (BIS 제공지역인 경우에만 필수)
    let endArsID: String // 각 지역 도착 정류장 고유번호 (BIS 제공지역인 경우에만 필수)
}

// 교통 수단 정보
struct Lane: Codable {
    // 지하철🚇 만 해당
    let name: String // 지하철 노선명 (지하철인 경우에만 필수)
    let subwayCode: Int // 지하철 노선 번호 (지하철인 경우에만 필수)
    let subwayCityCode: Int // 지하철 도시코드 (지하철인 경우에만 필수)
    
    // 버스🚌  만 해당
    let busNo: String // 버스 번호 (버스인 경우에만 필수)
    let type: Int // 버스 타입 (버스인 경우에만 필수,여기 참조)
    let busID: Int // 버스 코드 (버스인 경우에만 필수)
    let busLocalBlID: String // 각 지역 버스노선 ID (BIS 제공지역인 경우에만 필수)
    let busCityCode: Int // 운수회사 승인 도시코드 (버스인 경우에만 필수)
    let busProviderCode: Int // BIS 코드 (BIS 제공지역인 경우에만 필수)
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
    let stationCityCode: Int // 정류장 도시코드 (버스인 경우에만 필수)
    let stationProviderCode: Int // BIS 코드 (BIS 제공지역인 경우에만 필수)
    let localStationID: String // 각 지역 정류장 ID (BIS 제공지역인 경우에만 필수)
    let arsID: String // 각 지역 정류장 고유번호 (BIS 제공지역인 경우에만 필수)
    let isNonStop: String // 미정차 정류장 여부 Y/N(버스인 경우에만 필수)
}
