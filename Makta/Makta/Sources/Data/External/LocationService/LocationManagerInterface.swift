//
//  LocationManagerInterface.swift
//  Makcha
//
//  Created by 김영빈 on 5/5/24.
//

// MARK: - LocationService에서 Core Location의 인터페이스를 추상화하기 위한 프로토콜 정의 및 설정

import CoreLocation

protocol LocationManagerInterface {
    var authorizationStatus: CLAuthorizationStatus { get }
    var locationManagerDelegate: LocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    func requestWhenInUseAuthorization()
    func requestLocation()
}

protocol LocationManagerDelegate: AnyObject {
    func locationManagerAbstract(_ manager: LocationManagerInterface, didChangeAuthorization status: CLAuthorizationStatus)
    func locationManagerAbstract(_ manager: LocationManagerInterface, didUpdateLocations locations: [CLLocation])
    func locationManagerAbstract(_ manager: LocationManagerInterface, didFailWithError error: Error)
}

extension CLLocationManager: LocationManagerInterface {
    var locationManagerDelegate: LocationManagerDelegate? {
        get {
            return delegate as? LocationManagerDelegate
        }
        set {
            delegate = newValue as? CLLocationManagerDelegate
        }
    }
}
