//
//  LocationService.swift
//  Makcha
//
//  Created by 김영빈 on 5/5/24.
//

import CoreLocation

// MARK: - LocationService 정의
// Core Location 관련 위치 서비스 동작 처리 객체

typealias LocationCallback = (CLLocation?, Error?) -> Void // 위치 값을 인자로 전달하는 콜백 타입

protocol LocationServiceInterface {
    
    func fetchCurrentLocation(completion: @escaping LocationCallback)
    func convertCoordinateToAddress(lon: CLLocationDegrees, lat: CLLocationDegrees,
                                    completion: @escaping ((String?) -> Void)
    )
}

final class LocationService: NSObject, LocationServiceInterface {
    
    var locationManager: LocationManagerInterface
    private var fetchLocationCallBack: LocationCallback?
    
    init(locationManager: LocationManagerInterface = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.locationManagerDelegate = self
    }
    
    // 현재 위치를 불러오기
    func fetchCurrentLocation(completion: @escaping LocationCallback) {
        fetchLocationCallBack = completion
        
        // 위치서비스 허용 상태일 때만 현재 위치 불러오기
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // 위도-경도로 주소 변환
    // TODO: - 리버스 지오코딩 API 변경하기
    func convertCoordinateToAddress(
        lon: CLLocationDegrees,
        lat: CLLocationDegrees,
        completion: @escaping ((String?) -> Void)
    ) {
        let locationToConvert = CLLocation(latitude: lat, longitude: lon)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(locationToConvert, preferredLocale: locale) { (placeMarks, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            guard let address = placeMarks?.last else {
                completion(nil)
                return
            }
            var addressStr = ""
            if let locality = address.locality {
                addressStr += locality
            }
            if let subLocality = address.subLocality {
                addressStr += " \(subLocality)"
            }
            if let placeName = address.name {
                addressStr += " \(placeName)"
            }
            print("리버스 지오코딩 결과: \(addressStr)")
            completion(addressStr)
        }
    }
}

// MARK: - LocationManagerDelegate 델리게이트 구현

extension LocationService: LocationManagerDelegate {
    
    // [LocationManager가 초기화됐을 때 .notDetermined일 경우] or [권한 상태가 변경되었을 때] 호출
    func locationManagerAbstract(_ manager: LocationManagerInterface, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("위치 서비스 사용 가능")
            locationManager.requestLocation() // 위치 서비스를 허용하고 나면 현재 위치 불러오기
        case .restricted, .denied:
            print("위치 서비스 사용 불가")
            // TODO: - "위치 서비스를 사용하려면 승인이 필요합니다. 설정을 변경해주세요." 팝업 띄우기 (이 권한 상태에서는 요청 팝업 불가)
        case .notDetermined:
            print("권한 설정 필요")
            locationManager.requestWhenInUseAuthorization() // 권한 요청
        default:
            break
        }
    }

    func locationManagerAbstract(_ manager: LocationManagerInterface, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        fetchLocationCallBack?(location, nil)
        fetchLocationCallBack = nil
    }

    func locationManagerAbstract(_ manager: LocationManagerInterface, didFailWithError error: Error) {
        fetchLocationCallBack?(nil, LocationServiceError.fetchFailed)
        fetchLocationCallBack = nil
        // TODO: - 실패 시 UI처리 필요
    }
}

// MARK: - CLLocationManagerDelegate 델리게이트 구현

extension LocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManagerAbstract(manager, didChangeAuthorization: manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManagerAbstract(manager, didUpdateLocations: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManagerAbstract(manager, didFailWithError: error)
    }
}
