//
//  MakchaInfoUseCase.swift
//  Makcha
//
//  Created by 김영빈 on 5/9/24.
//

import Foundation

import RxCocoa
import RxRelay
import RxSwift

// MARK: - 막차 정보 관련 유즈케이스

final class MakchaInfoUseCase {
    
    private let transPathRepository: TransPathRepositoryProtocol
    private let endPointRepository: EndPointRepositoryProtocol
    
    let makchaInfo = PublishSubject<MakchaInfo>() // 막차 정보
    let startPoint = BehaviorRelay<EndPoint>(value: mockStartPoint) // 출발지 정보 // TODO: - 기본값 지정하기
    let destinationPoint: BehaviorRelay<EndPoint> // 도착지 정보
    
    private let disposeBag = DisposeBag()
    
    init(_ transPathRepository: TransPathRepositoryProtocol, _ endPointRepository: EndPointRepositoryProtocol) {
        self.transPathRepository = transPathRepository
        self.endPointRepository = endPointRepository
        
        // TODO: 사용자가 설정한 기본 목적지로 초기화하기
        let destionationCoordinate = mockDestinationPoint
        destinationPoint = BehaviorRelay<EndPoint>(value: destionationCoordinate)
    }
    
    func updateStartPointToSearchedLocation() {
        
    }
    
    func updateDestinationPointToSearchedLocation() {
        
    }
    
    // 막차 경로 검색
    func loadMakchaPath(start: XYCoordinate, end: XYCoordinate) {
        transPathRepository.getAllMakchaTransPath(start: start, end: end)
            .bind(to: makchaInfo)
            .disposed(by: disposeBag)
    }
    
    // 현재 위치 기반으로 막차 경로 불러오기
    func loadMakchaPathWithCurrentLocation() {
        print("[MakchaInfoUseCase] - 현재 위치 기반으로 막차 경로 불러오기")
        endPointRepository.getCurrentLocation()
            .do(
                onNext: { [weak self] currentLocation in
                    guard let destinationCoordinate = self?.destinationPoint.value.coordinate else { return }
                    self?.loadMakchaPath(start: currentLocation.coordinate, end: destinationCoordinate)
                }
            )
            .bind(to: startPoint)
            .disposed(by: disposeBag)
    }
    
    // 검색한 위치 기반으로 막차 경로 불러오기
    func loadMakchaPathWithSearchedLocation() {
        let start = startPoint.value.coordinate
        let end = destinationPoint.value.coordinate
        loadMakchaPath(start: start, end: end)
    }
}
