//
//  SeoulRealtimeSubwayDTO.swift
//  Makcha
//
//  Created by 김영빈 on 5/13/24.
//

// MARK: - 서울시 실시간 지하철 도착 정보 API의 응답 결과 DTO
/// https://data.seoul.go.kr/dataList/OA-12764/F/1/datasetView.do

struct SeoulRealtimeSubwayDTO: Codable {
    let errorMessage: SeoulRealtimeSubwayErrorMessage
    let realtimeArrivalList: [SeoulRealtimeSubwayArrival]
}

struct SeoulRealtimeSubwayErrorMessage: Codable {
    let status: Int // 상태 코드
    let code, message, link, developerMessage: String
    let total: Int // 결과 개수
}

struct SeoulRealtimeSubwayArrival: Codable {
    let totalCount: Int // 응답 결과 배열 크기
    let rowNum: Int // 배열 순서 (1번부터 시작)
    let selectedCount: Int // 파라미터로 넘겼던 최대 결과 개수 값
    let subwayId: String // 지하철호선ID
    let updnLine: String // 상하행선구분 (상행/하행)
    let trainLineNm: String // 도착지방면 - (성수행(목적지역) - 구로디지털단지방면(다음역))
    let statnFid: String // 이전지하철역ID
    let statnTid: String // 다음지하철역ID
    let statnId: String // 지하철역ID
    let statnNm: String // 지하철역명
    let trnsitCo: String // 환승노선수
    let ordkey: String // 도착예정열차순번 - (상하행코드(1자리), 순번(첫번째, 두번째 열차 , 1자리), 첫번째 도착예정 정류장 - 현재 정류장(3자리), 목적지 정류장, 급행여부(1자리))
    let subwayList: String // 연계호선 ID ex) "1003,1006"
    let statnList: String // 연계지하철역 ID ex) "1003000321,1006000614"
    let btrainSttus: String // 열차종류 (급행, ITX, 일반, 특급)
    let barvlDt: String // 열차도착예정시간 (단위: 초)
    let btrainNo: String // 열차번호 (현재운행하고 있는 호선별 열차번호)
    let bstatnId: String // 종착지하철역ID
    let bstatnNm: String // 종착지하철역명
    let recptnDt: String // 열차도착정보를 생성한 시각
    let arvlMsg2: String // 첫번째도착메세지 - (도착, 출발, 진입 등) ex) "연신내 진입"
    let arvlMsg3: String // 두번째도착메세지 - (종합운동장 도착, 12분 후 (광명사거리) 등) ex) "연신내"
    let arvlCd: String // 도착 코드 - (0:진입, 1:도착, 2:출발, 3:전역출발, 4:전역진입, 5:전역도착, 99:운행중)
}
