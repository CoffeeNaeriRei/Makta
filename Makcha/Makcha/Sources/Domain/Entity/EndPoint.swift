//
//  EndPoint.swift
//  Makcha
//
//  Created by 김영빈 on 5/8/24.
//

// MARK: - EndPoint
// 막차 경로 검색의 기준이 되는 출발점, 도착점의 좌표

struct EndPoint {
    // TODO: - 리버스 지오코딩 필요함
//    let name: String // 좌표 주소명
    let coordinate: XYCoordinate // 좌표
}

#if DEBUG
let mockStartPoint = EndPoint(coordinate: ("126.926493082645", "37.6134436427887"))
let mockDestinationPoint = EndPoint(coordinate: ("127.126936754911", "37.5004198786564"))
#endif
