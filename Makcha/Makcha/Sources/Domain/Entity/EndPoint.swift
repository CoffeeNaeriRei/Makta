//
//  EndPoint.swift
//  Makcha
//
//  Created by 김영빈 on 5/8/24.
//

// MARK: - EndPoint
// 막차 경로 검색의 기준이 되는 출발점, 도착점의 좌표

import Foundation

/// UserDefaults에 저장될 Destination key
enum DestinationKey: String {
    case defaultDestination
    case tempDestination
}

struct EndPoint: Codable, Equatable {
    let name: String? // 장소 이름 (검색 시에만 활용)
    let addressName: String // 지번주소
    let roadAddressName: String? // 도로명주소
    let lonX: String
    let latY: String
    
    static func == (lhs: EndPoint, rhs: EndPoint) -> Bool {
        return (lhs.name == rhs.name) || (lhs.addressName == rhs.addressName) || (lhs.roadAddressName == rhs.roadAddressName) || (lhs.lonX == rhs.lonX) || (lhs.latY == rhs.latY)
    }
    
    init(name: String? = nil, addressName: String, roadAddressName: String?, lonX: String, latY: String) {
        self.name = name
        self.addressName = addressName
        self.roadAddressName = roadAddressName
        self.lonX = lonX
        self.latY = latY
    }
    
    /// EndPoint를 UserDefaults로 저장하는 메서드
    func saveAsUserDefaults(key: DestinationKey) {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(self) else {
            print("UserDefaults에 \(key.rawValue) 저장 실패")
            return
        }
        UserDefaults.standard.setValue(encoded, forKey: key.rawValue)
        print("UserDefaults에 \(key.rawValue) 저장 성공!!")
    }
    
    /// UserDefaults로부터 EndPoint 데이터를 불러오는 메서드
    static func loadFromUserDefaults(key: DestinationKey) -> EndPoint? {
        let decoder = JSONDecoder()
        guard let data = UserDefaults.standard.object(forKey: key.rawValue) as? Data,
              let endPoint = try? decoder.decode(EndPoint.self, from: data) else {
            print("UserDefaults에서 \(key.rawValue) 불러오기 실패")
            return nil
        }
        return endPoint
    }
}

#if DEBUG
extension EndPoint {
    static let mockStartPoint = EndPoint(
        name: nil, // 대조어린이공원
        addressName: "서울 은평구 대조동 212",
        roadAddressName: "서울특별시 은평구 연서로22길 9-30",
        lonX: "126.919971934734",
        latY: "37.6155372675701"
    )
    static let mockDestinationPoint = EndPoint(
        name: "경찰병원역 3호선", // 경찰병원역 3호선
        addressName: "서울 송파구 가락동 10-15",
        roadAddressName: nil, // 서울 송파구 중대로 지하 149
        lonX: "127.124482397777",
        latY: "37.4960049150853"
    )
    static let mockSearchedEndpoints = [
        EndPoint(
            name: "홍익대학교 서울캠퍼스",
            addressName: "서울 마포구 상수동 72-1",
            roadAddressName: "서울 마포구 와우산로 94",
            lonX: "126.925554591431",
            latY: "37.550874837441"
        ),
        EndPoint(
            name: "홍익대학교 세종캠퍼스",
            addressName: "세종특별자치시 조치원읍 신안리 300",
            roadAddressName: "세종특별자치시 조치원읍 세종로 2639",
            lonX: "127.28775790295296",
            latY: "36.62102674811619"
        ),
        EndPoint(
            name: "홍익대학교 서울캠퍼스 정문",
            addressName: "서울 마포구 서교동 338-19",
            roadAddressName: "",
            lonX: "126.92443913897051",
            latY: "37.55275180872968"
        ),
        EndPoint(
            name: "홍익닭한마리 홍대본점",
            addressName: "서울 마포구 서교동 333-13",
            roadAddressName: "서울 마포구 와우산로29라길 20",
            lonX: "126.926817973835",
            latY: "37.5550490491891"
        )
    ]
}
#endif
