//
//  BusInfo.swift
//  Makcha
//
//  Created by 김영빈 on 5/24/24.
//

// 서울 실시간 버스 정류소 정보 API의 응답에 기반하여 버스 도착 상태를 나타내는 타입
enum BusArrivalStatus {
    case waiting // 출발대기
    case finished // 운행종료
    case arriveSoon // 곧 도착
    case coming(remaingSecond: Int) // 운행중(남은시간(초))
    case unknown // 알 수 없음
}
