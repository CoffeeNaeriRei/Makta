//
//  LocationService.swift
//  Makcha
//
//  Created by 김영빈 on 5/5/24.
//

import CoreLocation

// MARK: - LocationService 정의
// Core Location 관련 위치 서비스 동작 처리 객체

final class LocationService: NSObject {
    
    typealias LocationCallback = (CLLocation?, Error?) -> Void // 위치 값을 인자로 전달하는 콜백 타입
    
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
        locationManager.requestLocation()
    }
}

// MARK: - LocationManagerDelegate 델리게이트 구현

extension LocationService: LocationManagerDelegate {
    
    func locationManagerAbstract(_ manager: LocationManagerInterface, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("위치 서비스 사용 가능")
        case .restricted, .denied:
            print("위치 서비스 사용 불가")
            // TODO: - "위치 서비스를 사용하려면 승인이 필요합니다." 팝업 띄우기
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
