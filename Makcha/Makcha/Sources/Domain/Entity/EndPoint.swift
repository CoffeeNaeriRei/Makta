//
//  EndPoint.swift
//  Makcha
//
//  Created by 김영빈 on 5/8/24.
//

// MARK: - EndPoint
// 막차 경로 검색의 기준이 되는 출발점, 도착점의 좌표

struct EndPoint: Equatable {
    let name: String // 장소 이름
    let addressName: String // 지번주소
    let roadAddressName: String? // 도로명주소
    let coordinate: XYCoordinate // 좌표
    
    static func == (lhs: EndPoint, rhs: EndPoint) -> Bool {
        return (lhs.name == rhs.name) || (lhs.addressName == rhs.addressName) || (lhs.roadAddressName == rhs.roadAddressName) || (lhs.coordinate == rhs.coordinate)
    }
}

#if DEBUG
let mockStartPoint = EndPoint(
    name: "대조어린이공원",
    addressName: "서울 은평구 대조동 212",
    roadAddressName: "서울 은평구 연서로22길 9-30",
    coordinate: ("126.919971934734", "37.6155372675701")
)
let mockDestinationPoint = EndPoint(
    name: "경찰병원역 3호선",
    addressName: "서울 송파구 가락동 10-15",
    roadAddressName: "서울 송파구 중대로 지하 149",
    coordinate: ("127.124482397777", "37.4960049150853")
)
#endif
