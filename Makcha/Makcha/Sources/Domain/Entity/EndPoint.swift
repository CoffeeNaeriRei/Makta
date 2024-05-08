//
//  EndPoint.swift
//  Makcha
//
//  Created by 김영빈 on 5/8/24.
//

// MARK: - EndPoint
// 막차 경로 검색의 기준이 되는 출발점, 도착점의 좌표

struct EndPoint {
    let start: String // 출발 지점
    let end: String // 도착 지점
    
    let startCoordinate: XYCoordinate // 출발 지점 좌표
    let endCoordinate: XYCoordinate // 도착 지점 좌표
}
