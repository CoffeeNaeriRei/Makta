//
//  SeoulRealtimeBusStationDTO.swift
//  Makcha
//
//  Created by 김영빈 on 5/21/24.
//

import Foundation

// MARK: - 서울특별시 정류소정보조회 서비스 API의 응답 결과 DTO
/// getStationByUidItem : 정류소고유번호(arsID)를 입력받아 버스도착정보목록을 조회
/// https://www.data.go.kr/data/15000303/openapi.do

struct SeoulRealtimeBusStationDTO: Codable, Equatable {
    let comMsgHeader: ComMsgHeader
    let msgHeader: MsgHeader
    let arrivals: BusArrivals
    
    enum CodingKeys: String, CodingKey {
        case comMsgHeader
        case msgHeader
        case arrivals = "msgBody"
    }
}

struct ComMsgHeader: Codable, Equatable { }
struct MsgHeader: Codable, Equatable { }

struct BusArrivals: Codable, Equatable {
    let itemList: [BusArrival]
}

struct BusArrival: Codable, Equatable {
    let stationID: String // 정류소 고유 ID
    let stationName: String // 정류소명
    let arsID: String // 정류소 번호
    let busRouteID: String // 노선ID
    let busRouteName: String // 노선명
    let busRouteAbrv: String // 노선 약칭 → 노선명 (안내용 – 마을버스 제외)
    let sectName: String // 구간명
    let gpsX: String // 정류소 좌표X (WGS84)
    let gpsY: String // 정류소 좌표Y (WGS84)
    let posX: String // 정류소 좌표X (GRS80)
    let posY: String // 정류소 좌표Y (GRS80)
    let stationType: String // 정류소 타입 (0:공용, 1:일반형 시내/농어촌버스, 2:좌석형 시내/농어촌버스, 3:직행좌석형 시내/농어촌버스, 4:일반형 시외버스, 5:좌석형 시외버스, 6:고속형 시외버스, 7:마을버스)
    let firstTime: String // 첫차시간
    let lastTime: String // 막차시간
    let busTerm: String // 배차간격(분)
    let busRouteType: String // 노선유형 (1:공항, 2:마을, 3:간선, 4:지선, 5:순환, 6:광역, 7:인천, 8:경기, 9:폐지, 0:공용)
//    let nextBusTime: String // 다음버스 도착예정시간
    let stationOrder: String // 요청정류소순번
    
    // 첫번째 도착예정버스 정보
    let nextBusID1: String? // 첫번째 도착예정버스 ID
    let nextBusSectOrder1: String? // 첫번째 도착예정버스의 현재구간 순번
    let nextBusFinalStationName1: String? // 첫번째 도착예정버스의 최종 정류소명
    let nextBusTripTime1: String? // 첫번째 도착예정버스의 여행시간
    let nextBusTripSpeed1: String? // 첫번째 도착예정버스의 여행속도 (km/h)
//    let isArrive1: String? // 첫번째 도착예정버스의 최종 정류소 도착출발여부 (0:운행중, 1:도착)
//    let repTm1: String?
    let isNextBusLast1: String? // 첫번째 도착예정버스의 막차여부 (0:막차아님, 1:막차)
    let nextBusType1: String? // 첫번째 도착예정버스의 차량유형 (0:일반버스, 1:저상버스, 2:굴절버스)
    
    // 두번째 도착예정버스 정보
    let nextBusID2: String? // 두번째 도착예정버스 ID
    let nextBusSectOrder2: String? // 두번째 도착예정버스의 현재구간 순번
    let nextBusFinalStationName2: String? // 두번째 도착예정버스의 최종 정류소명
    let nextBusTripTime2: String? // 두번째 도착예정버스의 여행시간
    let nextBusTripSpeed2: String? // 두번째 도착예정버스의 여행속도 (km/h)
//    let isArrive2: String? // 두번째 도착예정버스의 최종 정류소 도착출발여부 (0:운행중, 1:도착)
//    let repTm2: String?
    let isNextBusLast2: String? // 두번째 도착예정버스의 막차여부 (0:막차아님, 1:막차)
    let nextBusType2: String? // 두번째 도착예정버스의 차량유형 (0:일반버스, 1:저상버스, 2:굴절버스)
    
