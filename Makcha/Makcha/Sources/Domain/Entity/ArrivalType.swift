//
//  ArrivalType.swift
//  Makcha
//
//  Created by 김영빈 on 5/24/24.
//

// MARK: - 버스|지하철의 도착 정보와 관련된 타입들을 정의

// 실시간 도착 정보를 나타내는 튜플 (첫번째도착상태, 두번째도착상태)
typealias RealtimeArrivalTuple = (first: ArrivalStatus?, second: ArrivalStatus?)

// 버스와 지하철의 실시간 도착 상태를 나타내는 타입
enum ArrivalStatus {
    case waiting // 출발대기
    case finished // 운행종료
    case arriveSoon // 곧 도착
    case coming(remaingSecond: Int) // 운행중(남은시간(초))
    case unknown // 알 수 없음
}
