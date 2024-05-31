//
//  TransPathRepositoryProtocol.swift
//  Makcha
//
//  Created by 김영빈 on 5/7/24.
//

import Foundation
import RxSwift

// MARK: - TransPathRepositoryProcotol 정의
// 의존성 역전을 위해 Data 계층의 TransPathRepository에서 필요한 인터페이스를 정의

protocol TransPathRepositoryProtocol {
    func getAllMakchaTransPath(start: XYCoordinate, end: XYCoordinate) -> Observable<MakchaInfo>
    func getSeoulRealtimeSubwayArrival(
        stationName: String,
        subwayLineCodeInt: Int,
        wayCodeInt: Int,
        currentTime: Date
    ) -> Observable<RealtimeArrivalTuple>
    func getSeoulRealtimeBusArrival(
        routeIDs: [String],
        routeNames: [String],
        arsID: String
    ) -> Observable<RealtimeArrivalTuple>
}
