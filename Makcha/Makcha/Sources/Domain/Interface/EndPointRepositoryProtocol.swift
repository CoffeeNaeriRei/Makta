//
//  EndPointRepositoryProtocol.swift
//  Makcha
//
//  Created by 김영빈 on 5/10/24.
//

// MARK: - EndPointRepositoryProtocol 정의
// 의존성 역전을 위해 Data 계층의 EndPointRepository에서 필요한 인터페이스를 정의

import RxSwift

protocol EndPointRepositoryProtocol {
    func getCurrentLocation() -> Observable<EndPoint>
    func getSearchedAddresses(searchKeyword: String) -> Observable<[EndPoint]>
}
