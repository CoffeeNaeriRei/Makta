//
//  EndPoint.swift
//  Makcha
//
//  Created by 김영빈 on 5/8/24.
//

// MARK: - EndPoint
// 막차 경로 검색의 기준이 되는 출발점, 도착점의 좌표

struct EndPoint: Equatable {
    let name: String? // 장소 이름 (검색 시에만 활용)
    let addressName: String // 지번주소
    let roadAddressName: String? // 도로명주소
    let coordinate: XYCoordinate // 좌표
    
    static func == (lhs: EndPoint, rhs: EndPoint) -> Bool {
        return (lhs.name == rhs.name) || (lhs.addressName == rhs.addressName) || (lhs.roadAddressName == rhs.roadAddressName) || (lhs.coordinate == rhs.coordinate)
    }
    
    init(name: String? = nil, addressName: String, roadAddressName: String?, coordinate: XYCoordinate) {
        self.name = name
        self.addressName = addressName
        self.roadAddressName = roadAddressName
        self.coordinate = coordinate
    }
}

#if DEBUG
extension EndPoint {
    static let mockStartPoint = EndPoint(
        name: nil, // 대조어린이공원
        addressName: "서울 은평구 대조동 212",
        roadAddressName: "서울특별시 은평구 연서로22길 9-30",
        coordinate: ("126.919971934734", "37.6155372675701")
    )
    static let mockDestinationPoint = EndPoint(
        name: "경찰병원역 3호선", // 경찰병원역 3호선
        addressName: "서울 송파구 가락동 10-15",
        roadAddressName: nil, // 서울 송파구 중대로 지하 149
        coordinate: ("127.124482397777", "37.4960049150853")
    )
    static let mockSearchedEndpoints = [
        EndPoint(
            name: "홍익대학교 서울캠퍼스",
            addressName: "서울 마포구 상수동 72-1",
            roadAddressName: "서울 마포구 와우산로 94",
            coordinate: ("126.925554591431", "37.550874837441")
        ),
        EndPoint(
            name: "홍익대학교 세종캠퍼스",
            addressName: "세종특별자치시 조치원읍 신안리 300",
            roadAddressName: "세종특별자치시 조치원읍 세종로 2639",
            coordinate: ("127.28775790295296", "36.62102674811619")
        ),
        EndPoint(
            name: "홍익대학교 서울캠퍼스 정문",
            addressName: "서울 마포구 서교동 338-19",
            roadAddressName: "",
            coordinate: ("126.92443913897051", "37.55275180872968")
        ),
        EndPoint(
            name: "홍익닭한마리 홍대본점",
            addressName: "서울 마포구 서교동 333-13",
            roadAddressName: "서울 마포구 와우산로29라길 20",
            coordinate: ("126.926817973835", "37.5550490491891")
        )
    ]
}
#endif
