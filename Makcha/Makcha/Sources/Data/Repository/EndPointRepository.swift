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
    
    // 현재 위치의 좌표를 불러와서 EndPoint 값으로 반환
    func getCurrentLocation() -> Observable<EndPoint> {
        return Observable.create { emitter in
            self.locationService.fetchCurrentLocation { (clLocation, error) in
                if let error = error {
                    print("[LocationService] - ❌ 위치 불러오기 실패")
                    emitter.onError(error)
                }
                guard let location = clLocation else {
                    print("[LocationService] - ❌ 위치 데이터가 없음")
                    emitter.onError(LocationServiceError.noLocationData)
                    return
                }
                print("[LocationService] - ✅ 위치 불러오기 성공")
                
                let lon = location.coordinate.longitude
                let lat = location.coordinate.latitude
                // 경/위도 -> 주소 변환
                self.locationService.convertCoordinateToAddress(lon: lon, lat: lat) { addressStr in
                    
                    var nameStr = ""
                    if let addressStr = addressStr {
                        print("[LocationService] - ✅ 좌표→주소 변환 성공")
                        nameStr = addressStr
                    } else {
                        print("[LocationService] - ❌ 좌표→주소 변환 실패")
                        nameStr = "\(lat.description),\(lon.description) (좌표변환 실패)"
                    }
                    
                    let endPoint = EndPoint(name: nameStr, coordinate: (lon.description, lat.description))
                    emitter.onNext(endPoint)
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
