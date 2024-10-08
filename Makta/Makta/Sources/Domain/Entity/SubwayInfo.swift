//
//  SubwayInfo.swift
//  Makcha
//
//  Created by 김영빈 on 5/13/24.
//

import SwiftUI

import MakchaDesignSystem

// ODSay API의 응답 데이터에서 지하철 노선을 구분하는 타입
enum SubwayCode: Int {
    case 수도권1호선 = 1
    case 수도권2호선 = 2
    case 수도권3호선 = 3
    case 수도권4호선 = 4
    case 수도권5호선 = 5
    case 수도권6호선 = 6
    case 수도권7호선 = 7
    case 수도권8호선 = 8
    case 수도권9호선 = 9
    case GTX = 91
    case 공항철도 = 101
    case 자기부상철도 = 102
    case 경의중앙선 = 104
    case 에버라인 = 107
    case 경춘선 = 108
    case 신분당선 = 109
    case 의정부경전철 = 110
    case 경강선 = 112
    case 우이신설선 = 113
    case 서해선 = 114
    case 김포골드라인 = 115
    case 수인분당선 = 116
    case 신림선 = 117
    case 인천1호선 = 21
    case 인천2호선 = 22
    
    // ODSay API의 지하철 노선 코드를 서울 실시간 지하철 응답정보의 지하철호선ID로 변환한 프로퍼티
    var seoulRealtimeSubwayID: String? {
        switch self {
        case .수도권1호선: return "1001"
        case .수도권2호선: return "1002"
        case .수도권3호선: return "1003"
        case .수도권4호선: return "1004"
        case .수도권5호선: return "1005"
        case .수도권6호선: return "1006"
        case .수도권7호선: return "1007"
        case .수도권8호선: return "1008"
        case .수도권9호선: return "1009"
        case .경의중앙선: return "1063"
        case .공항철도: return "1065"
        case .경춘선: return "1067"
        case .수인분당선: return "1075"
        case .신분당선: return "1077"
        case .경강선: return "1081"
        case .우이신설선: return "1092"
        case .서해선: return "1093"
        case .GTX: return "1032"
        default: return nil
            // 서울 실시간 지하철 응답정보 API에서 지원하지 않는 호선들
//        case .자기부상철도: return ""
//        case .에버라인: return ""
//        case .의정부경전철: return ""
//        case .김포골드라인: return ""
//        case .신림선: return ""
//        case .인천1호선: return ""
//        case .인천2호선: return ""
        }
    }
    
    var subwayColor: Color {
        switch self {
        case .수도권1호선:
            Color.transport(.subway(.metropolitanRailway(.line1)))
        case .수도권2호선:
            Color.transport(.subway(.metropolitanRailway(.line2)))
        case .수도권3호선:
            Color.transport(.subway(.metropolitanRailway(.line3)))
        case .수도권4호선:
            Color.transport(.subway(.metropolitanRailway(.line4)))
        case .수도권5호선:
            Color.transport(.subway(.metropolitanRailway(.line5)))
        case .수도권6호선:
            Color.transport(.subway(.metropolitanRailway(.line6)))
        case .수도권7호선:
            Color.transport(.subway(.metropolitanRailway(.line7)))
        case .수도권8호선:
            Color.transport(.subway(.metropolitanRailway(.line8)))
        case .수도권9호선:
            Color.transport(.subway(.metropolitanRailway(.line9)))
        case .GTX:
            Color.transport(.subway(.metropolitanRailway(.gtxA)))
        case .공항철도:
            Color.transport(.subway(.metropolitanRailway(.공항철도)))
        case .자기부상철도:
            Color.cf(.colorScale(.yellow(.medium)))
        case .경의중앙선:
            Color.transport(.subway(.metropolitanRailway(.경의중앙선)))
        case .에버라인:
            Color.transport(.subway(.metropolitanRailway(.용인에버라인)))
        case .경춘선:
            Color.transport(.subway(.metropolitanRailway(.경춘선)))
        case .신분당선:
            Color.transport(.subway(.metropolitanRailway(.신분당선)))
        case .의정부경전철:
            Color.transport(.subway(.metropolitanRailway(.의정부경전철)))
        case .경강선:
            Color.transport(.subway(.metropolitanRailway(.경강선)))
        case .우이신설선:
            Color.transport(.subway(.metropolitanRailway(.우이신설선)))
        case .서해선:
            Color.transport(.subway(.metropolitanRailway(.서해선)))
        case .김포골드라인:
            Color.transport(.subway(.metropolitanRailway(.김포골드라인)))
        case .수인분당선:
            Color.transport(.subway(.metropolitanRailway(.수인분당선)))
        case .신림선:
            Color.transport(.subway(.metropolitanRailway(.신림선)))
        case .인천1호선:
            Color.transport(.subway(.metropolitanRailway(.인천1호선)))
        case .인천2호선:
            Color.transport(.subway(.metropolitanRailway(.인천2호선)))
        }
    }
    
