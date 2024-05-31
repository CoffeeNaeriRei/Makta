//
//  ArrivalType.swift
//  Makcha
//
//  Created by 김영빈 on 5/24/24.
//

// MARK: - 버스|지하철의 도착 정보와 관련된 타입들을 정의

// 실시간 도착 정보를 나타내는 튜플 (첫번째도착상태, 두번째도착상태)
typealias RealtimeArrivalTuple = (first: ArrivalStatus, second: ArrivalStatus)

// 버스와 지하철의 실시간 도착 상태를 나타내는 타입
/// Comparable 프로토콜을 채택해서 표시할 때의 우선순위를 비교할 수 있도록 함 (위로 갈수록 우선순위가 더 큼 + coming의 경우 적은 시간이 남을수록 우선순위가 높음)
enum ArrivalStatus: Comparable {
    case arriveSoon // 곧 도착
    case coming(remainingSecond: Int) // 운행중(남은시간(초))
    case waiting // 출발대기
    case finished // 운행종료
    case unknown // 알 수 없음
    
    // 각각의 Arrivalstatus case에 따라 화면에 표시할 String 반환
    var arrivalMessage: String {
        switch self {
        case .arriveSoon:
            return "곧 도착"
        case .coming(remainingSecond: let remainingSecond):
            return remainingSecond.convertToMinuteSecondString
        case .waiting:
            return "출발 대기"
        case .finished:
            return "운행 종료"
        case .unknown:
            return "불러오지 못함"
        }
    }
}
