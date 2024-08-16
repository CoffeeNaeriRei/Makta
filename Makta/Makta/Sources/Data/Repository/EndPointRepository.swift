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
    
    init(_ locationService: LocationServiceInterface, _ apiService: APIServiceInterface) {
        self.locationService = locationService
        self.apiService = apiService
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
                
                let lon = String(location.coordinate.longitude)
                let lat = String(location.coordinate.latitude)
                // 경/위도 -> 주소 변환
                self.apiService.fetchKakaoReverseGeocodingResult(lonX: lon, latY: lat) { result in
                    switch result {
                    case .success(let kakaoReverseGeocodingResultDTO):
                        guard let addressInfo = kakaoReverseGeocodingResultDTO.results.first else {
                            print("리버스 지오코딩 실패")
                            emitter.onError(APIServiceError.noData)
                            return
                        }
                        let endPoint = EndPoint(
                            addressName: addressInfo.address.addressName,
                            roadAddressName: addressInfo.roadAddress?.addressName,
                            lonX: lon,
                            latY: lat
                        )
                        emitter.onNext(endPoint)
                        emitter.onCompleted()
                    case .failure(let error):
                        print("[APIService] - ❌ fetchKakaoReverseGeocodingResult() 호출 실패 \(error.localizedDescription)")
                        emitter.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    // 키워드로 검색된 장소들을 EndPoint의 배열로 반환
    func getSearchedAddresses(searchKeyword: String) -> Observable<[EndPoint]> {
        return Observable.create { emitter in
            self.apiService.fetchKakaoPlaceSearchResult(placeKeyword: searchKeyword) { result in
                switch result {
                case .success(let kakaoPlaceSearchResultDTO):
                    var searchedAddressArr = [EndPoint]()
                    for kakaoPlace in kakaoPlaceSearchResultDTO.places {
                        let searchedAddress = EndPoint(
                            name: kakaoPlace.placeName,
                            addressName: kakaoPlace.addressName,
                            roadAddressName: kakaoPlace.roadAddressName,
                            lonX: kakaoPlace.x,
                            latY: kakaoPlace.y
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