    var subWayUIColor: UIColor {
        UIColor(self.subwayColor)
    }
}

// ODSay API의 응답 데이터에서 지하철 방면을 구분하는 타입
/// - ODSay : 상행(1) - 하행(2)
/// - 서울시 실시간 지하철 도착정보 : 상행(0) - 하행(1)
enum SubwayWay: Int {
    case up = 1
    case down = 2
    
    // ODSay API의 지하철 방면 코드를 서울 실시간 지하철 응답정보의 방면코드 값으로 변환한 프로퍼티
    var seoulRealtimeSubwayWayCode: String? {
        switch self {
        case .up: return "0"
        case .down: return "1"
        }
    }
}

// MARK: ODSay API 응답 데이터 중 버스노선을 구분하는 타입
/// - https://lab.odsay.com/guide/releaseReference#searchBusLane
/// - 버스 종류 별로 색상 관리를 위해 사용
enum BusRouteType: Int {
    case 일반 = 1
    case 좌석 = 2
    case 마을버스 = 3
    case 직행좌석 = 4
    case 공항버스 = 5
    case 간선급행 = 6
    case 외곽 = 10
    case 간선 = 11
    case 지선 = 12
    case 순환 = 13
    case 광역 = 14
    case 급행 = 15
    case 광관버스 = 16
    case 농어촌버스 = 20
    case 경기도시외형버스 = 22
    case 급행간선 = 26
    
    var busColor: Color {
        switch self {
        case .일반:
            Color.transport(.bus(.gyeonggiBusType(.일반)))
        case .좌석:
            Color.transport(.bus(.gyeonggiBusType(.좌석)))
        case .마을버스:
            Color.transport(.bus(.gyeonggiBusType(.마을)))
        case .직행좌석:
            Color.transport(.bus(.gyeonggiBusType(.직행좌석)))
        case .공항버스:
            Color.transport(.bus(.seoulBusType(.공항)))
        case .간선급행:
            Color.transport(.bus(.seoulBusType(.간선)))
        case .외곽:
            Color.cf(.colorScale(.darkRed(.mediumDark)))
        case .간선:
            Color.transport(.bus(.seoulBusType(.간선)))
        case .지선:
            Color.transport(.bus(.seoulBusType(.지선)))
        case .순환:
            Color.transport(.bus(.seoulBusType(.순환)))
        case .광역:
            Color.transport(.bus(.seoulBusType(.광역)))
        case .급행:
            Color.cf(.colorScale(.blue(.mediumLight)))
        case .광관버스:
            Color.cf(.colorScale(.blue(.medium)))
        case .농어촌버스:
            Color.cf(.colorScale(.blue(.mediumDark)))
        case .경기도시외형버스:
            Color.cf(.colorScale(.blue(.dark)))
        case .급행간선:
            Color.cf(.colorScale(.blue(.darker)))
        }
    }
    
    var busUIColor: UIColor {
        UIColor(self.busColor)
    }
}
