//
//  APIServiceType.swift
//  Makcha
//
//  Created by 김영빈 on 5/7/24.
//

// MARK: - APIService와 관련된 타입들 정의

// 경로검색결과 정렬방식
enum ResultOrderType: Int {
    case recommendPath = 0 // 추천경로순
    case transType = 1 // 타입별 정렬 (지하철, 버스, 버스+지하철, 지하철+버스, 버스+지하철+버스)
}
// 도시내/도시간 이동 선택
enum SearchType: Int {
    case inCity = 0 // 도시내
    case cityToCity = 1 // 도시간
}
// 도시 내 경로수단 지정
enum SearchPathType: Int {
    case all = 0 // 모두
    case subway = 1 // 지하철
    case bus = 2 // 버스
}
