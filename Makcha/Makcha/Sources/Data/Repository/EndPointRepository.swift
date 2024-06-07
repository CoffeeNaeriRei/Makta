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
    private let apiService: APIServiceInterface
    
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
    
    // 키워드로 검색된 장소들을 EndPoint의 배열로 반환
    func getSearchedAddresses(searchKeyword: String) -> Observable<[EndPoint]> {
        return Observable.create() { emitter in
            self.apiService.fetchKakaoPlaceSearchResult(placeKeyword: searchKeyword) { result in
                switch result {
                case .success(let kakaoPlaceSearchResultDTO):
                    print("[APIService] - ✅ fetchKakaoPlaceSearchResult() 호출 성공!!")
                    var searchedAddressArr = [EndPoint]()
                    for kakaoPlace in kakaoPlaceSearchResultDTO.places {
                        let searchedAddress = EndPoint(
                            name: kakaoPlace.placeName,
                            addressName: kakaoPlace.addressName,
                            roadAddressName: kakaoPlace.roadAddressName,
                            coordinate: (kakaoPlace.x, kakaoPlace.y)
                        )
                        searchedAddressArr.append(searchedAddress)
                    }
                    emitter.onNext(searchedAddressArr)
                    emitter.onCompleted()
                case .failure(let error):
                    print("[APIService] - ❌ fetchKakaoPlaceSearchResult() 호출 실패 \(error.localizedDescription)")
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