    let direction: String // 방향
    let arrivalMessage1: String // 첫번째 도착예정버스의 도착정보메시지
    let arrivalMessage2: String // 두번째 도착예정버스의 도착정보메시지
    let arrivalMessageSec1: String // 첫번째 도착예정버스의 도착정보메시지
    let arrivalMessageSec2: String // 두번째 도착예정버스의 도착정보메시지
    let nextStation: String // 다음정류장순번(?) 정확히 뭔지 잘 모르겠음
    let rerideDiv1: String // 첫번째 도착예정버스의 재차구분 (2 고정인듯)
    let rerideDiv2: String // 두번째 도착예정버스의 재차구분
    let rerideNum1: String // 첫번째 도착예정버스의 재차인원 (0은 진짜 0명이거나 데이터가 없는 것 같음)
    let rerideNum2: String // 두번째 도착예정버스의 재차인원
    let isFullFlag1: String // 첫번째 도착예정버스의 만차여부 (0 : 만차아님. 1 : 만차)
    let isFullFlag2: String // 두번째 도착예정버스의 만차여부 (0 : 만차아님. 1 : 만차)
    let isDeTourFlag: String // 해당 노선 우회여부 (00: 정상, 11: 우회)
    let congestion1: String // 첫번째 도착예정버스의 혼잡도 (0: 데이터없음, 3: 여유, 4: 보통, 5: 혼잡)
    let congestion2: String // 두번째 도착예정버스의 혼잡도 (0: 데이터없음, 3: 여유, 4: 보통, 5: 혼잡)
    
    enum CodingKeys: String, CodingKey {
        case stationID = "stId"
        case stationName = "stNm"
        case arsID = "arsId"
        case busRouteID = "busRouteId"
        case busRouteName = "rtNm"
        case busRouteAbrv
        case sectName = "sectNm"
        case gpsX
        case gpsY
        case posX
        case posY
        case stationType = "stationTp"
        case firstTime = "firstTm"
        case lastTime = "lastTm"
        case busTerm = "term"
        case busRouteType = "routeType"
//        case nextBusTime = "nextBus"
        case stationOrder = "staOrd"
        
        case nextBusID1 = "vehId1"
        case nextBusSectOrder1 = "sectOrd1"
        case nextBusFinalStationName1 = "stationNm1"
        case nextBusTripTime1 = "traTime1"
        case nextBusTripSpeed1 = "traSpd1"
//        case isArrive1
//        case repTm1
        case isNextBusLast1 = "isLast1"
        case nextBusType1 = "busType1"
        
        case nextBusID2 = "vehId2"
        case nextBusSectOrder2 = "sectOrd2"
        case nextBusFinalStationName2 = "stationNm2"
        case nextBusTripTime2 = "traTime2"
        case nextBusTripSpeed2 = "traSpd2"
//        case isArrive2
//        case repTm2
        case isNextBusLast2 = "isLast2"
        case nextBusType2 = "busType2"
        
        case direction = "adirection"
        case arrivalMessage1 = "arrmsg1"
        case arrivalMessage2 = "arrmsg2"
        case arrivalMessageSec1 = "arrmsgSec1"
        case arrivalMessageSec2 = "arrmsgSec2"
        case nextStation = "nxtStn"
        case rerideDiv1 = "rerdieDiv1"
        case rerideDiv2 = "rerdieDiv2"
        case rerideNum1
        case rerideNum2
        case isFullFlag1
        case isFullFlag2
        case isDeTourFlag = "deTourAt"
        case congestion1
        case congestion2
    }
}

