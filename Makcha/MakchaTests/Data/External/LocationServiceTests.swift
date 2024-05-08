//
//  LocationServiceTests.swift
//  MakchaTests
//
//  Created by 김영빈 on 5/5/24.
//

import XCTest
import CoreLocation
@testable import Makcha

protocol LocationManagerMockInterface: LocationManagerInterface {
    var locationToReturn: (() -> CLLocation?)? { get set }
    var authorizationStatusToReturn: CLAuthorizationStatus { get set }
}

// CLLocationManager 대신 동작할 Mock 객체
class LocationManagerMock: LocationManagerMockInterface {
    var locationManagerDelegate: LocationManagerDelegate?
    
    var locationToReturn: (() -> CLLocation?)? // 테스트 시 전달할 위치값
    var authorizationStatusToReturn: CLAuthorizationStatus = .notDetermined // 테스트 시 전달할 권한 상태
    
    func requestLocation() {
        if let location = locationToReturn?() {
            locationManagerDelegate?.locationManagerAbstract(self, didUpdateLocations: [location])
        } else {
            locationManagerDelegate?.locationManagerAbstract(self, didFailWithError: LocationServiceError.fetchFailed)
        }
    }
    
    func requestWhenInUseAuthorization() {
        locationManagerDelegate?.locationManagerAbstract(self, didChangeAuthorization: authorizationStatusToReturn)
    }
}

final class LocationServiceTests: XCTestCase {
    
    private var sut: LocationService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = LocationService(locationManager: LocationManagerMock())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        sut = nil
    }
    
      func test_fetchCurrentLocation을_호출시_위치가_반환됐을_때_위치정보가_제대로_전달되는지_확인() {
          // Given
          if var locationManagerMock = sut.locationManager as? LocationManagerMockInterface {
              locationManagerMock.locationToReturn = {
                  return CLLocation(latitude: 37.6134436427887, longitude: 126.926493082645) // locationManager가 반환할 위치값
              }
          }
          
          let expectedLocation = CLLocation(latitude: 37.6134436427887, longitude: 126.926493082645) // 기대값
          var result = CLLocation(latitude: 0.0, longitude: 0.0) // 반환 결과를 받을 변수
          let completionExpectation = expectation(description: "fetchCurrentLocation completion expectation")
          
          // When
          sut.fetchCurrentLocation { location, _ in
              if let location = location {
                  result = location
                  completionExpectation.fulfill()
              }
          }
          wait(for: [completionExpectation], timeout: 1)
          
          // Then
          XCTAssertEqual(result.coordinate.latitude, expectedLocation.coordinate.latitude)
          XCTAssertEqual(result.coordinate.longitude, expectedLocation.coordinate.longitude)
      }
    
    func test_fetchCurrentLocation을_호출시_위치가_반환되지_않으면_에러를_던지는지_확인() {
        // Given
        if var locationManagerMock = sut.locationManager as? LocationManagerMockInterface {
            locationManagerMock.locationToReturn = {
                return nil
            }
        }
        
        var result: (location:CLLocation?, error:Error?)
        let completionExpectation = expectation(description: "fetchCurrentLocation completion expectation")
        
        // When
        sut.fetchCurrentLocation { location, error in
            result.location = location
            result.error = error
            completionExpectation.fulfill()
        }
        wait(for: [completionExpectation], timeout: 1)
        
        // Then
        XCTAssertNil(result.location)
        XCTAssertNotNil(result.error)
    }
}
