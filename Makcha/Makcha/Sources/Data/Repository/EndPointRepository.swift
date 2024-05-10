//
//  EndPointRepository.swift
//  Makcha
//
//  Created by 김영빈 on 5/10/24.
//

import Foundation

import RxSwift

// MARK: - EndPointRepository 정의
// DTO -> Entity 변환 후 Domain 계층(UseCase)에 전달

final class EndPointRepository: EndPointRepositoryProtocol {
    
    private let locationService: LocationServiceInterface
    
    init(_ locationService: LocationServiceInterface) {
        self.locationService = locationService
    }
    
    // 현재 위치의 좌표를 불러와서 반환
    func getCurrentLocation() -> Observable<EndPoint> {
        return Observable.create { emitter in
            self.locationService.fetchCurrentLocation { (clLocation, error) in
                if let error = error {
                    print("[LocationService - ❌ 위치 불러오기 실패]")
                    emitter.onError(error)
                }
                guard let location = clLocation else {
                    print("[LocationService - ❌ 위치 데이터가 없음]")
                    emitter.onError(LocationServiceError.noLocationData)
                    return
                }
                let endPoint = EndPoint(
                    coordinate: (location.coordinate.longitude.description, location.coordinate.latitude.description)
                )
                emitter.onNext(endPoint)
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
}
