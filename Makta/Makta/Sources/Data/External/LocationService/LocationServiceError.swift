//
//  LocationServiceError.swift
//  Makcha
//
//  Created by 김영빈 on 5/7/24.
//

// MARK: - 위치 서비스 사용 시 에러

enum LocationServiceError: Error {
    case fetchFailed
    case noLocationData
    case reverseGeocodingFailed
}
