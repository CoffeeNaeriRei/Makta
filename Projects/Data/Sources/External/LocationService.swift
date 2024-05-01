//
//  LocationService.swift
//  Data
//
//  Created by 김영빈 on 5/1/24.
//

import CoreLocation

// MARK: - LocationService 정의

final class LocationService: NSObject {
    
    typealias LocationCallback = (CLLocation?) -> Void
    
    private var locationManager: CLLocationManager
    private var fetchLocationCallBack: LocationCallback?
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
    }
    
    // 현재 위치를 불러오기
    func fetchCurrentLocation(completion: @escaping LocationCallback) {
        fetchLocationCallBack = completion
        locationManager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate 델리게이트 구현

extension LocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            fetchLocationCallBack?(location)
            fetchLocationCallBack = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fetchLocationCallBack?(nil)
        fetchLocationCallBack = nil
        // TODO: - 실패 시 UI처리 필요
    }
}
