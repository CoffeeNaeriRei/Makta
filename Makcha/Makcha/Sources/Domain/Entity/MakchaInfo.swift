//
//  MakchaInfo.swift
//  Makcha
//
//  Created by 김영빈 on 5/7/24.
//

// MARK: - MakchaInfo
// 불러온 막차 경로 정보를 담을 Entity 모델

struct MakchaInfo {
    let start: String // 출발지
    let end: String // 도착지
    let startTime: String // 출발시간 ex) 오늘 오후 22:37 출발
    let makchaPaths: [MakchaPath] // 각각의 막차 경로 정보
}

// 막차 경로 정보
struct MakchaPath {
    let fastest: Bool // 가장 빠른 경로 여부
    let arrivalTime: String // 도착시간 ex) 다음날 오전 01:23 도착
    let totalTime: Int // 총 소요시간 (단위: 분)
    let firstSubPathRemaining: Int // 첫번째 세부경로 이동수단 도착까지 남은 시간 (단위: 분)
    let firstSubPathNextRemaining: Int // 첫번째 세부경로 이동수단 다음 2번째 도착까지 남은 시간 (단위: 분)
    let subPath: [MakchaSubPath] // 세부경로들
}

// 세부경로
struct MakchaSubPath {
    let subPathType: SubPathType // 세부경로 타입 (도보-버스-지하철)
    let distance: Int // 이동거리
    let time: Int // 소요시간
    
    // 지하철🚇 | 버스🚌  일 경우에만
    let stationCount: Int? // 거치는 정거장(역)의 수
    let lane: [LaneInfo]? // 교통수단 정보 (버스일 경우 여러개)
    let startName: String? // 승차 정류장
    let endName: String? // 하차 정류장
    let stations: [PassStation]? // 거치는 정거장(역)들
}

enum SubPathType: String {
    case walk = "도보"
    case bus = "버스"
    case subway = "지하철"
}

// 세부경로의 교통수단 정보
struct LaneInfo {
    let name: String // 지하철 노선명 or 버스 번호
    
    // 필요시 지하철 노선 번호, 버스 코드 등 추가 가능
}

// 세부경로에서 거치는 정거장(역) 정보 (Station 이름이 DTO 모델과 겹쳐서 PassStation으로 함)
struct PassStation {
    let index: Int // 순서
    let name: String // 이름
}