#if DEBUG
extension SeoulRealtimeBusStationDTO {
    static var mockData: Data {
        Data(
            """
            {
                "comMsgHeader": {
                    "responseTime": null,
                    "requestMsgID": null,
                    "responseMsgID": null,
                    "returnCode": null,
                    "errMsg": null,
                    "successYN": null
                },
                "msgHeader": {
                    "headerMsg": "정상적으로 처리되었습니다.",
                    "headerCd": "0",
                    "itemCount": 0
                },
                "msgBody": {
                    "itemList": [
                        {
                            "stId": "111000931", // 정류소 고유 ID
                            "stNm": "불광역3.6호선", // 정류소명
                            "arsId": "12022", // 정류소 번호
                            "busRouteId": "100100419", // 노선ID
                            "rtNm": "6012", // 노선명
                            "busRouteAbrv": "6012", // 노선 약칭 → 노선명 (안내용 – 마을버스 제외)
                            "sectNm": "동명여고.천주교불광동성당~서부시외버스터미널", // 구간명
                            "gpsX": "126.9281552459", // 정류소 좌표X (WGS84)
                            "gpsY": "37.6124473901", // 정류소 좌표Y (WGS84)
                            "posX": "193657.44899226326", // 정류소 좌표X (GRS80)
                            "posY": "456991.48178329226", // 정류소 좌표Y (GRS80)
                            "stationTp": "1", // 정류소 타입 (0:공용, 1:일반형 시내/농어촌버스, 2:좌석형 시내/농어촌버스, 3:직행좌석형 시내/농어촌버스, 4:일반형 시외버스, 5:좌석형 시외버스, 6:고속형 시외버스, 7:마을버스)
                            "firstTm": "0430  ", // 첫차시간
                            "lastTm": "2000  ", // 막차시간
                            "term": "70", // 배차간격(분)
                            "routeType": "1", // 노선유형 (1:공항, 2:마을, 3:간선, 4:지선, 5:순환, 6:광역, 7:인천, 8:경기, 9:폐지, 0:공용)
                            "nextBus": " ", // 다음버스 도착예정시간
                            "staOrd": "6", // 요청정류소순번
                            
                            "vehId1": "115065676", // 첫번째 도착예정버스 ID
                            "plainNo1": null,
                            "sectOrd1": "2", // 첫번째 도착예정버스의 현재구간 순번
                            "stationNm1": "박석고개.신도고등학교", // 첫번째 도착예정버스의 최종 정류소명
                            "traTime1": "714", // 첫번째 도착예정버스의 여행시간
                            "traSpd1": "18", // 첫번째 도착예정버스의 여행속도 (km/h)
                            "isArrive1": "0", // 첫번째 도착예정버스의 최종 정류소 도착출발여부 (0:운행중, 1:도착)
                            "repTm1": "2018-12-09 10:11:07.0",
                            "isLast1": "0", // 첫번째 도착예정버스의 막차여부 (0:막차아님, 1:막차)
                            "busType1": "0", // 첫번째 도착예정버스의 차량유형 (0:일반버스, 1:저상버스, 2:굴절버스)
                            
                            "vehId2": "0", // 두번째 도착예정버스 ID
                            "plainNo2": null,
                            "sectOrd2": "0", // 두번째 도착예정버스의 현재구간 순번
                            "stationNm2": null, // // 두번째 도착예정버스의 최종 정류소명
                            "traTime2": "0", // 두번째 도착예정버스의 여행시간
                            "traSpd2": "0", // 두번째 도착예정버스의 여행속도 (km/h)
                            "isArrive2": "0", // 두번째 도착예정버스의 최종 졍류소 도착출발여부 (0:운행중, 도착)
                            "repTm2": null,
                            "isLast2": "0", // 두번째 도착예정버스의 막차여부 (0:막차아님, 1:막차)
                            "busType2": "0", // 두번째 도착예정버스의 차량유형 (0:일반버스, 1:저상버스, 2:굴절버스)
                            
                            "adirection": "인천공항", // 방향
                            "arrmsg1": "11분54초후[4번째 전]", // 첫번째 도착예정버스의 도착정보메시지
                            "arrmsg2": "출발대기", // 두번째 도착예정버스의 도착정보메시지
                            "arrmsgSec1": "11분54초후[4번째 전]", // 첫번째 도착예정버스의 도착정보메시지
                            "arrmsgSec2": "두 번째 버스 출발대기", // 두번째 도착예정버스의 도착정보메시지
                            "nxtStn": "불광역3호선.서울혁신파크", // 다음정류장순번(?) 그냥 다음정류장인듯
                            "rerdieDiv1": "2", // 첫번째 도착예정버스의 재차구분 (2 고정인듯)
                            "rerdieDiv2": "2", // 두번째 도착예정버스의 재차구분
                            "rerideNum1": "0", // 첫번째 도착예정버스의 재차인원 (0은 진짜 0명이거나 데이터가 없는 것 같음)
                            "rerideNum2": "0", // 두번째 도착예정버스의 재차인원
                            "isFullFlag1": "0", // 첫번째 도착예정버스의 만차여부 (0 : 만차아님. 1 : 만차)
                            "isFullFlag2": "0", // 두번째 도착예정버스의 만차여부 (0 : 만차아님. 1 : 만차)
                            "deTourAt": "00", // 해당 노선 우회여부 (00: 정상, 11: 우회)
                            "congestion1": "0", // 첫번째 도착예정버스의 혼잡도 (0: 데이터없음, 3: 여유, 4: 보통, 5: 혼잡)
                            "congestion2": "0" // 두번째 도착예정버스의 혼잡도 (0: 데이터없음, 3: 여유, 4: 보통, 5: 혼잡)
                        },
                        {
                            "stId": "111000931",
                            "stNm": "불광역3.6호선",
                            "arsId": "12022",
                            "busRouteId": "100100103",
                            "rtNm": "701",
                            "busRouteAbrv": "701",
                            "sectNm": "동명여고.천주교불광동성당~서부시외버스터미널",
                            "gpsX": "126.9281552459",
                            "gpsY": "37.6124473901",
                            "posX": "193657.44899226326",
                            "posY": "456991.48178329226",
                            "stationTp": "1",
                            "firstTm": "0400  ",
                            "lastTm": "2300  ",
                            "term": "11",
                            "routeType": "3",
                            "nextBus": " ",
                            "staOrd": "20",
                            "vehId1": "123060371",
                            "plainNo1": null,
                            "sectOrd1": "18",
                            "stationNm1": "연신내역",
                            "traTime1": "417",
                            "traSpd1": "11",
                            "isArrive1": "0",
                            "repTm1": "2021-12-26 20:06:04.0",
                            "isLast1": "0",
                            "busType1": "1",
                            "vehId2": "123060225",
                            "plainNo2": null,
                            "sectOrd2": "12",
                            "stationNm2": "폭포동.은평노인종합복지관",
                            "traTime2": "936",
                            "traSpd2": "12",
                            "isArrive2": "0",
                            "repTm2": null,
                            "isLast2": "0",
                            "busType2": "1",
                            "adirection": "종로2가",
                            "arrmsg1": "6분57초후[2번째 전]",
                            "arrmsg2": "15분36초후[8번째 전]",
                            "arrmsgSec1": "6분57초후[2번째 전]",
                            "arrmsgSec2": "15분36초후[8번째 전]",
                            "nxtStn": "불광역3호선.서울혁신파크",
                            "rerdieDiv1": "2",
                            "rerdieDiv2": "2",
                            "rerideNum1": "23",
                            "rerideNum2": "27",
                            "isFullFlag1": "0",
                            "isFullFlag2": "0",
                            "deTourAt": "00",
                            "congestion1": "3",
                            "congestion2": "4"
                        },
                        {
                            "stId": "111000931",
                            "stNm": "불광역3.6호선",
                            "arsId": "12022",
                            "busRouteId": "116000006",
                            "rtNm": "703",
                            "busRouteAbrv": "703",
                            "sectNm": "동명여고.천주교불광동성당~서부시외버스터미널",
                            "gpsX": "126.9281552459",
                            "gpsY": "37.6124473901",
                            "posX": "193657.44899226326",
                            "posY": "456991.48178329226",
                            "stationTp": "1",
                            "firstTm": "0430  ",
                            "lastTm": "2230  ",
                            "term": "20",
                            "routeType": "3",
                            "nextBus": " ",
                            "staOrd": "46",
                            "vehId1": "111049225",
                            "plainNo1": null,
                            "sectOrd1": "34",
                            "stationNm1": "동산고등학교",
                            "traTime1": "1179",
                            "traSpd1": "23",
                            "isArrive1": "0",
                            "repTm1": null,
                            "isLast1": "0",
                            "busType1": "1",
                            "vehId2": "111049285",
                            "plainNo2": null,
                            "sectOrd2": "22",
                            "stationNm2": "식사오거리",
                            "traTime2": "2312",
                            "traSpd2": "22",
                            "isArrive2": "0",
                            "repTm2": null,
                            "isLast2": "0",
                            "busType2": "1",
                            "adirection": "숭례문",
                            "arrmsg1": "19분39초후[12번째 전]",
                            "arrmsg2": "38분32초후[24번째 전]",
                            "arrmsgSec1": "19분39초후[12번째 전]",
                            "arrmsgSec2": "38분32초후[24번째 전]",
                            "nxtStn": "불광역3호선.서울혁신파크",
                            "rerdieDiv1": "2",
                            "rerdieDiv2": "2",
                            "rerideNum1": "10",
                            "rerideNum2": "12",
                            "isFullFlag1": "0",
                            "isFullFlag2": "0",
                            "deTourAt": "00",
                            "congestion1": "3",
                            "congestion2": "3"
                        }
                    ]
                }
            }
            """.utf8
        )
    }
    static var mockDTO: Self {
        SeoulRealtimeBusStationDTO(
            comMsgHeader: ComMsgHeader(),
            msgHeader: MsgHeader(),
            arrivals: BusArrivals(itemList: [
                BusArrival(
                    stationID: "111000931",
                    stationName: "불광역3.6호선",
                    arsID: "12022",
                    busRouteID: "100100419",
                    busRouteName: "6012",
                    busRouteAbrv: "6012",
                    sectName: "동명여고.천주교불광동성당~서부시외버스터미널",
                    gpsX: "126.9281552459",
                    gpsY: "37.6124473901",
                    posX: "193657.44899226326",
                    posY: "456991.48178329226",
                    stationType: "1",
                    firstTime: "0430  ",
                    lastTime: "2000  ",
                    busTerm: "70",
                    busRouteType: "1",
                    stationOrder: "6",
                    nextBusID1: "115065676",
                    nextBusSectOrder1: "2",
                    nextBusFinalStationName1: "박석고개.신도고등학교",
                    nextBusTripTime1: "714",
                    nextBusTripSpeed1: "18",
                    isNextBusLast1: "0",
                    nextBusType1: "0",
                    nextBusID2: "0",
                    nextBusSectOrder2: "0",
                    nextBusFinalStationName2: nil,
                    nextBusTripTime2: "0",
                    nextBusTripSpeed2: "0",
                    isNextBusLast2: "0",
                    nextBusType2: "0",
                    direction: "인천공항",
                    arrivalMessage1: "11분54초후[4번째 전]",
                    arrivalMessage2: "출발대기",
                    arrivalMessageSec1: "11분54초후[4번째 전]",
                    arrivalMessageSec2: "두 번째 버스 출발대기",
                    nextStation: "불광역3호선.서울혁신파크",
                    rerideDiv1: "2",
                    rerideDiv2: "2",
                    rerideNum1: "0",
                    rerideNum2: "0",
                    isFullFlag1: "0",
                    isFullFlag2: "0",
                    isDeTourFlag: "00",
                    congestion1: "0",
                    congestion2: "0"
                ),
                BusArrival(
                    stationID: "111000931",
                    stationName: "불광역3.6호선",
                    arsID: "12022",
                    busRouteID: "100100103",
                    busRouteName: "701",
                    busRouteAbrv: "701",
                    sectName: "동명여고.천주교불광동성당~서부시외버스터미널",
                    gpsX: "126.9281552459",
                    gpsY: "37.6124473901",
                    posX: "193657.44899226326",
                    posY: "456991.48178329226",
                    stationType: "1",
                    firstTime: "0400  ",
                    lastTime: "2300  ",
                    busTerm: "11",
                    busRouteType: "3",
                    stationOrder: "20",
                    nextBusID1: "123060371",
                    nextBusSectOrder1: "18",
                    nextBusFinalStationName1: "연신내역",
                    nextBusTripTime1: "417",
                    nextBusTripSpeed1: "11",
                    isNextBusLast1: "0",
                    nextBusType1: "1",
                    nextBusID2: "123060225",
                    nextBusSectOrder2: "12",
                    nextBusFinalStationName2: "폭포동.은평노인종합복지관",
                    nextBusTripTime2: "936",
                    nextBusTripSpeed2: "12",
                    isNextBusLast2: "0",
                    nextBusType2: "1",
                    direction: "종로2가",
                    arrivalMessage1: "6분57초후[2번째 전]",
                    arrivalMessage2: "15분36초후[8번째 전]",
                    arrivalMessageSec1: "6분57초후[2번째 전]",
                    arrivalMessageSec2: "15분36초후[8번째 전]",
                    nextStation: "불광역3호선.서울혁신파크",
                    rerideDiv1: "2",
                    rerideDiv2: "2",
                    rerideNum1: "23",
                    rerideNum2: "27",
                    isFullFlag1: "0",
                    isFullFlag2: "0",
                    isDeTourFlag: "00",
                    congestion1: "3",
                    congestion2: "4"
                ),
                BusArrival(
                    stationID: "111000931",
                    stationName: "불광역3.6호선",
                    arsID: "12022",
                    busRouteID: "116000006",
                    busRouteName: "703",
                    busRouteAbrv: "703",
                    sectName: "동명여고.천주교불광동성당~서부시외버스터미널",
                    gpsX: "126.9281552459",
                    gpsY: "37.6124473901",
                    posX: "193657.44899226326",
                    posY: "456991.48178329226",
                    stationType: "1",
                    firstTime: "0430  ",
                    lastTime: "2230  ",
                    busTerm: "20",
                    busRouteType: "3",
                    stationOrder: "46",
                    nextBusID1: "111049225",
                    nextBusSectOrder1: "34",
                    nextBusFinalStationName1: "동산고등학교",
                    nextBusTripTime1: "1179",
                    nextBusTripSpeed1: "23",
                    isNextBusLast1: "0",
                    nextBusType1: "1",
                    nextBusID2: "111049285",
                    nextBusSectOrder2: "22",
                    nextBusFinalStationName2: "식사오거리",
                    nextBusTripTime2: "2312",
                    nextBusTripSpeed2: "22",
                    isNextBusLast2: "0",
                    nextBusType2: "1",
                    direction: "숭례문",
                    arrivalMessage1: "19분39초후[12번째 전]",
                    arrivalMessage2: "38분32초후[24번째 전]",
                    arrivalMessageSec1: "19분39초후[12번째 전]",
                    arrivalMessageSec2: "38분32초후[24번째 전]",
                    nextStation: "불광역3호선.서울혁신파크",
                    rerideDiv1: "2",
                    rerideDiv2: "2",
                    rerideNum1: "10",
                    rerideNum2: "12",
                    isFullFlag1: "0",
                    isFullFlag2: "0",
                    isDeTourFlag: "00",
                    congestion1: "3",
                    congestion2: "3"
                )
            ])
        )
    }
}
#endif
