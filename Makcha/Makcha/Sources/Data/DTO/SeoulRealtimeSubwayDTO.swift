//
//  SeoulRealtimeSubwayDTO.swift
//  Makcha
//
//  Created by 김영빈 on 5/13/24.
//

import Foundation

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
    let updnLine: String // 상하행선구분 - (0:상행|내선 1:하행|외선)
    let trainLineNm: String // 도착지방면 - (성수행(목적지역) - 구로디지털단지방면(다음역))
    let statnFid: String // 이전지하철역ID
    let statnTid: String // 다음지하철역ID
    let statnId: String // 지하철역ID
    let statnNm: String // 지하철역명
    let trnsitCo: String // 환승노선수
    let ordkey: String // 도착예정열차순번 - (상하행코드(1자리), 순번(첫번째, 두번째 열차 , 1자리), 첫번째 도착예정 정류장 - 현재 정류장(3자리), 목적지 정류장, 급행여부(1자리))
    // ex) "01000구파발0", "11003봉화산0", ""12004봉화산0""
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

#if DEBUG
extension SeoulRealtimeSubwayDTO {
    var mockData: Data {
        Data(
            """
            {
                "errorMessage": {
                    "status": 200,
                    "code": "INFO-000",
                    "message": "정상 처리되었습니다.",
                    "link": "",
                    "developerMessage": "",
                    "total": 8
                },
                "realtimeArrivalList": [
                    {
                        "beginRow": null,
                        "endRow": null,
                        "curPage": null,
                        "pageRow": null,
                        "totalCount": 8,
                        "rowNum": 1,
                        "selectedCount": 8,
                        "subwayId": "1003",
                        "subwayNm": null,
                        "updnLine": "상행",
                        "trainLineNm": "대화행 - 구파발방면",
                        "subwayHeading": null,
                        "statnFid": "1003000322",
                        "statnTid": "1003000320",
                        "statnId": "1003000321",
                        "statnNm": "연신내",
                        "trainCo": null,
                        "trnsitCo": "2",
                        "ordkey": "01000대화0",
                        "subwayList": "1003,1006",
                        "statnList": "1003000321,1006000614",
                        "btrainSttus": "일반",
                        "barvlDt": "0",
                        "btrainNo": "3250",
                        "bstatnId": "152",
                        "bstatnNm": "대화",
                        "recptnDt": "2024-05-15 17:49:30",
                        "arvlMsg2": "연신내 도착",
                        "arvlMsg3": "연신내",
                        "arvlCd": "1"
                    },
                    {
                        "beginRow": null,
                        "endRow": null,
                        "curPage": null,
                        "pageRow": null,
                        "totalCount": 8,
                        "rowNum": 2,
                        "selectedCount": 8,
                        "subwayId": "1003",
                        "subwayNm": null,
                        "updnLine": "상행",
                        "trainLineNm": "대화행 - 구파발방면",
                        "subwayHeading": null,
                        "statnFid": "1003000322",
                        "statnTid": "1003000320",
                        "statnId": "1003000321",
                        "statnNm": "연신내",
                        "trainCo": null,
                        "trnsitCo": "2",
                        "ordkey": "01001대화0",
                        "subwayList": "1003,1006",
                        "statnList": "1003000321,1006000614",
                        "btrainSttus": "일반",
                        "barvlDt": "129",
                        "btrainNo": "3250",
                        "bstatnId": "152",
                        "bstatnNm": "대화",
                        "recptnDt": "2024-05-15 17:49:27",
                        "arvlMsg2": "전역 출발",
                        "arvlMsg3": "불광",
                        "arvlCd": "3"
                    },
                    {
                        "beginRow": null,
                        "endRow": null,
                        "curPage": null,
                        "pageRow": null,
                        "totalCount": 8,
                        "rowNum": 3,
                        "selectedCount": 8,
                        "subwayId": "1003",
                        "subwayNm": null,
                        "updnLine": "상행",
                        "trainLineNm": "구파발행 - 구파발방면",
                        "subwayHeading": null,
                        "statnFid": "1003000322",
                        "statnTid": "1003000320",
                        "statnId": "1003000321",
                        "statnNm": "연신내",
                        "trainCo": null,
                        "trnsitCo": "2",
                        "ordkey": "02000구파발0",
                        "subwayList": "1003,1006",
                        "statnList": "1003000321,1006000614",
                        "btrainSttus": "일반",
                        "barvlDt": "0",
                        "btrainNo": "3248",
                        "bstatnId": "152",
                        "bstatnNm": "구파발",
                        "recptnDt": "2024-05-15 17:49:30",
                        "arvlMsg2": "연신내 도착",
                        "arvlMsg3": "연신내",
                        "arvlCd": "1"
                    },
                    {
                        "beginRow": null,
                        "endRow": null,
                        "curPage": null,
                        "pageRow": null,
                        "totalCount": 8,
                        "rowNum": 4,
                        "selectedCount": 8,
                        "subwayId": "1003",
                        "subwayNm": null,
                        "updnLine": "상행",
                        "trainLineNm": "구파발행 - 구파발방면",
                        "subwayHeading": null,
                        "statnFid": "1003000322",
                        "statnTid": "1003000320",
                        "statnId": "1003000321",
                        "statnNm": "연신내",
                        "trainCo": null,
                        "trnsitCo": "2",
                        "ordkey": "02004구파발0",
                        "subwayList": "1003,1006",
                        "statnList": "1003000321,1006000614",
                        "btrainSttus": "일반",
                        "barvlDt": "513",
                        "btrainNo": "3252",
                        "bstatnId": "152",
                        "bstatnNm": "구파발",
                        "recptnDt": "2024-05-15 17:49:27",
                        "arvlMsg2": "8분 33초 후 (무악재)",
                        "arvlMsg3": "무악재",
                        "arvlCd": "99"
                    },
                    {
                        "beginRow": null,
                        "endRow": null,
                        "curPage": null,
                        "pageRow": null,
                        "totalCount": 8,
                        "rowNum": 5,
                        "selectedCount": 8,
                        "subwayId": "1003",
                        "subwayNm": null,
                        "updnLine": "하행",
                        "trainLineNm": "오금행 - 불광방면",
                        "subwayHeading": null,
                        "statnFid": "1003000320",
                        "statnTid": "1003000322",
                        "statnId": "1003000321",
                        "statnNm": "연신내",
                        "trainCo": null,
                        "trnsitCo": "2",
                        "ordkey": "11000오금0",
                        "subwayList": "1003,1006",
                        "statnList": "1003000321,1006000614",
                        "btrainSttus": "일반",
                        "barvlDt": "0",
                        "btrainNo": "3245",
                        "bstatnId": "36",
                        "bstatnNm": "오금",
                        "recptnDt": "2024-05-15 17:49:11",
                        "arvlMsg2": "연신내 도착",
                        "arvlMsg3": "연신내",
                        "arvlCd": "1"
                    },
                    {
                        "beginRow": null,
                        "endRow": null,
                        "curPage": null,
                        "pageRow": null,
                        "totalCount": 8,
                        "rowNum": 6,
                        "selectedCount": 8,
                        "subwayId": "1006",
                        "subwayNm": null,
                        "updnLine": "하행",
                        "trainLineNm": "봉화산행 - 구산방면",
                        "subwayHeading": null,
                        "statnFid": "1006000613",
                        "statnTid": "1006000615",
                        "statnId": "1006000614",
                        "statnNm": "연신내",
                        "trainCo": null,
                        "trnsitCo": "2",
                        "ordkey": "11001봉화산0",
                        "subwayList": "1003,1006",
                        "statnList": "1003000321,1006000614",
                        "btrainSttus": "일반",
                        "barvlDt": "180",
                        "btrainNo": "6173",
                        "bstatnId": "47",
                        "bstatnNm": "봉화산",
                        "recptnDt": "2024-05-15 17:49:30",
                        "arvlMsg2": "전역 도착",
                        "arvlMsg3": "독바위",
                        "arvlCd": "5"
                    },
                    {
                        "beginRow": null,
                        "endRow": null,
                        "curPage": null,
                        "pageRow": null,
                        "totalCount": 8,
                        "rowNum": 7,
                        "selectedCount": 8,
                        "subwayId": "1003",
                        "subwayNm": null,
                        "updnLine": "하행",
                        "trainLineNm": "오금행 - 불광방면",
                        "subwayHeading": null,
                        "statnFid": "1003000320",
                        "statnTid": "1003000322",
                        "statnId": "1003000321",
                        "statnNm": "연신내",
                        "trainCo": null,
                        "trnsitCo": "2",
                        "ordkey": "12002오금0",
                        "subwayList": "1003,1006",
                        "statnList": "1003000321,1006000614",
                        "btrainSttus": "일반",
                        "barvlDt": "358",
                        "btrainNo": "3247",
                        "bstatnId": "36",
                        "bstatnNm": "오금",
                        "recptnDt": "2024-05-15 17:49:11",
                        "arvlMsg2": "5분 58초 후 (지축)",
                        "arvlMsg3": "지축",
                        "arvlCd": "99"
                    },
                    {
                        "beginRow": null,
                        "endRow": null,
                        "curPage": null,
                        "pageRow": null,
                        "totalCount": 8,
                        "rowNum": 8,
                        "selectedCount": 8,
                        "subwayId": "1006",
                        "subwayNm": null,
                        "updnLine": "하행",
                        "trainLineNm": "신내행 - 구산방면",
                        "subwayHeading": null,
                        "statnFid": "1006000613",
                        "statnTid": "1006000615",
                        "statnId": "1006000614",
                        "statnNm": "연신내",
                        "trainCo": null,
                        "trnsitCo": "2",
                        "ordkey": "12003신내0",
                        "subwayList": "1003,1006",
                        "statnList": "1003000321,1006000614",
                        "btrainSttus": "일반",
                        "barvlDt": "540",
                        "btrainNo": "6175",
                        "bstatnId": "47",
                        "bstatnNm": "신내",
                        "recptnDt": "2024-05-15 17:49:30",
                        "arvlMsg2": "9분 후 (새절(신사))",
                        "arvlMsg3": "새절(신사)",
                        "arvlCd": "99"
                    }
                ]
            }
            """.utf8
        )
    }
}
#endif
